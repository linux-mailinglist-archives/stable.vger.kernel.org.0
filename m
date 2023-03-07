Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F26AEF1B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjCGSUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjCGSUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781C49FE7F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADDE9B819BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2A6C433D2;
        Tue,  7 Mar 2023 18:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212857;
        bh=2SFXI/hh4a8eHKzq6wiy37/kjG64JrGbKyCDe0SeGYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IexRZV9RqooUldkUYbVhGpiI3jljakrhw/jpS5IIZ+lafi6i1/KoO6ggt0vNvJKE+
         elqZw621thEaHSb7a9mZItQSrR+N+CpNSK/iHkoeigpj5cPkSKbHDor30dR8JvbQ+A
         jzmTWiEmHuo2u18gOxq7yiARkDiWlCSnORBz6p4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 320/885] drm/tegra: firewall: Check for is_addr_reg existence in IMM check
Date:   Tue,  7 Mar 2023 17:54:14 +0100
Message-Id: <20230307170016.054993838@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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



