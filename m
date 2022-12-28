Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537CF657B8A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiL1PXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiL1PWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3997614017
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCBF6154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE509C433D2;
        Wed, 28 Dec 2022 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240962;
        bh=ZLE2dTYV+lTi+iWjawH28UFbuT+bslTSaaoHl5vZ0D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nT6TwR87pNWpnqQdcu//1OpmnQ1BlEDePpfDRNtzXP0dQWYFq3Il0/HiXVM+JjU73
         5i5KRqXHGSRoRgUeu1/qdiCSclsQl1okmEN2+SY4dai5oChtlwlx/cVH5MIlKh8Bvm
         ZhrUIFpkIk0lTTyzI3LpxlhxpweKN3iV597HZIE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0180/1146] platform/x86: intel_scu_ipc: fix possible name leak in __intel_scu_ipc_register()
Date:   Wed, 28 Dec 2022 15:28:39 +0100
Message-Id: <20221228144335.043297517@linuxfoundation.org>
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

[ Upstream commit 0b3d0cb7c0bed2fd6454f77ed75e7a662c6efd12 ]

In some error paths before device_register(), the names allocated
by dev_set_name() are not freed. Move dev_set_name() front to
device_register(), so the name can be freed while calling
put_device().

Fixes: 54b34aa0a729 ("platform/x86: intel_scu_ipc: Split out SCU IPC functionality from the SCU driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221208151916.2404977-1-yangyingliang@huawei.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 7cc9089d1e14..e7a3e3402817 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -583,7 +583,6 @@ __intel_scu_ipc_register(struct device *parent,
 	scu->dev.parent = parent;
 	scu->dev.class = &intel_scu_ipc_class;
 	scu->dev.release = intel_scu_ipc_release;
-	dev_set_name(&scu->dev, "intel_scu_ipc");
 
 	if (!request_mem_region(scu_data->mem.start, resource_size(&scu_data->mem),
 				"intel_scu_ipc")) {
@@ -612,6 +611,7 @@ __intel_scu_ipc_register(struct device *parent,
 	 * After this point intel_scu_ipc_release() takes care of
 	 * releasing the SCU IPC resources once refcount drops to zero.
 	 */
+	dev_set_name(&scu->dev, "intel_scu_ipc");
 	err = device_register(&scu->dev);
 	if (err) {
 		put_device(&scu->dev);
-- 
2.35.1



