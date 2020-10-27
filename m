Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7668029BF6D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793788AbgJ0PIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793754AbgJ0PII (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09A5121D41;
        Tue, 27 Oct 2020 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811286;
        bh=ntyt1F34ZiEDyr6C3hbVye6v7FuMXWb0duiduz2krT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hN0OicUES9gP+49DxfXwu/QA6milghIpaUVDMYEdZsbvS3JiO7W/A/goBGdI37MU
         w16zaoZX7aw0w8KAwfdLaSbvGVVplS1IyyVL5syIf9sZHRUPizFGIuOnWTsqG2rqQm
         Ee4l3tVBn1Lt7M5rybmXWeFoHnJFoFMMmfDO66pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 439/633] vfio: fix a missed vfio group put in vfio_pin_pages
Date:   Tue, 27 Oct 2020 14:53:02 +0100
Message-Id: <20201027135543.317608540@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

[ Upstream commit 28b130244061863cf0437b7af1625fb45ec1a71e ]

When error occurs, need to put vfio group after a successful get.

Fixes: 95fc87b44104 ("vfio: Selective dirty page tracking if IOMMU backed device pins pages")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2a70e25cfe954..fbff5c4743c5e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1948,8 +1948,10 @@ int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
 	if (!group)
 		return -ENODEV;
 
-	if (group->dev_counter > 1)
-		return -EINVAL;
+	if (group->dev_counter > 1) {
+		ret = -EINVAL;
+		goto err_pin_pages;
+	}
 
 	ret = vfio_group_add_container_user(group);
 	if (ret)
-- 
2.25.1



