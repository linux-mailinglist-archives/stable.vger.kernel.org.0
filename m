Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8638EFEF
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhEXQA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhEXP7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D7B61970;
        Mon, 24 May 2021 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871126;
        bh=aRb4XaPNPNvtNBOkWN0o6Tw4BKet47X0970O94xh08A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cr4gKWldyAlcA/RJPud0S9My+jr8AT0r4xm8x0AjNs+gDquDT8eUCFAurJgrMg73Z
         L3cZndLu38Mru9Cr03LKNpG04HoBgGiB4PGrDZslcwssDU9Gb0VDlScRahasCFHQKI
         HZmRKi5eWW+DgI7rFGy6dXcCvk1cFG5mtagvBbKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.12 085/127] mmc: meson-gx: make replace WARN_ONCE with dev_warn_once about scatterlist offset alignment
Date:   Mon, 24 May 2021 17:26:42 +0200
Message-Id: <20210524152337.735569038@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit cabb1bb60e88ccaaa122ba01862403cd44e8e8f8 upstream.

Some drivers like ath10k can sometimg give an sg buffer with an offset whose alignment
is not compatible with the Amlogic DMA descriptor engine requirements.

Simply replace with dev_warn_once() to inform user this should be fixed to avoid
degraded performance.

This should be ultimately fixed in ath10k, but since it's only a performance issue
the warning should be removed.

Fixes: 79ed05e329c3 ("mmc: meson-gx: add support for descriptor chain mode")
Cc: stable@vger.kernel.org
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20210426175559.3110575-1-narmstrong@baylibre.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -258,7 +258,9 @@ static void meson_mmc_get_transfer_mode(
 	for_each_sg(data->sg, sg, data->sg_len, i) {
 		/* check for 8 byte alignment */
 		if (sg->offset % 8) {
-			WARN_ONCE(1, "unaligned scatterlist buffer\n");
+			dev_warn_once(mmc_dev(mmc),
+				      "unaligned sg offset %u, disabling descriptor DMA for transfer\n",
+				      sg->offset);
 			return;
 		}
 	}


