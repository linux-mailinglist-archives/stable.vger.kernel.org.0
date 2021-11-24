Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D6845BBDF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243876AbhKXMZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244009AbhKXMWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:22:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55E48611CA;
        Wed, 24 Nov 2021 12:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756008;
        bh=PibUv0jTdS2aj5X7T4Ue1GF9NhbwMgOrboDtX3UWW/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGnMLbuCv40sLbBFaG9j+rRL6FK+Yg10TSAeKPsTrp9gpfebTcFelsA30hEOQ9+3D
         vRUaR9PawkNIf1VYvDnre/qR5OBRLzEObaD+9k9D3lQjnfJPjbxZ06xRP+jD7qFbP+
         aCkmZiirRdepKgXH1pHzzQoueRqYZbnXpoExOxBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 137/207] auxdisplay: img-ascii-lcd: Fix lock-up when displaying empty string
Date:   Wed, 24 Nov 2021 12:56:48 +0100
Message-Id: <20211124115708.464628882@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit afcb5a811ff3ab3969f09666535eb6018a160358 ]

While writing an empty string to a device attribute is a no-op, and thus
does not need explicit safeguards, the user can still write a single
newline to an attribute file:

    echo > .../message

If that happens, img_ascii_lcd_display() trims the newline, yielding an
empty string, and causing an infinite loop in img_ascii_lcd_scroll().

Fix this by adding a check for empty strings.  Clear the display in case
one is encountered.

Fixes: 0cad855fbd083ee5 ("auxdisplay: img-ascii-lcd: driver for simple ASCII LCD displays")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/img-ascii-lcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/auxdisplay/img-ascii-lcd.c b/drivers/auxdisplay/img-ascii-lcd.c
index 6e8eaa7fe7a6f..b5f849d2f7623 100644
--- a/drivers/auxdisplay/img-ascii-lcd.c
+++ b/drivers/auxdisplay/img-ascii-lcd.c
@@ -283,6 +283,16 @@ static int img_ascii_lcd_display(struct img_ascii_lcd_ctx *ctx,
 	if (msg[count - 1] == '\n')
 		count--;
 
+	if (!count) {
+		/* clear the LCD */
+		devm_kfree(&ctx->pdev->dev, ctx->message);
+		ctx->message = NULL;
+		ctx->message_len = 0;
+		memset(ctx->curr, ' ', ctx->cfg->num_chars);
+		ctx->cfg->update(ctx);
+		return 0;
+	}
+
 	new_msg = devm_kmalloc(&ctx->pdev->dev, count + 1, GFP_KERNEL);
 	if (!new_msg)
 		return -ENOMEM;
-- 
2.33.0



