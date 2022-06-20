Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977BD551B54
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245112AbiFTNKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245692AbiFTNJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E59228;
        Mon, 20 Jun 2022 06:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A417B811C6;
        Mon, 20 Jun 2022 13:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF10C3411B;
        Mon, 20 Jun 2022 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730144;
        bh=M/2gDY7ZzNb/oAKKkhfnwbKWyEObv/vJS66e1WXjz3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtAKoeoyxJm+z56H8a5RQFrb4coUfhZn2x+dg/eIz2hnOzuQThMYn9k+mpms/RasT
         g9bAoRwn9aBHcSg1ZQbL+ZPGmjaF49M8G5gIbxREupa2e4YcYwc5CVacxzzZ8XoeeO
         7bQRfeXJ0lweJI+M3tjxdpEzQdXlqbvKyVW9+GIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/84] mlxsw: spectrum_cnt: Reorder counter pools
Date:   Mon, 20 Jun 2022 14:51:10 +0200
Message-Id: <20220620124722.280423006@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 4b7a632ac4e7101ceefee8484d5c2ca505d347b3 ]

Both RIF and ACL flow counters use a 24-bit SW-managed counter address to
communicate which counter they want to bind.

In a number of Spectrum FW releases, binding a RIF counter is broken and
slices the counter index to 16 bits. As a result, on Spectrum-2 and above,
no more than about 410 RIF counters can be effectively used. This
translates to 205 netdevices for which L3 HW stats can be enabled. (This
does not happen on Spectrum-1, because there are fewer counters available
overall and the counter index never exceeds 16 bits.)

Binding counters to ACLs does not have this issue. Therefore reorder the
counter allocation scheme so that RIF counters come first and therefore get
lower indices that are below the 16-bit barrier.

Fixes: 98e60dce4da1 ("Merge branch 'mlxsw-Introduce-initial-Spectrum-2-support'")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20220613125017.2018162-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
index a68d931090dd..15c8d4de8350 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
@@ -8,8 +8,8 @@
 #include "spectrum.h"
 
 enum mlxsw_sp_counter_sub_pool_id {
-	MLXSW_SP_COUNTER_SUB_POOL_FLOW,
 	MLXSW_SP_COUNTER_SUB_POOL_RIF,
+	MLXSW_SP_COUNTER_SUB_POOL_FLOW,
 };
 
 int mlxsw_sp_counter_alloc(struct mlxsw_sp *mlxsw_sp,
-- 
2.35.1



