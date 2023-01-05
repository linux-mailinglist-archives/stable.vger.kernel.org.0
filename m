Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD165EB8C
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjAENA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjAEM7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:59:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED3C5A8AC
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:59:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED7061A0C
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268B4C433EF;
        Thu,  5 Jan 2023 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923577;
        bh=dJq01lreG1hWlgvQLtbQ9qGIiIdw9xBElaXv/5HCxYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsgR87ZT4rrJ3GSoWYX8HNSqT/11BviUPfLW62+ppBEsHXKarwTGDIwrpWmsLTT4Z
         cYfotGtFIms1R2ebz7r6Wg5qhoYT4UiQBfRl9mxN3wr18iYPQi7HdNYZ+VuLQWTrdl
         OqyPWgbeCL9gkJ0a+NxkmERWuGeKcnDpzn1BvWPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 035/251] MIPS: vpe-cmp: fix possible memory leak while module exiting
Date:   Thu,  5 Jan 2023 13:52:52 +0100
Message-Id: <20230105125336.365348663@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
index 9268ebc0f61e..903c07bdc92d 100644
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



