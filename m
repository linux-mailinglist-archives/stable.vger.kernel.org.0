Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD04C991F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 09:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfJCHqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 03:46:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39915 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725907AbfJCHqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 03:46:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4713621CFD;
        Thu,  3 Oct 2019 03:46:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 03:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SAOjmy
        Lm1gv5l4GyGuImDgq7oOETwNiFdFhFj0WBKFs=; b=AvcfiTt6slBtIIkStovo+o
        scLublaktaSgRlw0LzYZhC6czZ0dyTfBWJiYVKBonUJuiMvwpkM+jSXkChe1/7up
        5o3cotN8Z3AEnClb3VFHQhFJyqyJJaqBlyZ19rW8aEIvdpyzPlZtROCDXAeiWA19
        hxeYqyIZTrWiiTa0+X83gpsQjC/tRFbPFNYhEFDzR9bffxFI8PvlhdLyOSeDGCRG
        xMHeBU2ak6mrgYmHJjIhUXRFDKzLnHlfxTsY2kN53HQyzA6l7Kj9x0p8CGO6sVFG
        AUbqfUHJm/dYc8H2j8CEJLyriw5rEmV69fuu4Tm+KRF0F1bskhQ2WthiVnqo05WQ
        ==
X-ME-Sender: <xms:YaeVXRyTdmqZqeoe3If2QLoMLUQuS5aa5HBfblkEYV5v8bOaDR_Vsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:YaeVXXkT4VXDZsfo8hZaRRuPW2wF08n3uQ2MzBLSb6joqX2N0HSbqw>
    <xmx:YaeVXRV2bJuFHNEkdJG0QVGtuQAb3TQ1G-WT6krMU1z3uyQ92tQVFA>
    <xmx:YaeVXQ3GnQ-g93LYIhdkGhNxyhdHST9UObG17uHgzBPojjNepWUhTQ>
    <xmx:YaeVXaX9aYdT53Ue5XAELIZZT5yQJXn45LXq2MDyjzNnB8biG12CeQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBFD78005C;
        Thu,  3 Oct 2019 03:46:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for" failed to apply to 4.9-stable tree
To:     stefanb@linux.ibm.com, jarkko.sakkinen@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 09:46:29 +0200
Message-ID: <1570088789234154@kroah.com>
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

From 1ea32c83c699df32689d329b2415796b7bfc2f6e Mon Sep 17 00:00:00 2001
From: Stefan Berger <stefanb@linux.ibm.com>
Date: Thu, 29 Aug 2019 20:09:06 -0400
Subject: [PATCH] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for
 interrupts

The tpm_tis_core has to set the TPM_CHIP_FLAG_IRQ before probing for
interrupts since there is no other place in the code that would set
it.

Cc: linux-stable@vger.kernel.org
Fixes: 570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index ffa9048d8f6c..270f43acbb77 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -981,6 +981,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		}
 
 		tpm_chip_start(chip);
+		chip->flags |= TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);

