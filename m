Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F273D6AEE76
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjCGSMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCGSL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:11:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1610CB1EC0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:07:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA792B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FD1C433EF;
        Tue,  7 Mar 2023 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212424;
        bh=MXse3LNSgcA5exqHqF/A/wHsXvDDIiqZGvkyuljOO4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gl6b1jtnf2dXorlnTqNNXk7Gt7LXJPDZ+D2xK43wKFbTZDljOC3Vp6fybuB6oyLX
         mtbJ1ozHzXGz5F5XDqhtsXH4c2ves4S/WiR0tMhC+CMZxXmDcmBn46QqpAnYGsPMK4
         SvuFlPF1jGs8Oj9qWkhzJgReK8Ozp8dvA4vutr0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/885] selftests/xsk: print correct payload for packet dump
Date:   Tue,  7 Mar 2023 17:51:24 +0100
Message-Id: <20230307170008.408687578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 2d0b2ae2871ae6d42a9f0a4280e0fb5bff8d38b8 ]

Print the correct payload when the packet dump option is selected. The
network to host conversion was forgotten and the payload was
erronously declared to be an int instead of an unsigned int.

Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20230111093526.11682-2-magnus.karlsson@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xskxceiver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 681a5db80dae0..51e693318b3f0 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -767,7 +767,7 @@ static void pkt_dump(void *pkt, u32 len)
 	struct ethhdr *ethhdr;
 	struct udphdr *udphdr;
 	struct iphdr *iphdr;
-	int payload, i;
+	u32 payload, i;
 
 	ethhdr = pkt;
 	iphdr = pkt + sizeof(*ethhdr);
@@ -792,7 +792,7 @@ static void pkt_dump(void *pkt, u32 len)
 	fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
 	fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
 	/*extract L5 frame */
-	payload = *((uint32_t *)(pkt + PKT_HDR_SIZE));
+	payload = ntohl(*((u32 *)(pkt + PKT_HDR_SIZE)));
 
 	fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
 	fprintf(stdout, "---------------------------------------\n");
-- 
2.39.2



