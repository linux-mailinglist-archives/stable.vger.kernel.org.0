Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93140689626
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbjBCK1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjBCK1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:27:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F12D9D582
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:26:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FD9761E68
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4199FC4339B;
        Fri,  3 Feb 2023 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419973;
        bh=De1wu6qamyD+3EsbkBp7VVk9WF4WQOB4p2v4BYE9zdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgmbZh0PISrc4vIUhE3lNMj7BS6lkmrI/FqWOalFzJpydgrZGz+JAgrPvyoeUOsMd
         DO+/a0e4hvzBeJp5+jVpC6NltQghSLWv94olGieKW/4gs7r3HIkam5/5PYp2Wvk5F8
         fqkFOgwNTuPxIT6z2cH+fS0cdcPEUf5qHl3QOeO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/134] drm/panfrost: fix GENERIC_ATOMIC64 dependency
Date:   Fri,  3 Feb 2023 11:12:24 +0100
Message-Id: <20230203101025.615605763@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6437a549ae178a3f5a5c03e983f291ebcdc2bbc7 ]

On ARMv5 and earlier, a randconfig build can still run into

WARNING: unmet direct dependencies detected for IOMMU_IO_PGTABLE_LPAE
  Depends on [n]: IOMMU_SUPPORT [=y] && (ARM [=y] || ARM64 || COMPILE_TEST [=y]) && !GENERIC_ATOMIC64 [=y]
  Selected by [y]:
  - DRM_PANFROST [=y] && HAS_IOMEM [=y] && DRM [=y] && (ARM [=y] || ARM64 || COMPILE_TEST [=y] && !GENERIC_ATOMIC64 [=y]) && MMU [=y]

Rework the dependencies to always require a working cmpxchg64.

Fixes: db594ba3fcf9 ("drm/panfrost: depend on !GENERIC_ATOMIC64 when using COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230117164456.1591901-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/Kconfig b/drivers/gpu/drm/panfrost/Kconfig
index 86cdc0ce79e6..77f4d32e5204 100644
--- a/drivers/gpu/drm/panfrost/Kconfig
+++ b/drivers/gpu/drm/panfrost/Kconfig
@@ -3,7 +3,8 @@
 config DRM_PANFROST
 	tristate "Panfrost (DRM support for ARM Mali Midgard/Bifrost GPUs)"
 	depends on DRM
-	depends on ARM || ARM64 || (COMPILE_TEST && !GENERIC_ATOMIC64)
+	depends on ARM || ARM64 || COMPILE_TEST
+	depends on !GENERIC_ATOMIC64    # for IOMMU_IO_PGTABLE_LPAE
 	depends on MMU
 	select DRM_SCHED
 	select IOMMU_SUPPORT
-- 
2.39.0



