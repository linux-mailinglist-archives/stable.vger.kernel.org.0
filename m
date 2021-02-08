Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACD33137BC
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhBHPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:30:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232197AbhBHP0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:26:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4A7864F1A;
        Mon,  8 Feb 2021 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797329;
        bh=621RxkhTczHoTVOeUp9MvSyU2ZZcgPnkWxOLiz0x0XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoL0WBZSYK9G9pSj6BABJkwT1+uHlZOWNLklnzaVTYZ0ae71hOYKeABlMJH/8if/J
         Ba8n7Uhw7BvHssG9SugRvIy1pvA7Q06MtkrJshl46m92irAOUKLUAfHE3kWph4oqsb
         vd9Swv6o2VsgK7SjEOhZUGZAsORy7VlM8xjyZdSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 072/120] iommu: Check dev->iommu in dev_iommu_priv_get() before dereferencing it
Date:   Mon,  8 Feb 2021 16:00:59 +0100
Message-Id: <20210208145821.281397713@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 4c9fb5d9140802db4db9f66c23887f43174e113c upstream.

The dev_iommu_priv_get() needs a similar check to
dev_iommu_fwspec_get() to make sure no NULL-ptr is dereferenced.

Fixes: 05a0542b456e1 ("iommu/amd: Store dev_data as device iommu private data")
Cc: stable@vger.kernel.org	# v5.8+
Link: https://lore.kernel.org/r/20210202145419.29143-1-joro@8bytes.org
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=211241
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iommu.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -614,7 +614,10 @@ static inline void dev_iommu_fwspec_set(
 
 static inline void *dev_iommu_priv_get(struct device *dev)
 {
-	return dev->iommu->priv;
+	if (dev->iommu)
+		return dev->iommu->priv;
+	else
+		return NULL;
 }
 
 static inline void dev_iommu_priv_set(struct device *dev, void *priv)


