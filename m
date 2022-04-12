Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B164FD49F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348482AbiDLHpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356345AbiDLHfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:35:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB88F50E2E;
        Tue, 12 Apr 2022 00:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B978616E3;
        Tue, 12 Apr 2022 07:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A961EC385A5;
        Tue, 12 Apr 2022 07:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747361;
        bh=ml72iPm2ujhvVrlOqTzu2cWjMgaiiwbonFftTOGfFDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlVC9e2XmEh927T042mUJOUbm5p/5D2pagEdHpCaJ9C5TJHcfFKebNEbykHc9qfys
         bIfcMPcps75ZCC+heaUdX2gk+dmtce7GBEZMF/yu60qeHcD2KkhcFiLmJscn0sw0m9
         5UMaCWGezafkDKIAXyFw1UQvYMhKQoRzOh5ERHO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Witold Fijalkowski <witoldx.fijalkowski@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 050/343] i40e: Add sending commands in atomic context
Date:   Tue, 12 Apr 2022 08:27:48 +0200
Message-Id: <20220412062952.550900069@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit 59b3d7350ff35c939b8e173eb2eecac80a5ee046 ]

Change functions:
- i40e_aq_add_macvlan
- i40e_aq_remove_macvlan
- i40e_aq_delete_element
- i40e_aq_add_vsi
- i40e_aq_update_vsi_params
to explicitly use i40e_asq_send_command_atomic(..., true)
instead of i40e_asq_send_command, as they use mutexes and do some
work in an atomic context.
Without this change setting vlan via netdev will fail with
call trace cased by bug "BUG: scheduling while atomic".

Signed-off-by: Witold Fijalkowski <witoldx.fijalkowski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 9ddeb015eb7e..e830987a8c6d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1899,8 +1899,9 @@ i40e_status i40e_aq_add_vsi(struct i40e_hw *hw,
 
 	desc.flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF | I40E_AQ_FLAG_RD));
 
-	status = i40e_asq_send_command(hw, &desc, &vsi_ctx->info,
-				    sizeof(vsi_ctx->info), cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, &vsi_ctx->info,
+					      sizeof(vsi_ctx->info),
+					      cmd_details, true);
 
 	if (status)
 		goto aq_add_vsi_exit;
@@ -2287,8 +2288,9 @@ i40e_status i40e_aq_update_vsi_params(struct i40e_hw *hw,
 
 	desc.flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF | I40E_AQ_FLAG_RD));
 
-	status = i40e_asq_send_command(hw, &desc, &vsi_ctx->info,
-				    sizeof(vsi_ctx->info), cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, &vsi_ctx->info,
+					      sizeof(vsi_ctx->info),
+					      cmd_details, true);
 
 	vsi_ctx->vsis_allocated = le16_to_cpu(resp->vsi_used);
 	vsi_ctx->vsis_unallocated = le16_to_cpu(resp->vsi_free);
@@ -2673,8 +2675,8 @@ i40e_status i40e_aq_add_macvlan(struct i40e_hw *hw, u16 seid,
 	if (buf_size > I40E_AQ_LARGE_BUF)
 		desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
 
-	status = i40e_asq_send_command(hw, &desc, mv_list, buf_size,
-				       cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, mv_list, buf_size,
+					      cmd_details, true);
 
 	return status;
 }
@@ -2715,8 +2717,8 @@ i40e_status i40e_aq_remove_macvlan(struct i40e_hw *hw, u16 seid,
 	if (buf_size > I40E_AQ_LARGE_BUF)
 		desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
 
-	status = i40e_asq_send_command(hw, &desc, mv_list, buf_size,
-				       cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, mv_list, buf_size,
+					      cmd_details, true);
 
 	return status;
 }
@@ -3868,7 +3870,8 @@ i40e_status i40e_aq_delete_element(struct i40e_hw *hw, u16 seid,
 
 	cmd->seid = cpu_to_le16(seid);
 
-	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, NULL, 0,
+					      cmd_details, true);
 
 	return status;
 }
-- 
2.35.1



