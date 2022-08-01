Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2E0586A6C
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbiHAMQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiHAMPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D1441981;
        Mon,  1 Aug 2022 04:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9282BB80EAC;
        Mon,  1 Aug 2022 11:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E304AC433D7;
        Mon,  1 Aug 2022 11:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355102;
        bh=LARZAiDrC/yVd6yIGxBo8r5qc1cW9qVjsXp3JdlPGDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NI1M9BddxTbnQ6Mlsp6AV+SrQUKZmPCQvIk2ygze5s+Nif3oGFCSn/97JwlS8o5GQ
         WaqFb8sf77CilotN/qQotAjUXCuwYePnXPhutGxVt8iejLA4E3pGCiczbs7z+JmSfD
         QfQt3IbkPae8Phs+0j6IGs4RFPz85cdwUWVcyppI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.18 33/88] octeontx2-pf: Fix UDP/TCP src and dst port tc filters
Date:   Mon,  1 Aug 2022 13:46:47 +0200
Message-Id: <20220801114139.546511574@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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
@@ -614,21 +614,27 @@ static int otx2_tc_prepare_flow(struct o
 
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


