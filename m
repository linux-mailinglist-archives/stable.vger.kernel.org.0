Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959C859A0DD
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350598AbiHSQDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351491AbiHSQBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2379A7F10E;
        Fri, 19 Aug 2022 08:53:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2B8061746;
        Fri, 19 Aug 2022 15:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5DBC433D6;
        Fri, 19 Aug 2022 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924420;
        bh=ul3jL39BOEv9QE8D8Jfo0xeUQBhtdzlGmsM16ZAb31o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAondxF9dnMCFd2SU3e2tq5zOw2RIj6tWzpG8Qvzv4fU7V8lc7/1ZGo8rdFcsLrfF
         lQe2AR9jjjgo16w33lGxvPlA9AJOIIIfoMXPYTjVkU/YU9pT9OWihlCrOrpjYUa0Qb
         Li1jjSbu+/jHHUP9WU8naRnX0gUv5b5T3Mb4rtSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/545] drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()
Date:   Fri, 19 Aug 2022 17:38:55 +0200
Message-Id: <20220819153836.744077203@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 59cdadcece15..a5218747742b 100644
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



