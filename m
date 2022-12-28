Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427A1657A38
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiL1PJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiL1PI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B638F13DD7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53CC361555
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D4CC433D2;
        Wed, 28 Dec 2022 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240136;
        bh=J7FwzpysjjsFN+SjVMjARPC9GfDv8COCLZ5rdinsQKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBHCOFZvl4FsjTvMZlBLEzeNviCtPzL05phrg1/VhN5NL+yT9IuimUveu45q75JTQ
         ZgRgr+15CcAcsi9W1Ho6NclezHuylX8zZONO3mbQKGWMI+EWF8dUPpQYUqfMJAfb4W
         4JNqnIu8UooPtFTebR+AoYsBNQi8R6jmxu2KRbrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0122/1073] MIPS: vpe-mt: fix possible memory leak while module exiting
Date:   Wed, 28 Dec 2022 15:28:30 +0100
Message-Id: <20221228144331.351468095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 5822e8cc84ee37338ab0bdc3124f6eec04dc232d ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
it need be freed when module exiting, call put_device() to give up
reference, so that it can be freed in kobject_cleanup() when the
refcount hit to 0. The vpe_device is static, so remove kfree() from
vpe_device_release().

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/vpe-mt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/vpe-mt.c b/arch/mips/kernel/vpe-mt.c
index bad6b0891b2b..84a82b551ec3 100644
--- a/arch/mips/kernel/vpe-mt.c
+++ b/arch/mips/kernel/vpe-mt.c
@@ -313,7 +313,6 @@ ATTRIBUTE_GROUPS(vpe);
 
 static void vpe_device_release(struct device *cd)
 {
-	kfree(cd);
 }
 
 static struct class vpe_class = {
@@ -497,6 +496,7 @@ int __init vpe_module_init(void)
 	device_del(&vpe_device);
 
 out_class:
+	put_device(&vpe_device);
 	class_unregister(&vpe_class);
 
 out_chrdev:
@@ -509,7 +509,7 @@ void __exit vpe_module_exit(void)
 {
 	struct vpe *v, *n;
 
-	device_del(&vpe_device);
+	device_unregister(&vpe_device);
 	class_unregister(&vpe_class);
 	unregister_chrdev(major, VPE_MODULE_NAME);
 
-- 
2.35.1



