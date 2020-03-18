Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE5189C77
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 14:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCRNBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 09:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbgCRNBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 09:01:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A0C220724;
        Wed, 18 Mar 2020 13:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584536514;
        bh=xVy8/c6RcnNZHG4RHZQAArMMYOr+Ikauroo+w0ChZeM=;
        h=Subject:To:From:Date:From;
        b=1wZH3m7bnIkspUVacF7NBvEkTEj4NUn+KaXHlP/FbUg+o67tGMo65SIdP5/z9bDz2
         btBP4E053/IIgSNjfVYvLYQbXiqKaw7aVtafl+C6GqTqz53uGpt5JwIbhiFMlIeccP
         FTkr6SeS3pLmZtvaKR+S8cmynP8veRNowOcMpWPg=
Subject: patch "nvmem: check for NULL reg_read and reg_write before dereferencing" added to char-misc-testing
To:     nicholas.johnson-opensource@outlook.com.au,
        gregkh@linuxfoundation.org, srinivas.kandagatla@linaro.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 14:01:22 +0100
Message-ID: <1584536482109201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nvmem: check for NULL reg_read and reg_write before dereferencing

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a263682a3c9b9ce7b57fbe0296492d1a73d8be58 Mon Sep 17 00:00:00 2001
From: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Date: Tue, 10 Mar 2020 13:22:52 +0000
Subject: nvmem: check for NULL reg_read and reg_write before dereferencing

Return -EPERM if reg_read is NULL in bin_attr_nvmem_read() or if
reg_write is NULL in bin_attr_nvmem_write().

This prevents NULL dereferences such as the one described in
03cd45d2e219 ("thunderbolt: Prevent crash if non-active NVMem file is
read")

Signed-off-by: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200310132257.23358-10-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/nvmem-sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvmem/nvmem-sysfs.c b/drivers/nvmem/nvmem-sysfs.c
index 9e0c429cd08a..8759c4470012 100644
--- a/drivers/nvmem/nvmem-sysfs.c
+++ b/drivers/nvmem/nvmem-sysfs.c
@@ -56,6 +56,9 @@ static ssize_t bin_attr_nvmem_read(struct file *filp, struct kobject *kobj,
 
 	count = round_down(count, nvmem->word_size);
 
+	if (!nvmem->reg_read)
+		return -EPERM;
+
 	rc = nvmem->reg_read(nvmem->priv, pos, buf, count);
 
 	if (rc)
@@ -90,6 +93,9 @@ static ssize_t bin_attr_nvmem_write(struct file *filp, struct kobject *kobj,
 
 	count = round_down(count, nvmem->word_size);
 
+	if (!nvmem->reg_write)
+		return -EPERM;
+
 	rc = nvmem->reg_write(nvmem->priv, pos, buf, count);
 
 	if (rc)
-- 
2.25.1


