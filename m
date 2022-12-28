Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C93657DE5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiL1PsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiL1Pru (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8237E1788D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2367FB81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEBCC433D2;
        Wed, 28 Dec 2022 15:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242466;
        bh=J5Od7YALa/hq23/+T6cu9swVfU4oJMnR0f8eH49DHrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ewMBjzmAKvJK6pEEqxejyJw365NWzyh0AiMChCCzgpAzFlWfxAchLxXTl9hUKDf6
         cpefsLuHWkCBdc3s+Byfpw/Yu3eAL+DjFQtn2TUGLN75/s2kV1tLPnrCH2kasAMtq7
         eB/jxtBKS5sYucGiSrvJRPFEifDgU1ToIojmKHu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0355/1146] media: solo6x10: fix possible memory leak in solo_sysfs_init()
Date:   Wed, 28 Dec 2022 15:31:34 +0100
Message-Id: <20221228144339.804362518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7f5866dd96d95b74e439f6ee17b8abd8195179fb ]

If device_register() returns error in solo_sysfs_init(), the
name allocated by dev_set_name() need be freed. As comment of
device_register() says, it should use put_device() to give up
the reference in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanup().

Fixes: dcae5dacbce5 ("[media] solo6x10: sync to latest code from Bluecherry's git repo")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/solo6x10/solo6x10-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
index 4a546eeefe38..6d87fbb0ee04 100644
--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -420,6 +420,7 @@ static int solo_sysfs_init(struct solo_dev *solo_dev)
 		     solo_dev->nr_chans);
 
 	if (device_register(dev)) {
+		put_device(dev);
 		dev->parent = NULL;
 		return -ENOMEM;
 	}
-- 
2.35.1



