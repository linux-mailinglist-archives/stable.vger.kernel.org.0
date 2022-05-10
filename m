Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB52521AA7
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244845AbiEJODE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245136AbiEJN5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A972CAAA9;
        Tue, 10 May 2022 06:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E875618A6;
        Tue, 10 May 2022 13:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D3BC385A6;
        Tue, 10 May 2022 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189929;
        bh=hyKNgmokdkIhVY6XJwyLC5CSdldQB2W5tsQhWiXwlRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4Qaebymms1fdMw06JEwaCXFnPHhDngm3Dw1m+dkecj70GF+OSb3EyK0CF7Bv0FDx
         ID0ULX2T6KJYrj/aZwOgBSIOwWWf2MVoMR/p7/PcFLnVCJ/AG3sXt8XefN5JSEAWLF
         TQlmCzZTDK/5WT+5MVkCTqv+m7eidZKw1nM+4eO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.17 073/140] net/mlx5e: Lag, Fix fib_info pointer assignment
Date:   Tue, 10 May 2022 15:07:43 +0200
Message-Id: <20220510130743.704855403@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

commit a6589155ec9847918e00e7279b8aa6d4c272bea7 upstream.

Referenced change incorrectly sets single path fib_info even when LAG is
not active. Fix it by moving call to mlx5_lag_fib_set() into conditional
that verifies LAG state.

Fixes: ad11c4f1d8fd ("net/mlx5e: Lag, Only handle events from highest priority multipath entry")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -149,9 +149,9 @@ static void mlx5_lag_fib_route_event(str
 
 			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
+			mlx5_lag_fib_set(mp, fi);
 		}
 
-		mlx5_lag_fib_set(mp, fi);
 		return;
 	}
 


