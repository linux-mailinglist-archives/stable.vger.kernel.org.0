Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F723E3566
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 15:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhHGNDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 09:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhHGNDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Aug 2021 09:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 614F06103B;
        Sat,  7 Aug 2021 13:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628341393;
        bh=9l3EJ0YBPIF1kfrYIR/gJmgGJa6PXd3PrWvodfL1AWQ=;
        h=Subject:To:From:Date:From;
        b=159TJhOr+87eyBSs7wM5wIctILg5lvIWHEQzXBUCrDfr3/U+lZw1YnWi/mh04EsCd
         8g8mpCIa0A8X63lZhQdyyApaF4lCiE4MAz98rPaWQPZKNz6T6+A5XhfAmCrdoSdSB0
         q+PhZEJGGEjKIvDl6fkrn3V2b7zGypieRjQN5JQk=
Subject: patch "nvmem: core: fix error handling while validating keepout regions" added to char-misc-next
To:     srinivas.kandagatla@linaro.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Aug 2021 15:02:59 +0200
Message-ID: <162834137973105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nvmem: core: fix error handling while validating keepout regions

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From de0534df93474f268486c486ea7e01b44a478026 Mon Sep 17 00:00:00 2001
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Date: Fri, 6 Aug 2021 09:59:47 +0100
Subject: nvmem: core: fix error handling while validating keepout regions

Current error path on failure of validating keepout regions is calling
put_device, eventhough the device is not even registered at that point.

Fix this by adding proper error handling of freeing ida and nvmem.

Fixes: fd3bb8f54a88 ("nvmem: core: Add support for keepout regions")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210806085947.22682-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index b3bc30a04ed7..3d87fadaa160 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -824,8 +824,11 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	if (nvmem->nkeepout) {
 		rval = nvmem_validate_keepouts(nvmem);
-		if (rval)
-			goto err_put_device;
+		if (rval) {
+			ida_free(&nvmem_ida, nvmem->id);
+			kfree(nvmem);
+			return ERR_PTR(rval);
+		}
 	}
 
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
-- 
2.32.0


