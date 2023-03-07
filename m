Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD296AEA21
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCGRbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjCGRap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A13A6755
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93323CE1C5B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941F5C433EF;
        Tue,  7 Mar 2023 17:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209961;
        bh=mKWjptEvwkgkWXnqZmXIE43nr8ICtlDlOqa14lCg+eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrYd/4dr9ELNKFMV9KE3yYZ4EnJirLCNd00rb/hGMb9KBJsJoa/uz3yOew5moU4i1
         fOgS4v1pSL1ZdPR+9sdYFSGoWS/M7v586Hihcr9dtVvG/jsxqH3ZGMsGXuIgK/yoPA
         TVP4ljtrpn71NYBwarQtCPcitASp4RaVcuUABDK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0386/1001] gpu: host1x: Fix mask for syncpoint increment register
Date:   Tue,  7 Mar 2023 17:52:38 +0100
Message-Id: <20230307170038.139108604@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 79aad29c7d2d2cd64790115d3a6ebac28c00a8ec ]

On Tegra186+, the syncpoint ID has 10 bits of space. To allow
using more than 256 syncpoints, fix the mask.

Fixes: 9abdd497cd0a ("gpu: host1x: Tegra234 device data and headers")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/hw_host1x06_uclass.h | 2 +-
 drivers/gpu/host1x/hw/hw_host1x07_uclass.h | 2 +-
 drivers/gpu/host1x/hw/hw_host1x08_uclass.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/host1x/hw/hw_host1x06_uclass.h b/drivers/gpu/host1x/hw/hw_host1x06_uclass.h
index 5f831438d19bb..50c32de452fb1 100644
--- a/drivers/gpu/host1x/hw/hw_host1x06_uclass.h
+++ b/drivers/gpu/host1x/hw/hw_host1x06_uclass.h
@@ -53,7 +53,7 @@ static inline u32 host1x_uclass_incr_syncpt_cond_f(u32 v)
 	host1x_uclass_incr_syncpt_cond_f(v)
 static inline u32 host1x_uclass_incr_syncpt_indx_f(u32 v)
 {
-	return (v & 0xff) << 0;
+	return (v & 0x3ff) << 0;
 }
 #define HOST1X_UCLASS_INCR_SYNCPT_INDX_F(v) \
 	host1x_uclass_incr_syncpt_indx_f(v)
diff --git a/drivers/gpu/host1x/hw/hw_host1x07_uclass.h b/drivers/gpu/host1x/hw/hw_host1x07_uclass.h
index 8cd2ef087d5d0..887b878f92f79 100644
--- a/drivers/gpu/host1x/hw/hw_host1x07_uclass.h
+++ b/drivers/gpu/host1x/hw/hw_host1x07_uclass.h
@@ -53,7 +53,7 @@ static inline u32 host1x_uclass_incr_syncpt_cond_f(u32 v)
 	host1x_uclass_incr_syncpt_cond_f(v)
 static inline u32 host1x_uclass_incr_syncpt_indx_f(u32 v)
 {
-	return (v & 0xff) << 0;
+	return (v & 0x3ff) << 0;
 }
 #define HOST1X_UCLASS_INCR_SYNCPT_INDX_F(v) \
 	host1x_uclass_incr_syncpt_indx_f(v)
diff --git a/drivers/gpu/host1x/hw/hw_host1x08_uclass.h b/drivers/gpu/host1x/hw/hw_host1x08_uclass.h
index 724cccd71aa1a..4fb1d090edae5 100644
--- a/drivers/gpu/host1x/hw/hw_host1x08_uclass.h
+++ b/drivers/gpu/host1x/hw/hw_host1x08_uclass.h
@@ -53,7 +53,7 @@ static inline u32 host1x_uclass_incr_syncpt_cond_f(u32 v)
 	host1x_uclass_incr_syncpt_cond_f(v)
 static inline u32 host1x_uclass_incr_syncpt_indx_f(u32 v)
 {
-	return (v & 0xff) << 0;
+	return (v & 0x3ff) << 0;
 }
 #define HOST1X_UCLASS_INCR_SYNCPT_INDX_F(v) \
 	host1x_uclass_incr_syncpt_indx_f(v)
-- 
2.39.2



