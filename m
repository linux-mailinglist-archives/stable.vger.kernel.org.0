Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED8B59A22D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350141AbiHSQc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353370AbiHSQb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321EC10BE28;
        Fri, 19 Aug 2022 09:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 693CDB8281E;
        Fri, 19 Aug 2022 16:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B82EC433D6;
        Fri, 19 Aug 2022 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925125;
        bh=Ix70jMqzSR6OVcGgb63FGwt5a3wE/kuBeTUbSi8dQCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ls98oX7Ii45H6JzvD3qre5Popp27zDw+ptAw6WVITPlKcEMesN6jHYdbAI67jzWFR
         4bk+H7iUV1cV2d431RsNoGxOuxUrXbDr8UUn2ynAId2J9UKxloLZzgGDtuwlj0n3oX
         CXt8JV73gLWcCYOQY/8iz9WJfBq8V2gyn3lZv/4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/545] vfio/mdev: Make to_mdev_device() into a static inline
Date:   Fri, 19 Aug 2022 17:42:42 +0200
Message-Id: <20220819153846.954453049@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 66873b5fa738ca02b5c075ca4a410b13d88e6e9a ]

The macro wrongly uses 'dev' as both the macro argument and the member
name, which means it fails compilation if any caller uses a word other
than 'dev' as the single argument. Fix this defect by making it into
proper static inline, which is more clear and typesafe anyhow.

Fixes: 99e3123e3d72 ("vfio-mdev: Make mdev_device private and abstract interfaces")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <11-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/mdev/mdev_private.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 7d922950caaf..74c2e5411469 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -35,7 +35,10 @@ struct mdev_device {
 	bool active;
 };
 
-#define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
+static inline struct mdev_device *to_mdev_device(struct device *dev)
+{
+	return container_of(dev, struct mdev_device, dev);
+}
 #define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
 
 struct mdev_type {
-- 
2.35.1



