Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24B59DE1C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbiHWLTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357561AbiHWLRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:17:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC9389835;
        Tue, 23 Aug 2022 02:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06AF26121F;
        Tue, 23 Aug 2022 09:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A98C433C1;
        Tue, 23 Aug 2022 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246498;
        bh=x4pgOTjFZ7j24t7uOJInGC/hzSu3Wx5f/DwhD36NE14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeAlSf87BIKkdgMqTQxsH+os40Ew0kp/TkFIovgthGYZw9iFwsQfYhiMFdlV4U06z
         ihDv6kM5oXwi6ReJp2zqEJE+Z7jumrAcBwyaJrOoPe9mt6SWAyaKV8S647L51FtRW9
         8HHgSGt7chB2VpB/MbjLeGL3hdKwoxzIn5anEub4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/389] drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()
Date:   Tue, 23 Aug 2022 10:22:56 +0200
Message-Id: <20220823080119.697036744@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit 136f614931a2bb73616b292cf542da3a18daefd5 ]

The last case label can write two buffers 'mc_reg_address[j]' and
'mc_data[j]' with 'j' offset equal to SMC_NISLANDS_MC_REGISTER_ARRAY_SIZE
since there are no checks for this value in both case labels after the
last 'j++'.

Instead of changing '>' to '>=' there, add the bounds check at the start
of the second 'case' (the first one already has it).

Also, remove redundant last checks for 'j' index bigger than array size.
The expression is always false. Moreover, before or after the patch
'table->last' can be equal to SMC_NISLANDS_MC_REGISTER_ARRAY_SIZE and it
seems it can be a valid value.

Detected using the static analysis tool - Svace.
Fixes: 69e0b57a91ad ("drm/radeon/kms: add dpm support for cayman (v5)")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/ni_dpm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index bd2e577c701f..288ec3039bc2 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -2740,10 +2740,10 @@ static int ni_set_mc_special_registers(struct radeon_device *rdev,
 					table->mc_reg_table_entry[k].mc_data[j] |= 0x100;
 			}
 			j++;
-			if (j > SMC_NISLANDS_MC_REGISTER_ARRAY_SIZE)
-				return -EINVAL;
 			break;
 		case MC_SEQ_RESERVE_M >> 2:
+			if (j >= SMC_NISLANDS_MC_REGISTER_ARRAY_SIZE)
+				return -EINVAL;
 			temp_reg = RREG32(MC_PMG_CMD_MRS1);
 			table->mc_reg_address[j].s1 = MC_PMG_CMD_MRS1 >> 2;
 			table->mc_reg_address[j].s0 = MC_SEQ_PMG_CMD_MRS1_LP >> 2;
@@ -2752,8 +2752,6 @@ static int ni_set_mc_special_registers(struct radeon_device *rdev,
 					(temp_reg & 0xffff0000) |
 					(table->mc_reg_table_entry[k].mc_data[i] & 0x0000ffff);
 			j++;
-			if (j > SMC_NISLANDS_MC_REGISTER_ARRAY_SIZE)
-				return -EINVAL;
 			break;
 		default:
 			break;
-- 
2.35.1



