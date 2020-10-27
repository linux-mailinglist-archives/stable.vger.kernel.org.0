Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E574C29C192
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780235AbgJ0Ox6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773034AbgJ0Ou4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:50:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7E3C207DE;
        Tue, 27 Oct 2020 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810256;
        bh=MRqVeXbnIcwa+5zDFlUD2QANOZOi20DcVfB3RjFAVhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFHLEDC7iS65UIn8W1KS2AEUcGs5c/XdKY6je0Wig7J034Ep5bQYFYHe43g68vyW6
         00d+SCOYjmgF3wloaVTsn0q308GNjrMt5WJQh/MWLr49uQzPBzi2B1bQSRFDNmWqZ5
         PWZrPyYchwcUueqACIBoVbU8VwT1ij3Xx2VnM7/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 045/633] net/sched: act_ct: Fix adding udp port mangle operation
Date:   Tue, 27 Oct 2020 14:46:28 +0100
Message-Id: <20201027135524.811333164@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 47b5d2a107396ab05e83a4dfbd30b563ecbc83af ]

Need to use the udp header type and not tcp.

Fixes: 9c26ba9b1f45 ("net/sched: act_ct: Instantiate flow table entry actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Link: https://lore.kernel.org/r/20201019090244.3015186-1-roid@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -156,11 +156,11 @@ tcf_ct_flow_table_add_action_nat_udp(con
 	__be16 target_dst = target.dst.u.udp.port;
 
 	if (target_src != tuple->src.u.udp.port)
-		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 					 offsetof(struct udphdr, source),
 					 0xFFFF, be16_to_cpu(target_src));
 	if (target_dst != tuple->dst.u.udp.port)
-		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 					 offsetof(struct udphdr, dest),
 					 0xFFFF, be16_to_cpu(target_dst));
 }


