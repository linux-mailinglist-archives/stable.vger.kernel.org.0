Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE827586967
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiHAMCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiHAMBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:01:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F624F682;
        Mon,  1 Aug 2022 04:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 363EBCE1157;
        Mon,  1 Aug 2022 11:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD2AC433D7;
        Mon,  1 Aug 2022 11:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354797;
        bh=PmkRJqX+XFsmViraul3CsMmcCbzpWi/US/m8nUUng9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBHr0DP2kdJMhJyPd8/G+TdF63q41KBjBCT3Tn2geVloXtUdDfGimX6o7pcXfoPqt
         ljOcopenXr6nuKsz2q/r7Lg4uOq6/RAEqqw5J2tOptvymMNaZoNGW4Kv3oDlZe4qi2
         nXE/xmfb0e3owP0/7UIaVRcQplI4LaiOMVU+2ngo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 24/69] octeontx2-pf: Fix UDP/TCP src and dst port tc filters
Date:   Mon,  1 Aug 2022 13:46:48 +0200
Message-Id: <20220801114135.496918838@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

commit 59e1be6f83b928a04189bbf3ab683a1fc6248db3 upstream.

Check the mask for non-zero value before installing tc filters
for L4 source and destination ports. Otherwise installing a
filter for source port installs destination port too and
vice-versa.

Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on ingress traffic")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c |   30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -571,21 +571,27 @@ static int otx2_tc_prepare_flow(struct o
 
 		flow_spec->dport = match.key->dst;
 		flow_mask->dport = match.mask->dst;
-		if (ip_proto == IPPROTO_UDP)
-			req->features |= BIT_ULL(NPC_DPORT_UDP);
-		else if (ip_proto == IPPROTO_TCP)
-			req->features |= BIT_ULL(NPC_DPORT_TCP);
-		else if (ip_proto == IPPROTO_SCTP)
-			req->features |= BIT_ULL(NPC_DPORT_SCTP);
+
+		if (flow_mask->dport) {
+			if (ip_proto == IPPROTO_UDP)
+				req->features |= BIT_ULL(NPC_DPORT_UDP);
+			else if (ip_proto == IPPROTO_TCP)
+				req->features |= BIT_ULL(NPC_DPORT_TCP);
+			else if (ip_proto == IPPROTO_SCTP)
+				req->features |= BIT_ULL(NPC_DPORT_SCTP);
+		}
 
 		flow_spec->sport = match.key->src;
 		flow_mask->sport = match.mask->src;
-		if (ip_proto == IPPROTO_UDP)
-			req->features |= BIT_ULL(NPC_SPORT_UDP);
-		else if (ip_proto == IPPROTO_TCP)
-			req->features |= BIT_ULL(NPC_SPORT_TCP);
-		else if (ip_proto == IPPROTO_SCTP)
-			req->features |= BIT_ULL(NPC_SPORT_SCTP);
+
+		if (flow_mask->sport) {
+			if (ip_proto == IPPROTO_UDP)
+				req->features |= BIT_ULL(NPC_SPORT_UDP);
+			else if (ip_proto == IPPROTO_TCP)
+				req->features |= BIT_ULL(NPC_SPORT_TCP);
+			else if (ip_proto == IPPROTO_SCTP)
+				req->features |= BIT_ULL(NPC_SPORT_SCTP);
+		}
 	}
 
 	return otx2_tc_parse_actions(nic, &rule->action, req, f, node);


