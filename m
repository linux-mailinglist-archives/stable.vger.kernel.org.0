Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8018AD30
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 08:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgCSHN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 03:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbgCSHN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 03:13:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C84762071C;
        Thu, 19 Mar 2020 07:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584602007;
        bh=JjTuaOBR4uqXU5rvxfAWZ32sqfXngxYpMYCMCGV0hKc=;
        h=Subject:To:From:Date:From;
        b=GkLvCebKQxJ6AnSdNnukVcb2v/BQkYgujWNxAcqorgVHKCLEquKef4hn3EaO1V3ex
         SCyky8V3tklvHkrMHuFyLR+X2cV6Wi8wZ/MpQ97skKf0VYLgJGU8YYb4ok6+u3+2ws
         DXYMyhFEbO84uYzWjqLUjS+jVo1cuKrRFcRX7PIA=
Subject: patch "nvmem: release the write-protect pin" added to char-misc-next
To:     ktouil@baylibre.com, bgolaszewski@baylibre.com,
        geert@linux-m68k.org, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Mar 2020 08:12:25 +0100
Message-ID: <1584601945129186@kroah.com>
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From a9c3766cb19cdadf2776aba41b64470002645894 Mon Sep 17 00:00:00 2001
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
2.25.2


