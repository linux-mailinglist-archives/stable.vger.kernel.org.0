Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C731A29B6D5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368722AbgJ0P1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797739AbgJ0PZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8898820728;
        Tue, 27 Oct 2020 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812311;
        bh=6LFXPfRjaXr/B6QXua9ug/OO8Xomm+86NfxiDEDLi6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq0+qAkAp5RMPzbXNwpGmPiJ5obhe87PT588vcJ4/X9gEue5BoDJX03+1lNaB2v8X
         aTxfeXm/8q1jkpY3D0veMlnh/0qEirVf0mHoPYm0mrDl9YHmeXUg8TOYmvYXnR6WY0
         WCbdh/6RElSZpX1/nbibMJTRtPclqev2CbYVGEmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 164/757] media: tc358743: cleanup tc358743_cec_isr
Date:   Tue, 27 Oct 2020 14:46:54 +0100
Message-Id: <20201027135458.287102730@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 877cb8a444dad2304e891294afb0915fe3c278d6 ]

tc358743_cec_isr is misnammed, it is not the main isr.
So rename it to be consistent with its siblings,
tc358743_cec_handler.

It also does not check if its input parameter 'handled' is
is non NULL like its siblings, so add a check.

Fixes: a0ec8d1dc42e ("media: tc358743: add CEC support")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358743.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 211caade9f998..cff99cf61ed4d 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -919,8 +919,8 @@ static const struct cec_adap_ops tc358743_cec_adap_ops = {
 	.adap_monitor_all_enable = tc358743_cec_adap_monitor_all_enable,
 };
 
-static void tc358743_cec_isr(struct v4l2_subdev *sd, u16 intstatus,
-			     bool *handled)
+static void tc358743_cec_handler(struct v4l2_subdev *sd, u16 intstatus,
+				 bool *handled)
 {
 	struct tc358743_state *state = to_state(sd);
 	unsigned int cec_rxint, cec_txint;
@@ -953,7 +953,8 @@ static void tc358743_cec_isr(struct v4l2_subdev *sd, u16 intstatus,
 			cec_transmit_attempt_done(state->cec_adap,
 						  CEC_TX_STATUS_ERROR);
 		}
-		*handled = true;
+		if (handled)
+			*handled = true;
 	}
 	if ((intstatus & MASK_CEC_RINT) &&
 	    (cec_rxint & MASK_CECRIEND)) {
@@ -968,7 +969,8 @@ static void tc358743_cec_isr(struct v4l2_subdev *sd, u16 intstatus,
 			msg.msg[i] = v & 0xff;
 		}
 		cec_received_msg(state->cec_adap, &msg);
-		*handled = true;
+		if (handled)
+			*handled = true;
 	}
 	i2c_wr16(sd, INTSTATUS,
 		 intstatus & (MASK_CEC_RINT | MASK_CEC_TINT));
@@ -1432,7 +1434,7 @@ static int tc358743_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 
 #ifdef CONFIG_VIDEO_TC358743_CEC
 	if (intstatus & (MASK_CEC_RINT | MASK_CEC_TINT)) {
-		tc358743_cec_isr(sd, intstatus, handled);
+		tc358743_cec_handler(sd, intstatus, handled);
 		i2c_wr16(sd, INTSTATUS,
 			 intstatus & (MASK_CEC_RINT | MASK_CEC_TINT));
 		intstatus &= ~(MASK_CEC_RINT | MASK_CEC_TINT);
-- 
2.25.1



