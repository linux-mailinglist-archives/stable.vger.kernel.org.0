Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDED466740C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjALOCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjALOCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3948E5130B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8634DCE1E6F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E72C433EF;
        Thu, 12 Jan 2023 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532119;
        bh=E66UfLByuvpiFkZgPsyqOojYpRvUYbgfQf0UxwG0EZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiVdmWCfQGhzALzuoIsGkStrX7sH0YrcN5/itfepDeh/j0aGZdwzmVJAAQkn9W/BG
         LEldvUDKbeuUs1jyvNq3oNsdh25yHltNbzSnjKHU7EinGqjqvXQRJfHUrjC4hryimf
         EkRbc3zFnHJ35zY/cUHVMbihkBhthG6XvWA3sQJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/783] MIPS: vpe-mt: fix possible memory leak while module exiting
Date:   Thu, 12 Jan 2023 14:46:14 +0100
Message-Id: <20230112135526.833321983@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 2e003b11a098..9fd7cd48ea1d 100644
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



