Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02280551B52
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245390AbiFTNLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343968AbiFTNJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65E31AF29;
        Mon, 20 Jun 2022 06:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFAF61548;
        Mon, 20 Jun 2022 13:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03842C3411B;
        Mon, 20 Jun 2022 13:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730090;
        bh=3URXF5M3vcnkfz10ois3e+5aTzkVfZWqV/ln18/fkC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1n8rwbOHhDWwnu11BxOxiC7tech4ZNafh4qLV07yMH9Hp65tPAeKZ0TpV6ILFtfu
         a8zHN7C7GnDXlZPRA25cMV3kf4S6y6ElxJw2oHMHLMzAonKP3x4Rk0OmwnfHvT/bLh
         bWcVrc4LOOPBrgIhODy7l14C/sH4pZDDWUA7w9MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/84] mellanox: mlx5: avoid uninitialized variable warning with gcc-12
Date:   Mon, 20 Jun 2022 14:50:53 +0200
Message-Id: <20220620124721.785152170@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 842c3b3ddc5f4d17275edbaa09e23d712bf8b915 ]

gcc-12 started warning about 'tracker' being used uninitialized:

  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c: In function ‘mlx5_do_bond’:
  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:786:28: warning: ‘tracker’ is used uninitialized [-Wuninitialized]
    786 |         struct lag_tracker tracker;
        |                            ^~~~~~~

which seems to be because it doesn't track how the use (and
initialization) is bound by the 'do_bond' flag.

But admittedly that 'do_bond' usage is fairly complicated, and involves
passing it around as an argument to helper functions, so it's somewhat
understandable that gcc doesn't see how that all works.

This function could be rewritten to make the use of that tracker
variable more obviously safe, but for now I'm just adding the forced
initialization of it.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 11cc3ea5010a..9fb3e5ec1da6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -274,7 +274,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
-	struct lag_tracker tracker;
+	struct lag_tracker tracker = { };
 	bool do_bond, roce_lag;
 	int err;
 
-- 
2.35.1



