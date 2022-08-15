Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1865E5948D5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353581AbiHOXhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353684AbiHOXf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:35:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCF515175B;
        Mon, 15 Aug 2022 13:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAC7EB810C5;
        Mon, 15 Aug 2022 20:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4341CC433D6;
        Mon, 15 Aug 2022 20:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594148;
        bh=Wv64WLePaMTiYT8GLdGRrBr0tGS1ZDL3nXXoLhy+o/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B064PjaZTQrG0HszkWjEF4LMgSQ+/SkHPZIN9ycaR1jR0qJio/wGS3owFxrd1HjYT
         KEVQPxFfXiKjxrdpw2pHsEPqkRwKDesLyyJgAtdpMG4A3MKYGm+UpE0WKH2PXjgVBA
         YtNBZ+hwLoz1dH756pbn3Mt4+GQ7+BdCjy7L5dwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0386/1157] drm/amd: Dont show warning on reading vbios values for SMU13 3.1
Date:   Mon, 15 Aug 2022 19:55:42 +0200
Message-Id: <20220815180455.144048569@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1320d6c7b0deb7219701a55397e93e6c73d00366 ]

Some APUs with SMU13 are showing the following message:
`amdgpu 0000:63:00.0: amdgpu: Unexpected and unhandled version: 3.1`

This warning isn't relevant for smu info 3.1, as no bootup information
is present in the table.

Fixes: 593a54f18031 ("drm/amd/pm: correct the way for retrieving bootup clocks")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index ef9b56de143b..5aa08c031f72 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -714,6 +714,8 @@ int smu_v13_0_get_vbios_bootup_values(struct smu_context *smu)
 			smu->smu_table.boot_values.vclk = smu_info_v3_6->bootup_vclk_10khz;
 			smu->smu_table.boot_values.dclk = smu_info_v3_6->bootup_dclk_10khz;
 			smu->smu_table.boot_values.fclk = smu_info_v3_6->bootup_fclk_10khz;
+		} else if ((frev == 3) && (crev == 1)) {
+			return 0;
 		} else if ((frev == 4) && (crev == 0)) {
 			smu_info_v4_0 = (struct atom_smu_info_v4_0 *)header;
 
-- 
2.35.1



