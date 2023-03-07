Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD7D6AEA22
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjCGRbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjCGRas (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E560FA6754
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91405B819A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF622C4339B;
        Tue,  7 Mar 2023 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209964;
        bh=0MZmzu3ZgniHZsSQKhm9l8As2r21XFYi58o2yCCkRSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWc+GfhiHGnsIXGvSRPzNt8/ixFReXsJEj22AXo1Ua3pcQYTgp1QM3hpMm/iI+Ie0
         M5mKCHXrUszgs9pav6WERLZOmAkluIjP/eNW1CAT0ZJGLKZ7fjbctM8cP3RqyhOXMU
         +r2LxFxr9uhUt7wNMxDZQ7VeSl4yl4LMzZaygTVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0387/1001] gpu: host1x: Dont skip assigning syncpoints to channels
Date:   Tue,  7 Mar 2023 17:52:39 +0100
Message-Id: <20230307170038.175830954@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit eb258cc1fd458e584082be987dbc6ec42668c05e ]

The code to write the syncpoint channel assignment register
incorrectly skips the write if hypervisor registers are not available.

The register, however, is within the guest aperture so remove the
check and assign syncpoints properly even on virtualized systems.

Fixes: c3f52220f276 ("gpu: host1x: Enable Tegra186 syncpoint protection")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/syncpt_hw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
index dd39d67ccec36..8cf35b2eff3db 100644
--- a/drivers/gpu/host1x/hw/syncpt_hw.c
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -106,9 +106,6 @@ static void syncpt_assign_to_channel(struct host1x_syncpt *sp,
 #if HOST1X_HW >= 6
 	struct host1x *host = sp->host;
 
-	if (!host->hv_regs)
-		return;
-
 	host1x_sync_writel(host,
 			   HOST1X_SYNC_SYNCPT_CH_APP_CH(ch ? ch->id : 0xff),
 			   HOST1X_SYNC_SYNCPT_CH_APP(sp->id));
-- 
2.39.2



