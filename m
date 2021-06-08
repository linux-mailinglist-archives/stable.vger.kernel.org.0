Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326D03A00BC
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhFHSqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235742AbhFHSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961EF61359;
        Tue,  8 Jun 2021 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177402;
        bh=M+zKhaIuEUGO4xa6uK+sG9Nn7z4s6Psx9iEw9U7UOps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzfdggDG4LIpk4J8Fk1U5XXBZnCQiKQYuLgVroQptzkHtqcUvEQZKzJQ/j3VZsyYa
         Qx8L96SdKYy/D4EtyPRaH3Tg6alntN4ZXWUbtaynUsPTlRFkEwo7OcWvTl1Qdmge4v
         4kwmYrau2Bmsf8LoxMVSYLvJH6wF+6hFyUqcSWUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/78] vfio/pci: Fix error return code in vfio_ecap_init()
Date:   Tue,  8 Jun 2021 20:26:38 +0200
Message-Id: <20210608175935.583353021@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit d1ce2c79156d3baf0830990ab06d296477b93c26 ]

The error code returned from vfio_ext_cap_len() is stored in 'len', not
in 'ret'.

Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Message-Id: <20210515020458.6771-1-thunder.leizhen@huawei.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index bf32997c557f..50cd17fcf754 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1576,7 +1576,7 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 			if (len == 0xFF) {
 				len = vfio_ext_cap_len(vdev, ecap, epos);
 				if (len < 0)
-					return ret;
+					return len;
 			}
 		}
 
-- 
2.30.2



