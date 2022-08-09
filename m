Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79E058DE2E
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345297AbiHISMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345798AbiHISLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:11:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2982AE3C;
        Tue,  9 Aug 2022 11:04:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91FE96109E;
        Tue,  9 Aug 2022 18:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984A1C433C1;
        Tue,  9 Aug 2022 18:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068295;
        bh=eTqp+mS2QGd6/HOEequo25/mWWN1lPw0MY+Bc27lKjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzuhbOllUMf+3TfGvj3qsbjSCcjsFmszE2J/Qh5aY0WpwX/ooF6dnViKXA2wxVmEO
         IJJ+fZZerFZcyHdpNOvoVYjmejLWzepNsmf2EMqxYygN8uRKcJqJmCCqqirk5rnqs1
         MVRz+qbjV6XTt0ajc9tbC6KocaBSLBgg9HrmXMGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 03/30] selftests/bpf: Check dst_port only on the client socket
Date:   Tue,  9 Aug 2022 20:00:28 +0200
Message-Id: <20220809175514.383072069@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
References: <20220809175514.276643253@linuxfoundation.org>
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

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 2d2202ba858c112b03f84d546e260c61425831a1 upstream.

cgroup_skb/egress programs which sock_fields test installs process packets
flying in both directions, from the client to the server, and in reverse
direction.

Recently added dst_port check relies on the fact that destination
port (remote peer port) of the socket which sends the packet is known ahead
of time. This holds true only for the client socket, which connects to the
known server port.

Filter out any traffic that is not egressing from the client socket in the
BPF program that tests reading the dst_port.

Fixes: 8f50f16ff39d ("selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20220317113920.1068535-3-jakub@cloudflare.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/test_sock_fields.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -281,6 +281,10 @@ int read_sk_dst_port(struct __sk_buff *s
 	if (!sk)
 		RET_LOG();
 
+	/* Ignore everything but the SYN from the client socket */
+	if (sk->state != BPF_TCP_SYN_SENT)
+		return CG_OK;
+
 	if (!sk_dst_port__load_word(sk))
 		RET_LOG();
 	if (!sk_dst_port__load_half(sk))


