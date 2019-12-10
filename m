Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0088311844C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 11:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLJKF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 05:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfLJKF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 05:05:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E2E2077B;
        Tue, 10 Dec 2019 10:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575972356;
        bh=g91JKgA6KPtiyk0j1RmNq3SFrewgJVLqXcitMR+RN2g=;
        h=Subject:To:From:Date:From;
        b=kHxVkjJK3Y6o69xlkpWxJj5a1TYq7fTp+7gYPz/r5TrTOt/HWe+Xio+RZtS2IGmDB
         7SfNwlJM4qMibtwfX1Ca0n4i0PnpC5rBm9F3lL1uMm5QF0w/+XToG+5sfbjIySD5K8
         XzGsxzGg8kqEd0rxLzja6w+oEIv98XMA/76zupbg=
Subject: patch "staging: vchiq: call unregister_chrdev_region() when driver" added to staging-linus
To:     marcgonzalez@google.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, nsaenzjulienne@suse.de,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 11:05:39 +0100
Message-ID: <157597233919370@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vchiq: call unregister_chrdev_region() when driver

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d2cdb20507fe2079a146459f9718b45d78cbbe61 Mon Sep 17 00:00:00 2001
From: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Date: Tue, 3 Dec 2019 10:39:21 -0500
Subject: staging: vchiq: call unregister_chrdev_region() when driver
 registration fails

This undoes the previous call to alloc_chrdev_region() on failure,
and is probably what was meant originally given the label name.

Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 187ac53e590c ("staging: vchiq_arm: rework probe and init functions")
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20191203153921.70540-1-marcgonzalez@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 02148a24818a..4458c1e60fa3 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -3309,7 +3309,7 @@ static int __init vchiq_driver_init(void)
 	return 0;
 
 region_unregister:
-	platform_driver_unregister(&vchiq_driver);
+	unregister_chrdev_region(vchiq_devid, 1);
 
 class_destroy:
 	class_destroy(vchiq_class);
-- 
2.24.0


