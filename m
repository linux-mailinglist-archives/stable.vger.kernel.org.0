Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F70655CF
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfGKLfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 07:35:30 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:51553 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728147AbfGKLf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 07:35:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CCFF94BE;
        Thu, 11 Jul 2019 07:35:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 11 Jul 2019 07:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=K/a/OC
        3E4WUTRStR2pAcpFQZ0e01R+eXZImQKfNsXw0=; b=NO6eigrFIE0TIhacrL43I/
        HmUFBDdStJN9trpX7j6eqO1ryqX/U4KOhC26JGyER+tNSo16ITP/Cbq5ROOf93dh
        ScRjdILjQHQVGZV0E0M9dl0po7Ed3EQV5/BfhVN9Q5PCBwtNls/85chYILJ7eaJm
        E6/8Mt2kNhLaoZ6uwca8hu6znItzzjxX5/AcoIeqDYDxLG6qRGArlZdEkjQmxnca
        CwBROgZZ5N+qk8JnpJN2x16bzt0jP5I6jmODy/dSTaDuj5bdsXD6Bncf1r5KAvxr
        EgTYNoG0mVle1mBm7LyiPFVFPPXBHStTkJa5MpWTAoAR99a5ifzfRrtbNWpapoQQ
        ==
X-ME-Sender: <xms:AB8nXXCmWFXI44Qj9ijSyM6EDOl-Hc4fCeOKOCHSUes5Jda--Z6cmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgeekgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:AB8nXRxzrCwOEvRuaEUgLisR9azFUhe4r7t7JvpIgog9AlRPFKwCVg>
    <xmx:AB8nXdkXUxxyJ9ood38l3RABvTY7fBbBTqhNQgK3iOQlsPUH509eYA>
    <xmx:AB8nXeEm2e_ZpEK7wqcXt7GlE6RreOR1oSQCX9kfXlM-IzzW3b0KcA>
    <xmx:AB8nXbQLiwOcnYPbZ3vytZSkqQJwimuyrc0WPVWlRfZ2AATlZj7mbQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E23618005B;
        Thu, 11 Jul 2019 07:35:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM" failed to apply to 4.9-stable tree
To:     sukhomlinov@google.com, dianders@chromium.org,
        jarkko.sakkinen@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Jul 2019 13:35:16 +0200
Message-ID: <1562844916186241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

