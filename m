Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211A51C535E
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 12:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgEEKgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 06:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgEEKgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 06:36:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66863206A4;
        Tue,  5 May 2020 10:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588674984;
        bh=e+tWOjX0VPMXml/v9ASJXl7HxrbuF6E/zocubjeoAJI=;
        h=Subject:To:From:Date:From;
        b=zJfJ7dADYR3HjM3qDvqL5NEkRYlQHx3MGYFdn8iuYesWnYskTZ/9m60RyYWZRLuwW
         ADShRyXGVCQfeenJR8bd6UGYRlCc1GihEQ4lCbO98nvfRhd4K0N4dRpmaj7TCKrvM3
         79zfWhYPtI3EVDkNOe2Jdj3DMCmW0KKkDovEVHfY=
Subject: patch "staging: gasket: Check the return value of gasket_get_bar_index()" added to staging-linus
To:     oscar.carter@gmx.com, gregkh@linuxfoundation.org, rcy@google.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 May 2020 12:36:14 +0200
Message-ID: <1588674974148122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: gasket: Check the return value of gasket_get_bar_index()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 769acc3656d93aaacada814939743361d284fd87 Mon Sep 17 00:00:00 2001
From: Oscar Carter <oscar.carter@gmx.com>
Date: Fri, 1 May 2020 17:51:18 +0200
Subject: staging: gasket: Check the return value of gasket_get_bar_index()

Check the return value of gasket_get_bar_index function as it can return
a negative one (-EINVAL). If this happens, a negative index is used in
the "gasket_dev->bar_data" array.

Addresses-Coverity-ID: 1438542 ("Negative array index read")
Fixes: 9a69f5087ccc2 ("drivers/staging: Gasket driver framework + Apex driver")
Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Richard Yeh <rcy@google.com>
Link: https://lore.kernel.org/r/20200501155118.13380-1-oscar.carter@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gasket/gasket_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/gasket/gasket_core.c b/drivers/staging/gasket/gasket_core.c
index 8e0575fcb4c8..67325fbaf760 100644
--- a/drivers/staging/gasket/gasket_core.c
+++ b/drivers/staging/gasket/gasket_core.c
@@ -925,6 +925,10 @@ do_map_region(const struct gasket_dev *gasket_dev, struct vm_area_struct *vma,
 		gasket_get_bar_index(gasket_dev,
 				     (vma->vm_pgoff << PAGE_SHIFT) +
 				     driver_desc->legacy_mmap_address_offset);
+
+	if (bar_index < 0)
+		return DO_MAP_REGION_INVALID;
+
 	phys_base = gasket_dev->bar_data[bar_index].phys_base + phys_offset;
 	while (mapped_bytes < map_length) {
 		/*
-- 
2.26.2


