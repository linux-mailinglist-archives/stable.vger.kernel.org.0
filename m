Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DDF5941EF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbiHOU4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346888AbiHOUz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:55:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA87C04CF;
        Mon, 15 Aug 2022 12:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31D2CB81062;
        Mon, 15 Aug 2022 19:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AAEC433D6;
        Mon, 15 Aug 2022 19:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590684;
        bh=oB7dM72XMNQQt8sfgtaPMnMcpQan2i1lyVARTUxw0Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byYV0QcSuKq7WsG1pzBEMCkjTJ31cTtjQ0xgmn96BW+fJvHOCJhdWHL76hurITZmf
         jB4wTyjJIu5hG9L4nSk9VXcit7kW7i397Imi8+6QNGUEIJDijCMPQv5gOuInweYRqL
         Oa7w1HLfkAuUctSy3VJaTfaVgJnZcXJ19EZt6E7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0339/1095] drm/bridge: it6505: Add missing CRYPTO_HASH dependency
Date:   Mon, 15 Aug 2022 19:55:38 +0200
Message-Id: <20220815180443.821131249@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Zheng Bin <zhengbin13@huawei.com>

[ Upstream commit abf0ba5a34eae0d7359228f4319a6659676fbd0a ]

The driver uses crypto hash functions so it needs to select CRYPTO_HASH.
This fixes build errors:

drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_hdcp_wait_ksv_list':
ite-it6505.c:(.text+0x4c26): undefined reference to `crypto_alloc_shash'
ite-it6505.c:(.text+0x4c6d): undefined reference to `crypto_shash_digest'
ite-it6505.c:(.text+0x4c7d): undefined reference to `crypto_destroy_tfm'
ite-it6505.c:(.text+0x4d69): undefined reference to `crypto_destroy_tfm'

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220613150653.1310029-1-zhengbin13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index be2fc4791c1d..7d152cc6f837 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -82,6 +82,8 @@ config DRM_ITE_IT6505
         select DRM_KMS_HELPER
         select DRM_DP_HELPER
         select EXTCON
+        select CRYPTO
+        select CRYPTO_HASH
         help
           ITE IT6505 DisplayPort bridge chip driver.
 
-- 
2.35.1



