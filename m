Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D85B450E62
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbhKOSOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238555AbhKOSHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFFEB63314;
        Mon, 15 Nov 2021 17:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998297;
        bh=HAE1uLHAMNhtS2u1iqMWBioxpDilE97TU/dWJWCFxF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rF/nhxnWTKS7xMFx+vksTJSt2yDDN+FT0IFzDV6D5rge0wHqc7Ve/o0AGt0n4lZKx
         bSCFrBb38ibmOp9uAM2SqFyPoy73l6H1hXU8vAVEP/5TUVrjQkPxU8p+jNLPjj6CjV
         fa2D8a7kgrNXJL8xQB2j1eQhYAas2D8uVgY9j8FQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrej Shadura <andrew.shadura@collabora.co.uk>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/575] HID: u2fzero: clarify error check and length calculations
Date:   Mon, 15 Nov 2021 18:03:03 +0100
Message-Id: <20211115165359.580198405@linuxfoundation.org>
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

From: Andrej Shadura <andrew.shadura@collabora.co.uk>

[ Upstream commit b7abf78b7a6c4a29a6e0ba0bb883fe44a2f3d693 ]

The previous commit fixed handling of incomplete packets but broke error
handling: offsetof returns an unsigned value (size_t), but when compared
against the signed return value, the return value is interpreted as if
it were unsigned, so negative return values are never less than the
offset.

To make the code easier to read, calculate the minimal packet length
once and separately, and assign it to a signed int variable to eliminate
unsigned math and the need for type casts. It then becomes immediately
obvious how the actual data length is calculated and why the return
value cannot be less than the minimal length.

Fixes: 22d65765f211 ("HID: u2fzero: ignore incomplete packets without data")
Fixes: 42337b9d4d95 ("HID: add driver for U2F Zero built-in LED and RNG")
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-u2fzero.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
index d70cd3d7f583b..94f78ffb76d04 100644
--- a/drivers/hid/hid-u2fzero.c
+++ b/drivers/hid/hid-u2fzero.c
@@ -191,6 +191,8 @@ static int u2fzero_rng_read(struct hwrng *rng, void *data,
 	struct u2f_hid_msg resp;
 	int ret;
 	size_t actual_length;
+	/* valid packets must have a correct header */
+	int min_length = offsetof(struct u2f_hid_msg, init.data);
 
 	if (!dev->present) {
 		hid_dbg(dev->hdev, "device not present");
@@ -200,12 +202,12 @@ static int u2fzero_rng_read(struct hwrng *rng, void *data,
 	ret = u2fzero_recv(dev, &req, &resp);
 
 	/* ignore errors or packets without data */
-	if (ret < offsetof(struct u2f_hid_msg, init.data))
+	if (ret < min_length)
 		return 0;
 
 	/* only take the minimum amount of data it is safe to take */
-	actual_length = min3((size_t)ret - offsetof(struct u2f_hid_msg,
-		init.data), U2F_HID_MSG_LEN(resp), max);
+	actual_length = min3((size_t)ret - min_length,
+		U2F_HID_MSG_LEN(resp), max);
 
 	memcpy(data, resp.init.data, actual_length);
 
-- 
2.33.0



