Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635296AEA26
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjCGRbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjCGRas (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901C8A675A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A74C614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D945C433EF;
        Tue,  7 Mar 2023 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209967;
        bh=2SFXI/hh4a8eHKzq6wiy37/kjG64JrGbKyCDe0SeGYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iO9XS7GkBcSNCiub6ky8P0G3PMHoDcS8Q/Do3CMPGzy524hEVjvHJ9d4yFkrJ4O+J
         xby2swRZbxBfFrDovlntVf5agN3MIAujefIZoGcsnkptDAjrjmV9sQYAHCPCUQaL6E
         85ITEbcaSnbVsV+6k+kC0tuZ4M5DBoOU00Lw1XNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0388/1001] drm/tegra: firewall: Check for is_addr_reg existence in IMM check
Date:   Tue,  7 Mar 2023 17:52:40 +0100
Message-Id: <20230307170038.206625185@linuxfoundation.org>
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

[ Upstream commit 1b5c09de25e8c08655c270a70e5e74e93b6bad1f ]

In the IMM opcode check, don't call is_addr_reg if it's not set.

Fixes: 8cc95f3fd35e ("drm/tegra: Add job firewall")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/firewall.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/tegra/firewall.c b/drivers/gpu/drm/tegra/firewall.c
index 1824d2db0e2ce..d53f890fa6893 100644
--- a/drivers/gpu/drm/tegra/firewall.c
+++ b/drivers/gpu/drm/tegra/firewall.c
@@ -97,6 +97,9 @@ static int fw_check_regs_imm(struct tegra_drm_firewall *fw, u32 offset)
 {
 	bool is_addr;
 
+	if (!fw->client->ops->is_addr_reg)
+		return 0;
+
 	is_addr = fw->client->ops->is_addr_reg(fw->client->base.dev, fw->class,
 					       offset);
 	if (is_addr)
-- 
2.39.2



