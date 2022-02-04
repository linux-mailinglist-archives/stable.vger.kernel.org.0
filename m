Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8474A968F
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358117AbiBDJ1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357875AbiBDJZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF80C0617A7;
        Fri,  4 Feb 2022 01:25:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3098616D9;
        Fri,  4 Feb 2022 09:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA11C340ED;
        Fri,  4 Feb 2022 09:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966729;
        bh=ajtamET1XAUTRvLWbWJUsVal1vAqIubTQv05s4lp/40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZdgWdJ8fvHMayUzu8LnHrmY3SU5kjRkfRXaPuEqR9yGeJuh3a9Wk6cgrC7feP2RS
         O7F2HeVJRYaz9BWYSZKrdbiX/Jca9k9jrW1mLBod1ns5dhhDF6FRYf5x6PY309HYyb
         D3U+Z2HfMmEgCpMkVnh4nn0dl5fD0bEy4B4hh4DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 20/43] net/mlx5e: TC, Reject rules with forward and drop actions
Date:   Fri,  4 Feb 2022 10:22:27 +0100
Message-Id: <20220204091917.835596255@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

commit 5623ef8a118838aae65363750dfafcba734dc8cb upstream.

Such rules are redundant but allowed and passed to the driver.
The driver does not support offloading such rules so return an error.

Fixes: 03a9d11e6eeb ("net/mlx5e: Add TC drop and mirred/redirect action parsing for SRIOV offloads")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3420,6 +3420,12 @@ actions_match_supported(struct mlx5e_pri
 		return false;
 	}
 
+	if (!(~actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule cannot support forward+drop action");
+		return false;
+	}
+
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
 		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");


