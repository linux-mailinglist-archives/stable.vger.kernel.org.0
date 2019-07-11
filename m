Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79641655CE
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfGKLf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 07:35:28 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33439 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728026AbfGKLf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 07:35:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E0BE14C4;
        Thu, 11 Jul 2019 07:35:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 11 Jul 2019 07:35:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kp5Vrr
        PcoT5tyiJcQ4Bj2lY0+dqgJzcepuiV+ZzgQWs=; b=XDmKx/TerYswW0ItBIzsms
        jkIQJfZtqnzKikjPbyMQGitVIoG3PlZsWqVYf54nWttSVQ8/YPysLVqCZLienzPn
        XVCtSGvDw+OTtDZzG4Q0PTdzNYHr7dg/F/Ka0hUhyCzhx5AGR/1jz+DRTlRmeRJE
        hpRSQa9pjJfJcdxC8so2VXVbHI81P4anx0AC7zOPTmc7NRYBeUL+gumxPorm5gwX
        I1fN969XNNff8psxCmBeFc1SLiM9mjesKh13GLHv9/nEKsNnK+n4jKckFzxjC9RC
        MXUJWH/dx8v7ReeQcAZbjN7RisTY7oqUeZzY6b+roPOMBeqBvBs+AQf0sMW555tw
        ==
X-ME-Sender: <xms:_h4nXUyvI6EP5N8InIPrnIlgSUbnMRkss-CibDvoiNLSpMjhX4P8ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgeekgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:_h4nXVdC-EMdjsxr4NAz-YjjtLoL-dC8Aa454eTxGUjGBLrm73LyYw>
    <xmx:_h4nXa3hOY5jzGK1wJO1ROGXbSw2H5wXeWmoQBQcVl-pKEh241ejsw>
    <xmx:_h4nXeuLq7Y9DOGehsC2wuZ9fVGBCl5IFYKewXhydot-J1QOw9gI-A>
    <xmx:_h4nXQYSjkeSXUHLQxkzDe-GPsZmzQ-3Ys6_d_OjiAmv9aJ_tSAhGQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 063138005C;
        Thu, 11 Jul 2019 07:35:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM" failed to apply to 4.14-stable tree
To:     sukhomlinov@google.com, dianders@chromium.org,
        jarkko.sakkinen@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Jul 2019 13:35:16 +0200
Message-ID: <1562844916127106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From db4d8cb9c9f2af71c4d087817160d866ed572cc9 Mon Sep 17 00:00:00 2001
From: Vadim Sukhomlinov <sukhomlinov@google.com>
Date: Mon, 10 Jun 2019 15:01:18 -0700
Subject: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
 operations

TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
future TPM operations. TPM 1.2 behavior was different, future TPM
operations weren't disabled, causing rare issues. This patch ensures
that future TPM operations are disabled.

Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
Cc: stable@vger.kernel.org
Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
[dianders: resolved merge conflicts with mainline]
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 90325e1749fb..d47ad10a35fe 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -289,15 +289,15 @@ static int tpm_class_shutdown(struct device *dev)
 {
 	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
 
+	down_write(&chip->ops_sem);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		down_write(&chip->ops_sem);
 		if (!tpm_chip_start(chip)) {
 			tpm2_shutdown(chip, TPM2_SU_CLEAR);
 			tpm_chip_stop(chip);
 		}
-		chip->ops = NULL;
-		up_write(&chip->ops_sem);
 	}
+	chip->ops = NULL;
+	up_write(&chip->ops_sem);
 
 	return 0;
 }

