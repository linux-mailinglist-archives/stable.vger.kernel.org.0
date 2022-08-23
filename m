Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7A659D8A0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351139AbiHWJgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351747AbiHWJf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F247BE0A9;
        Tue, 23 Aug 2022 01:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9C1A614E9;
        Tue, 23 Aug 2022 08:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9F6C433D6;
        Tue, 23 Aug 2022 08:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243946;
        bh=aBbOxrSRthQiToFIYP2D6uOzkEITHeXp8+xs0ikkYag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WcuhgvOH05LSYY4zPnCLWc6elbdCwwjBRzFbVTyocl5j6j/EvhZezkME8uxfWImi
         dzorIhZUw2QarCuYEUd/rccHiIJpxYYC8xzuMkFrhelF/buM0AureyItViwvXYPhcr
         pTgCtI7B5jVkneIw0iuasUsH/dHN+wyxf4fz8Wn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 060/229] drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()
Date:   Tue, 23 Aug 2022 10:23:41 +0200
Message-Id: <20220823080055.880457049@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index d491b3aa124f..fa88c1809946 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -2738,10 +2738,10 @@ static int ni_set_mc_special_registers(struct radeon_device *rdev,
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
@@ -2750,8 +2750,6 @@ static int ni_set_mc_special_registers(struct radeon_device *rdev,
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



