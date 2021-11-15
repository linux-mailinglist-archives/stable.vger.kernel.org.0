Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BEE4525E7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345983AbhKPB76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239634AbhKOSIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:08:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16E5D633B1;
        Mon, 15 Nov 2021 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998379;
        bh=3QZfEHTy8x3dW9yDMXvdUiQZmoEHmzkyzYm70Df/AJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zd8oD1SM6edm/MeBuIEt7gV9Ifldgn9l0IBabNQ+3C6/v0wdfdwdDf0A/IDRzi2UF
         9ZHJsPGfaYS4DRNv4MKqn+/0o2OvoPF+hij9cF/Fu6rvywr0FbNqnT7vwbVY0cpcFT
         iDuu6tc1BNGsDb8EmfGrOc0kBYZvD6LgGqaTvNw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/575] auxdisplay: img-ascii-lcd: Fix lock-up when displaying empty string
Date:   Mon, 15 Nov 2021 18:03:33 +0100
Message-Id: <20211115165400.576625924@linuxfoundation.org>
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
index 1cce409ce5cac..e33ce0151cdfd 100644
--- a/drivers/auxdisplay/img-ascii-lcd.c
+++ b/drivers/auxdisplay/img-ascii-lcd.c
@@ -280,6 +280,16 @@ static int img_ascii_lcd_display(struct img_ascii_lcd_ctx *ctx,
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



