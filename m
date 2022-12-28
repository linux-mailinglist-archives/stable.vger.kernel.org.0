Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592BA657A3E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbiL1PJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiL1PJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:09:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C8B13E00
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:09:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80CDDB81716
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7152C433EF;
        Wed, 28 Dec 2022 15:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240147;
        bh=lx1ls6BJYhsGptyycfrqrX5A8rYuX6cFVvKtRoB/R/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6Hn7j0NW1uS4UtuSs01i5Vk+3vt7zPvCf0yv9wE367GzfoB1we5Gsu8HD/+Bizkx
         f6Ib2vEES4uh5R1nppGClPjTkboJlUqp3vnZcLt4+rUPKCWoRIfBeOp4VxGTBa2qoN
         /6LT3uZf6chQcn0wYE33CAXbojfAETXV16e9hDMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0123/1073] MIPS: vpe-cmp: fix possible memory leak while module exiting
Date:   Wed, 28 Dec 2022 15:28:31 +0100
Message-Id: <20221228144331.378282800@linuxfoundation.org>
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

[ Upstream commit c5ed1fe0801f0c66b0fbce2785239a5664629057 ]

dev_set_name() allocates memory for name, it need be freed
when module exiting, call put_device() to give up reference,
so that it can be freed in kobject_cleanup() when the refcount
hit to 0. The vpe_device is static, so remove kfree() from
vpe_device_release().

Fixes: 17a1d523aa58 ("MIPS: APRP: Add VPE loader support for CMP platforms.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/vpe-cmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/vpe-cmp.c b/arch/mips/kernel/vpe-cmp.c
index e673603e11e5..92140edb3ce3 100644
--- a/arch/mips/kernel/vpe-cmp.c
+++ b/arch/mips/kernel/vpe-cmp.c
@@ -75,7 +75,6 @@ ATTRIBUTE_GROUPS(vpe);
 
 static void vpe_device_release(struct device *cd)
 {
-	kfree(cd);
 }
 
 static struct class vpe_class = {
@@ -157,6 +156,7 @@ int __init vpe_module_init(void)
 	device_del(&vpe_device);
 
 out_class:
+	put_device(&vpe_device);
 	class_unregister(&vpe_class);
 
 out_chrdev:
@@ -169,7 +169,7 @@ void __exit vpe_module_exit(void)
 {
 	struct vpe *v, *n;
 
-	device_del(&vpe_device);
+	device_unregister(&vpe_device);
 	class_unregister(&vpe_class);
 	unregister_chrdev(major, VPE_MODULE_NAME);
 
-- 
2.35.1



