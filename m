Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0025947BF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiHOXTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241347AbiHOXRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C077CB58;
        Mon, 15 Aug 2022 13:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23E1DB810C5;
        Mon, 15 Aug 2022 20:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFEEC433D6;
        Mon, 15 Aug 2022 20:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593816;
        bh=u+YTZMnI+mHY8ePME3H/NiQfW4K6V1KRiwc+uCFjTLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2h0W4twkyg0RcPuzV6b7UGIyznxmqBq9PVOw54aDTeRQwJTZa8ZEgTKrF2mHa55j
         762DJTGyL34B/c5grCZ62p48qPTa7b9KzlS2FOWnJPC/upSZrIttqded+mfcBvggNj
         k/Liu3TvvqGrK74gE2CxwAUENeC5kYVtQ5UTivQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0330/1157] sample: bpf: xdp_router_ipv4: Allow the kernel to send arp requests
Date:   Mon, 15 Aug 2022 19:54:46 +0200
Message-Id: <20220815180452.870580758@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 200a89e3e88786b52bc1dd5f26a310c097f4c6a7 ]

Forward the packet to the kernel if the gw router mac address is missing
in to trigger ARP discovery.

Fixes: 85bf1f51691c ("samples: bpf: Convert xdp_router_ipv4 to XDP samples helper")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/60bde5496d108089080504f58199bcf1143ea938.1653471558.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_router_ipv4.bpf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/samples/bpf/xdp_router_ipv4.bpf.c b/samples/bpf/xdp_router_ipv4.bpf.c
index 248119ca7938..0643330d1d2e 100644
--- a/samples/bpf/xdp_router_ipv4.bpf.c
+++ b/samples/bpf/xdp_router_ipv4.bpf.c
@@ -150,6 +150,15 @@ int xdp_router_ipv4_prog(struct xdp_md *ctx)
 
 				dest_mac = bpf_map_lookup_elem(&arp_table,
 							       &prefix_value->gw);
+				if (!dest_mac) {
+					/* Forward the packet to the kernel in
+					 * order to trigger ARP discovery for
+					 * the default gw.
+					 */
+					if (rec)
+						NO_TEAR_INC(rec->xdp_pass);
+					return XDP_PASS;
+				}
 			}
 		}
 
-- 
2.35.1



