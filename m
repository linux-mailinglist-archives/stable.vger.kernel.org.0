Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5234E6C7BC
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388876AbfGRDDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727577AbfGRDDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:03:01 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D2EE21849;
        Thu, 18 Jul 2019 03:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563418980;
        bh=VZRbkZ6kretyBIwPDNjNMe1O0/KGopWD1k+pBXBkUdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUnGMh+IMOXxSw3RCttBebQHgbkfZI+x927GFvHwJTlprkiBzLf1xJRIXAQcINP8W
         WDYYMWMEAk5zO6YnyVp4yCg0vXqbyWFW/J4pYfqRuBvV1x9hIk9YJjV4SRUbd0q5WP
         IT6F8dceG0lDQfzP3O6CsS7J2n8SA3oJGLZb9uys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rudo <prudo@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.2 14/21] s390/ipl: Fix detection of has_secure attribute
Date:   Thu, 18 Jul 2019 12:01:32 +0900
Message-Id: <20190718030034.170275687@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

commit 1b2be2071aca9aab22e3f902bcb0fca46a1d3b00 upstream.

Use the correct bit for detection of the machine capability associated
with the has_secure attribute. It is expected that the underlying
platform (including hypervisors) unsets the bit when they don't provide
secure ipl for their guests.

Fixes: c9896acc7851 ("s390/ipl: Provide has_secure sysfs attribute")
Cc: stable@vger.kernel.org # 5.2
Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/sclp.h   |    1 -
 arch/s390/kernel/ipl.c         |    7 +------
 drivers/s390/char/sclp_early.c |    1 -
 3 files changed, 1 insertion(+), 8 deletions(-)

--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -80,7 +80,6 @@ struct sclp_info {
 	unsigned char has_gisaf : 1;
 	unsigned char has_diag318 : 1;
 	unsigned char has_sipl : 1;
-	unsigned char has_sipl_g2 : 1;
 	unsigned char has_dirq : 1;
 	unsigned int ibc;
 	unsigned int mtid;
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -286,12 +286,7 @@ static struct kobj_attribute sys_ipl_sec
 static ssize_t ipl_has_secure_show(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *page)
 {
-	if (MACHINE_IS_LPAR)
-		return sprintf(page, "%i\n", !!sclp.has_sipl);
-	else if (MACHINE_IS_VM)
-		return sprintf(page, "%i\n", !!sclp.has_sipl_g2);
-	else
-		return sprintf(page, "%i\n", 0);
+	return sprintf(page, "%i\n", !!sclp.has_sipl);
 }
 
 static struct kobj_attribute sys_ipl_has_secure_attr =
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -41,7 +41,6 @@ static void __init sclp_early_facilities
 	sclp.has_hvs = !!(sccb->fac119 & 0x80);
 	sclp.has_kss = !!(sccb->fac98 & 0x01);
 	sclp.has_sipl = !!(sccb->cbl & 0x02);
-	sclp.has_sipl_g2 = !!(sccb->cbl & 0x04);
 	if (sccb->fac85 & 0x02)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
 	if (sccb->fac91 & 0x40)


