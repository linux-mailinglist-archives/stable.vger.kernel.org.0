Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB55433A5E
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 17:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhJSPbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 11:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhJSPbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 11:31:39 -0400
Received: from cambridge.shadura.me (cambridge.shadura.me [IPv6:2a00:1098:0:86:1000:13:0:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C55C06161C;
        Tue, 19 Oct 2021 08:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=shadura.me;
         s=a; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:
        From:Content-Type:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
        References; bh=LsStX3N83EwMbgWWiXAnsz0OEPMzhSd+2H5bAfwboH0=; b=IAEapUkr7LF2gd
        3ZsXzD5IFUpmJ607HoRV0bevz1/I0r3bfMR3ToVGcDJxoTxREbH/RuCsSg2aWOE1y+q+cEk/H0Yto
        ONw9BOiFoxfY9b4WzaTVZefaMIZqNkfQ+rNF8mvyvRLk4XdQMVoLfEGyZawoFHaEnq2L7JkVZDq5S
        er8=;
Received: from 178-143-43-60.dynamic.orange.sk ([178.143.43.60] helo=localhost)
        by cambridge.shadura.me with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <andrew@shadura.me>)
        id 1mcr3M-0002yO-32; Tue, 19 Oct 2021 17:29:24 +0200
From:   Andrej Shadura <andrew.shadura@collabora.co.uk>
To:     =?UTF-8?q?Ji=C5=99=C3=AD=20Kosina?= <jikos@kernel.org>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, kernel@collabora.com,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v3 1/2] HID: u2fzero: clarify error check and length calculations
Date:   Tue, 19 Oct 2021 17:29:16 +0200
Message-Id: <20211019152917.79666-1-andrew.shadura@collabora.co.uk>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/hid/hid-u2fzero.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
index d70cd3d7f583..94f78ffb76d0 100644
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

