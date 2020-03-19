Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C6418AD31
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 08:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgCSHNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 03:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbgCSHNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 03:13:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ECFD2071C;
        Thu, 19 Mar 2020 07:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584602014;
        bh=UsCIjdC8CSjS2fVtuWBsfS07osg/FSivDysv4Zqf5Dg=;
        h=Subject:To:From:Date:From;
        b=WRoHCSnsNGZ5UCrLfPYDelsJAvyZIGm/54eExBJEn2Zc4Wftaewj/v2nDizoQYzli
         EVTs+acboNTN4gIxBiPKdqanFdQzcUkj3pgbvuu2wIzY8iLJWWUJqZFi+X1USmS/B5
         3LOgRTe2qaN4OxYKCHoZeR/hE4AhNgF57xpYngkU=
Subject: patch "nvmem: check for NULL reg_read and reg_write before dereferencing" added to char-misc-next
To:     nicholas.johnson-opensource@outlook.com.au,
        gregkh@linuxfoundation.org, srinivas.kandagatla@linaro.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Mar 2020 08:12:26 +0100
Message-ID: <158460194613954@kroah.com>
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 3c91ef69a3e94f78546b246225ed573fbf1735b4 Mon Sep 17 00:00:00 2001
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
2.25.2


