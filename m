Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF43C9EBA
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhGOMi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhGOMiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB4F861178;
        Thu, 15 Jul 2021 12:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626352532;
        bh=uvJGinwn6rQVh2gEm7LdW+WFljSOvwtmkc1QecOWpPA=;
        h=Subject:To:Cc:From:Date:From;
        b=OCtMJ79/JIIS/Xvd4hkKH/bzXa6OsVmSDxeQRj+ocQESY4TbDwHxYNMnxJA+UHp+R
         t0KO4KS96CuB3aA8L7PqvmYgC0suAjCmRhj3drnNEs+JkmggWs7ar7ypWhgTD/WFg9
         mtAlB4xqFh8ZUKf2Hrg1eyla0iuubZIgS4jMjy8w=
Subject: FAILED: patch "[PATCH] mmc: core: clear flags before allowing to retune" failed to apply to 4.4-stable tree
To:     wsa+renesas@sang-engineering.com, adrian.hunter@intel.com,
        ulf.hansson@linaro.org, yoshihiro.shimoda.uh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 14:35:29 +0200
Message-ID: <16263525291939@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 77347eda64ed5c9383961d1de9165f9d0b7d8df6 Mon Sep 17 00:00:00 2001
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
Date: Thu, 24 Jun 2021 17:16:14 +0200
Subject: [PATCH] mmc: core: clear flags before allowing to retune

It might be that something goes wrong during tuning so the MMC core will
immediately trigger a retune. In our case it was:

 - we sent a tuning block
 - there was an error so we need to send an abort cmd to the eMMC
 - the abort cmd had a CRC error
 - retune was set by the MMC core

This lead to a vicious circle causing a performance regression of 75%.
So, clear retuning flags before we enable retuning to start with a known
cleared state.

Reported-by Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210624151616.38770-2-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index b039dcff17f8..95fedcf56e4a 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -937,11 +937,14 @@ int mmc_execute_tuning(struct mmc_card *card)
 
 	err = host->ops->execute_tuning(host, opcode);
 
-	if (err)
+	if (err) {
 		pr_err("%s: tuning execution failed: %d\n",
 			mmc_hostname(host), err);
-	else
+	} else {
+		host->retune_now = 0;
+		host->need_retune = 0;
 		mmc_retune_enable(host);
+	}
 
 	return err;
 }

