Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF45E6579D7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbiL1PFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiL1PFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:05:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D4913D4B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC6D5B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D70C433EF;
        Wed, 28 Dec 2022 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239917;
        bh=MdlhajfASTJ3FivlaMwMVyPAbLwpoGu9hwUtZuiH/OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlwQeNM32yU60E/Z4Lsa6HNabHyxgZY2i3t8+YLeN8DnFd1QCOQiID3W3PULWMXhh
         a+M9IMYOW4xXcqDc8k1JmPEfDcezru3+3B8CIkidLr9P8xFMtthf1nwtgFbnnesjcG
         yq9ov7ETLYArSz5Mb83FlsJBzKZN1dCfOQTVPg1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Shixin <liushixin2@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/731] media: saa7164: fix missing pci_disable_device()
Date:   Wed, 28 Dec 2022 15:36:32 +0100
Message-Id: <20221228144304.833161606@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 57fb35d7542384cac8f198cd1c927540ad38b61a ]

Add missing pci_disable_device() in the error path in saa7164_initdev().

Fixes: 443c1228d505 ("V4L/DVB (12923): SAA7164: Add support for the NXP SAA7164 silicon")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7164/saa7164-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 7973ae42873a..c10997e2271d 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1259,7 +1259,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 	if (saa7164_dev_setup(dev) < 0) {
 		err = -EINVAL;
-		goto fail_free;
+		goto fail_dev;
 	}
 
 	/* print pci info */
@@ -1427,6 +1427,8 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 fail_irq:
 	saa7164_dev_unregister(dev);
+fail_dev:
+	pci_disable_device(pci_dev);
 fail_free:
 	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
-- 
2.35.1



