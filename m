Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22DB521939
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242769AbiEJNn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244822AbiEJNmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BB6238857;
        Tue, 10 May 2022 06:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1D0061821;
        Tue, 10 May 2022 13:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EBDC385C9;
        Tue, 10 May 2022 13:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189436;
        bh=DHz9FBVHZk9j/KZCg+ljNfPo6VkSfiVP4tnwrZI+KG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzatFk1IAx3Wf3bfSqxidbIa1jISSYSHD3fKgtjuyCcUhjLgmbgW7tPiewqIIPDNq
         aRfeLu8Q5NEKXlLMqfueUfP/lHOSwWqbZmMVvuEotQddKVqFjk6nFzTL8Z1F4WChxu
         JR77fUIoYahuF6bgTC/zfclzNuDyA1dZNVCx99pQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 051/135] net/mlx5e: Fix the calling of update_buffer_lossy() API
Date:   Tue, 10 May 2022 15:07:13 +0200
Message-Id: <20220510130741.864954889@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

commit c4d963a588a6e7c4ef31160e80697ae8e5a47746 upstream.

The arguments of update_buffer_lossy() is in a wrong order. Fix it.

Fixes: 88b3d5c90e96 ("net/mlx5e: Fix port buffers cell size value")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -309,8 +309,8 @@ int mlx5e_port_manual_buffer_config(stru
 		if (err)
 			return err;
 
-		err = update_buffer_lossy(max_mtu, curr_pfc_en, prio2buffer, port_buff_cell_sz,
-					  xoff, &port_buffer, &update_buffer);
+		err = update_buffer_lossy(max_mtu, curr_pfc_en, prio2buffer, xoff,
+					  port_buff_cell_sz, &port_buffer, &update_buffer);
 		if (err)
 			return err;
 	}


