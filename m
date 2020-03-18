Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0274189C75
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 14:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCRNBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 09:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgCRNBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 09:01:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66B5F20724;
        Wed, 18 Mar 2020 13:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584536498;
        bh=oNdf9fJCpJ1xs5gW/NmX0pT8qC2FgBMHURkq5NGA7eU=;
        h=Subject:To:From:Date:From;
        b=Uly4CVKnl3YFHJaOK41h3rvjx48Ocb6k2EHxZgO6ZKk3hWqFCmJuHFuuMUfel3do0
         4CwdLAW/y/Vc1vb5JgqoqyByOHPeKShl8Z27ko+oIkDbrsVI4USMShbvT8P7M9bcPd
         yhLfonjwhM9r6fr5Odhov6O73jiDFAcOnPCMGavU=
Subject: patch "nvmem: release the write-protect pin" added to char-misc-testing
To:     ktouil@baylibre.com, bgolaszewski@baylibre.com,
        geert@linux-m68k.org, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 14:01:21 +0100
Message-ID: <158453648135195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nvmem: release the write-protect pin

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 6f57cbd7ce40323eacf542392bfa70ff2cb42c2a Mon Sep 17 00:00:00 2001
From: Khouloud Touil <ktouil@baylibre.com>
Date: Tue, 10 Mar 2020 13:22:50 +0000
Subject: nvmem: release the write-protect pin

Put the write-protect GPIO descriptor in nvmem_release() so that it can
be automatically released when the associated device's reference count
drops to 0.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Khouloud Touil <ktouil@baylibre.com>
Cc: stable <stable@vger.kernel.org>
[Bartosz: tweak the commit message]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200310132257.23358-8-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 2758d90d63b7..c05c4f4a7b9e 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -72,6 +72,7 @@ static void nvmem_release(struct device *dev)
 	struct nvmem_device *nvmem = to_nvmem_device(dev);
 
 	ida_simple_remove(&nvmem_ida, nvmem->id);
+	gpiod_put(nvmem->wp_gpio);
 	kfree(nvmem);
 }
 
-- 
2.25.1


