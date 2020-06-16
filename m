Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EE81FB77A
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbgFPPqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732200AbgFPPqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A88F5214F1;
        Tue, 16 Jun 2020 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322394;
        bh=lC0Nos0Z2xN682tVmoX7eeKjh3ClUl7Mw27xlR7HuUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsFpV+mQTJObZa2B0eQiJZh9sG9R6gTu8gtbspsSldCot4Tt2E2JSpXgME2a/dXIj
         J4GXc0vWEdAA86efBJuGv2HkdlRgxwqCQy+6hJcK8SKnTMqvwWchyOwkuGaD2ai8oc
         8IcwVp4hGsq3f0iS+1R1QBgyqWsQ/hmKXPOtVFhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oz Shlomo <ozsh@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.7 114/163] net/mlx5e: CT: Fix ipv6 nat header rewrite actions
Date:   Tue, 16 Jun 2020 17:34:48 +0200
Message-Id: <20200616153112.265339373@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oz Shlomo <ozsh@mellanox.com>

[ Upstream commit 0d156f2deda8675c29fa2b8b5ed9b374370e47f2 ]

Set the ipv6 word fields according to the hardware definitions.

Fixes: ac991b48d43c ("net/mlx5e: CT: Offload established flows")
Signed-off-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -320,21 +320,21 @@ mlx5_tc_ct_parse_mangle_to_mod_act(struc
 
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
 		MLX5_SET(set_action_in, modact, length, 0);
-		if (offset == offsetof(struct ipv6hdr, saddr))
+		if (offset == offsetof(struct ipv6hdr, saddr) + 12)
 			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0;
-		else if (offset == offsetof(struct ipv6hdr, saddr) + 4)
-			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32;
 		else if (offset == offsetof(struct ipv6hdr, saddr) + 8)
+			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32;
+		else if (offset == offsetof(struct ipv6hdr, saddr) + 4)
 			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64;
-		else if (offset == offsetof(struct ipv6hdr, saddr) + 12)
+		else if (offset == offsetof(struct ipv6hdr, saddr))
 			field = MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96;
-		else if (offset == offsetof(struct ipv6hdr, daddr))
+		else if (offset == offsetof(struct ipv6hdr, daddr) + 12)
 			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0;
-		else if (offset == offsetof(struct ipv6hdr, daddr) + 4)
-			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32;
 		else if (offset == offsetof(struct ipv6hdr, daddr) + 8)
+			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32;
+		else if (offset == offsetof(struct ipv6hdr, daddr) + 4)
 			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64;
-		else if (offset == offsetof(struct ipv6hdr, daddr) + 12)
+		else if (offset == offsetof(struct ipv6hdr, daddr))
 			field = MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96;
 		else
 			return -EOPNOTSUPP;


