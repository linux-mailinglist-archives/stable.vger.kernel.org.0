Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35DB14BB67
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgA1ODN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgA1ODM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F6D424685;
        Tue, 28 Jan 2020 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220192;
        bh=HW/SNC0daFPy4EY0FcclDmYrEs3l2AgA6mz536Es7TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fX/mID8Uh7ZzYzgND+Cs0JoGMGkFBuURcUOAbVPmoduCraNnJ478FAuHHOtIcNckm
         5PkhnezNwy9JaY3ipR61C7GWmLEuf42Xx71nur2LOfPQ42i2Sk/wqZ9AKN22kzcui1
         K1ViQdTmeGcxznOfOY/+eyBhhAO0wxd36ie6APNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 054/104] iommu/vt-d: Call __dmar_remove_one_dev_info with valid pointer
Date:   Tue, 28 Jan 2020 15:00:15 +0100
Message-Id: <20200128135825.091797313@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

commit bf708cfb2f4811d1948a88c41ab96587e84ad344 upstream.

It is possible for archdata.iommu to be set to
DEFER_DEVICE_DOMAIN_INFO or DUMMY_DEVICE_DOMAIN_INFO so check for
those values before calling __dmar_remove_one_dev_info. Without a
check it can result in a null pointer dereference. This has been seen
while booting a kdump kernel on an HP dl380 gen9.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org # 5.3+
Cc: linux-kernel@vger.kernel.org
Fixes: ae23bfb68f28 ("iommu/vt-d: Detach domain before using a private one")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5132,7 +5132,8 @@ static void dmar_remove_one_dev_info(str
 
 	spin_lock_irqsave(&device_domain_lock, flags);
 	info = dev->archdata.iommu;
-	if (info)
+	if (info && info != DEFER_DEVICE_DOMAIN_INFO
+	    && info != DUMMY_DEVICE_DOMAIN_INFO)
 		__dmar_remove_one_dev_info(info);
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }


