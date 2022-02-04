Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2494A9681
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358374AbiBDJ0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:26:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44172 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358018AbiBDJZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699CE61602;
        Fri,  4 Feb 2022 09:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCD1C004E1;
        Fri,  4 Feb 2022 09:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966706;
        bh=IjJK+yt4eIiTBKn6aNSapd1Q6Hm6qu7JqEQZHEp0YE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mX+0bp28MhjmSqfvUbSDVzGMkx+17EKIQ/9zvPiWHsGemwxjBxneVEQ5CDFGr0f/A
         tQTU9a+UkTj3U9yTQurZziVHos2KhtOFdBBsg2kkHzZnYOruSn8TZ6XsLpC3pYDF81
         CCtSbjbctSRScH/gvJNszpkH+pOxlrfNu1o0QLmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 14/43] net/mlx5e: TC, Reject rules with drop and modify hdr action
Date:   Fri,  4 Feb 2022 10:22:21 +0100
Message-Id: <20220204091917.640709686@linuxfoundation.org>
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

commit a2446bc77a16cefd27de712d28af2396d6287593 upstream.

This kind of action is not supported by firmware and generates a
syndrome.

kernel: mlx5_core 0000:08:00.0: mlx5_cmd_check:777:(pid 102063): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8708c3)

Fixes: d7e75a325cb2 ("net/mlx5e: Add offloading of E-Switch TC pedit (header re-write) actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3421,6 +3421,12 @@ actions_match_supported(struct mlx5e_pri
 	}
 
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");
+		return false;
+	}
+
+	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action,
 					   actions, ct_flow, ct_clear, extack))
 		return false;


