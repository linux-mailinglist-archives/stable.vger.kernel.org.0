Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679F2431957
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 14:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhJRMkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 08:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhJRMkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 08:40:23 -0400
X-Greylist: delayed 949 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Oct 2021 05:38:12 PDT
Received: from cambridge.shadura.me (cambridge.shadura.me [IPv6:2a00:1098:0:86:1000:13:0:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEECC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 05:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=shadura.me;
         s=a; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:
        From:Content-Type:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
        References; bh=i6esfBNpPCgzAT136lKF35EUjLZx4SI1QIxginORRls=; b=UmDf3W7SO23Pef
        3swOUScXekg6aDBGIzIZ2UVbTh5js+Q8tLPXMDNHe4i7rkOKYXfvT3kMfylFGvUK0oDP2Ku+AiQUO
        OVOqyLmGiVyP0N1rZHs4/N4graICySPrRQrcVMc8bEaC2nhxWoN5iRKcXnyi3ismTMjd/reDLG7fu
        47s=;
Received: from 85-237-234-127.dynamic.orange.sk ([85.237.234.127] helo=localhost)
        by cambridge.shadura.me with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <andrew@shadura.me>)
        id 1mcRen-0001o4-9C; Mon, 18 Oct 2021 14:22:21 +0200
From:   Andrej Shadura <andrew.shadura@collabora.co.uk>
To:     =?UTF-8?q?Ji=C5=99=C3=AD=20Kosina?= <jikos@kernel.org>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, kernel@collabora.com
Subject: [PATCH v2 1/2] HID: u2fzero: explicitly check for errors
Date:   Mon, 18 Oct 2021 14:21:43 +0200
Message-Id: <20211018122144.25131-1-andrew.shadura@collabora.co.uk>
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

Fixes: 22d65765f211 ("HID: u2fzero: ignore incomplete packets without data")
Fixes: 42337b9d4d95 ("HID: add driver for U2F Zero built-in LED and RNG")
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
---
 drivers/hid/hid-u2fzero.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
index d70cd3d7f583..5145d758bea0 100644
--- a/drivers/hid/hid-u2fzero.c
+++ b/drivers/hid/hid-u2fzero.c
@@ -200,7 +200,7 @@ static int u2fzero_rng_read(struct hwrng *rng, void *data,
 	ret = u2fzero_recv(dev, &req, &resp);
 
 	/* ignore errors or packets without data */
-	if (ret < offsetof(struct u2f_hid_msg, init.data))
+	if (ret < 0 || ret < offsetof(struct u2f_hid_msg, init.data))
 		return 0;
 
 	/* only take the minimum amount of data it is safe to take */
-- 
2.33.0

