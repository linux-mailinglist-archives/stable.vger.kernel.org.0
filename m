Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3715395FBD
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhEaOQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233291AbhEaOMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:12:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F1D961464;
        Mon, 31 May 2021 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468503;
        bh=qKfDJFOx3qOkVAAvCD5wyxj6YgBgUGKf8FZajOoOjNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W152PQWjGojUpT6jMQ6buDUW+r3U6CqM3cMAXhxFP7OAWu3j7gJnmVrhUYqAwbBT2
         KZ9eL9NFe3zQ+V07WIahobm6+Ll5qnmcHkU7RetobjRyRcnoB+UEPtkufTDFlYrka1
         HSmHZCIqyNAI2giDadKwpIs6wEBfpebDucCNXanE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 006/177] iommu/vt-d: Fix sysfs leak in alloc_iommu()
Date:   Mon, 31 May 2021 15:12:43 +0200
Message-Id: <20210531130648.116306945@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>

commit 0ee74d5a48635c848c20f152d0d488bf84641304 upstream.

iommu_device_sysfs_add() is called before, so is has to be cleaned on subsequent
errors.

Fixes: 39ab9555c2411 ("iommu: Add sysfs bindings for struct iommu_device")
Cc: stable@vger.kernel.org # 4.11.x
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/17411490.HIIP88n32C@mobilepool36.emlix.com
Link: https://lore.kernel.org/r/20210525070802.361755-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dmar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1110,7 +1110,7 @@ static int alloc_iommu(struct dmar_drhd_
 
 		err = iommu_device_register(&iommu->iommu);
 		if (err)
-			goto err_unmap;
+			goto err_sysfs;
 	}
 
 	drhd->iommu = iommu;
@@ -1118,6 +1118,8 @@ static int alloc_iommu(struct dmar_drhd_
 
 	return 0;
 
+err_sysfs:
+	iommu_device_sysfs_remove(&iommu->iommu);
 err_unmap:
 	unmap_iommu(iommu);
 error_free_seq_id:


