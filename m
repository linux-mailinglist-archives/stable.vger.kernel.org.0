Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2117D450DF0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhKOSJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:09:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239731AbhKOSEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4689163281;
        Mon, 15 Nov 2021 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997924;
        bh=MRmyVNWLYZP3PVQ5hNg/uZBhsR/Ae5pdQj8v4m9IG8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FulNSemVxkK6naKF1KgLAhcnMFqIi788CUUXQbQWDxtj6WkyL9VgqK0dNMWaSNtJV
         hEqVOE15BZY+m+3qzbUWNfuakMtVQNQEbo5kxnEm4qewY+gQwWti70qL18o2bEmmmb
         XXM5eqmRGgO44nExx6QOvNgni3YwYjv2I2+QAw6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/575] media: TDA1997x: handle short reads of hdmi info frame.
Date:   Mon, 15 Nov 2021 18:00:17 +0100
Message-Id: <20211115165353.873167576@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 48d219f9cc667bc6fbc3e3af0b1bfd75db94fce4 ]

Static analysis reports this representative problem

tda1997x.c:1939: warning: 7th function call argument is an uninitialized
value

The 7th argument is buffer[0], which is set in the earlier call to
io_readn().  When io_readn() call to io_read() fails with the first
read, buffer[0] is not set and 0 is returned and stored in len.

The later call to hdmi_infoframe_unpack()'s size parameter is the
static size of buffer, always 40, so a short read is not caught
in hdmi_infoframe_unpacks()'s checking.  The variable len should be
used instead.

Zero initialize buffer to 0 so it is in a known start state.

Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tda1997x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index 17cc69c3227f8..8476330964fc7 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -1247,13 +1247,13 @@ tda1997x_parse_infoframe(struct tda1997x_state *state, u16 addr)
 {
 	struct v4l2_subdev *sd = &state->sd;
 	union hdmi_infoframe frame;
-	u8 buffer[40];
+	u8 buffer[40] = { 0 };
 	u8 reg;
 	int len, err;
 
 	/* read data */
 	len = io_readn(sd, addr, sizeof(buffer), buffer);
-	err = hdmi_infoframe_unpack(&frame, buffer, sizeof(buffer));
+	err = hdmi_infoframe_unpack(&frame, buffer, len);
 	if (err) {
 		v4l_err(state->client,
 			"failed parsing %d byte infoframe: 0x%04x/0x%02x\n",
@@ -1927,13 +1927,13 @@ static int tda1997x_log_infoframe(struct v4l2_subdev *sd, int addr)
 {
 	struct tda1997x_state *state = to_state(sd);
 	union hdmi_infoframe frame;
-	u8 buffer[40];
+	u8 buffer[40] = { 0 };
 	int len, err;
 
 	/* read data */
 	len = io_readn(sd, addr, sizeof(buffer), buffer);
 	v4l2_dbg(1, debug, sd, "infoframe: addr=%d len=%d\n", addr, len);
-	err = hdmi_infoframe_unpack(&frame, buffer, sizeof(buffer));
+	err = hdmi_infoframe_unpack(&frame, buffer, len);
 	if (err) {
 		v4l_err(state->client,
 			"failed parsing %d byte infoframe: 0x%04x/0x%02x\n",
-- 
2.33.0



