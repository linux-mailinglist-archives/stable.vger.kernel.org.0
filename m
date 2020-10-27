Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5CD29BDAE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811949AbgJ0Qob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801613AbgJ0Pm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC9DE21D42;
        Tue, 27 Oct 2020 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813375;
        bh=XLI/NOokBRA6gBaE06J/9paKY2OWSWhNWDhiFF8wstk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHAwSVHqEPuwUHpWKAxaIkWPncDA0gc7cvlFmGXhMNUliApnr7AbSZVDzquMzd8qf
         06Fse/FTBFrblvQG9yctKvog87kTlecbU2E01SLlQ9ZkLR25G6qOjF3dawpc1iP4Mp
         wZPbFQqPW6bHEZEf08YFGFQpFI8LOIGwJdpRWIP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 530/757] vfio: fix a missed vfio group put in vfio_pin_pages
Date:   Tue, 27 Oct 2020 14:53:00 +0100
Message-Id: <20201027135515.353178869@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 532bcaf28c11d..2151bc7f87ab1 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1949,8 +1949,10 @@ int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
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



