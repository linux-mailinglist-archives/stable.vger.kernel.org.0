Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35ADACDC2
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387507AbfIHMxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387448AbfIHMxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:53:11 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 859EA2196F;
        Sun,  8 Sep 2019 12:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947191;
        bh=9qZaXUcIS1VhdeTvIeC/wQSRr4d1JEXwODCu9R6q8QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldpBJLpyKFKU94NxAUfmWe9+Ap1uhhaHuuwWbEVW2gTrJsKxROxtM6D754sUl7Gjd
         pcVQj1R78o77+LUaBlQgT/OJE/UHWJ+GbGZrFcYgSY37MU8UWOMQatZHsf+WyfySw9
         pznqMfvLuGl2AvBqerXSZxFsrLUOnKDzg84OZ5/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kaisrlik <ja.kaisrlik@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.2 94/94] Revert "mmc: core: do not retry CMD6 in __mmc_switch()"
Date:   Sun,  8 Sep 2019 13:42:30 +0100
Message-Id: <20190908121153.122988057@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kaisrlik <ja.kaisrlik@gmail.com>

commit 8ad8e02c2fa70cfddc1ded53ba9001c9d444075d upstream.

Turns out the commit 3a0681c7448b ("mmc: core: do not retry CMD6 in
__mmc_switch()") breaks initialization of a Toshiba THGBMNG5 eMMC card,
when using the meson-gx-mmc.c driver on a custom board based on Amlogic
A113D.

The CMD6 that switches the card into HS200 mode is then one that fails and
according to the below printed messages from the log:

[    1.648951] mmc0: mmc_select_hs200 failed, error -84
[    1.648988] mmc0: error -84 whilst initialising MMC card

After some analyze, it turns out that adding a delay of ~5ms inside
mmc_select_bus_width() but after mmc_compare_ext_csds() has been executed,
also fixes the problem. Adding yet some more debug code, trying to figure
out if potentially the card could be in a busy state, both by using CMD13
and ->card_busy() ops concluded that this was not the case.

Therefore, let's simply revert the commit that dropped support for retrying
of CMD6, as this also fixes the problem.

Fixes: 3a0681c7448b ("mmc: core: do not retry CMD6 in __mmc_switch()")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Kaisrlik <ja.kaisrlik@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/mmc_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -564,7 +564,7 @@ int __mmc_switch(struct mmc_card *card,
 	if (index == EXT_CSD_SANITIZE_START)
 		cmd.sanitize_busy = true;
 
-	err = mmc_wait_for_cmd(host, &cmd, 0);
+	err = mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
 	if (err)
 		goto out;
 


