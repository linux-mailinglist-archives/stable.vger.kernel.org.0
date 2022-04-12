Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AC74FD864
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352520AbiDLHg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354168AbiDLH0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B050F45040;
        Tue, 12 Apr 2022 00:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E131B81B54;
        Tue, 12 Apr 2022 07:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A627C36AEA;
        Tue, 12 Apr 2022 07:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747160;
        bh=FN38w32qtUhnF2Zn1lD4Y4Ebgl+F/Fwi4fAlFKGu6+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOvf/m88OnymkuFe/ClB6wGkrZtB90K6e4FOEyOfQrdSOXikMs3wBbjVgvhfOX4E+
         grgw2BTCyVzB1tJrwBTrSzxgQ4sUa4HQMHyMxxjcRVs+oOvM/0cDJPHzjeptucvf9y
         tG9VQI3afe2V2O6NNyyXyIpqbA7IkAbV9DXNXEoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5.16 265/285] selftests/bpf: Fix u8 narrow load checks for bpf_sk_lookup remote_port
Date:   Tue, 12 Apr 2022 08:32:02 +0200
Message-Id: <20220412062951.307801901@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 3c69611b8926f8e74fcf76bd97ae0e5dafbeb26a upstream.

In commit 9a69e2b385f4 ("bpf: Make remote_port field in struct
bpf_sk_lookup 16-bit wide") ->remote_port field changed from __u32 to
__be16.

However, narrow load tests which exercise 1-byte sized loads from
offsetof(struct bpf_sk_lookup, remote_port) were not adopted to reflect the
change.

As a result, on little-endian we continue testing loads from addresses:

 - (__u8 *)&ctx->remote_port + 3
 - (__u8 *)&ctx->remote_port + 4

which map to the zero padding following the remote_port field, and don't
break the tests because there is no observable change.

While on big-endian, we observe breakage because tests expect to see zeros
for values loaded from:

 - (__u8 *)&ctx->remote_port - 1
 - (__u8 *)&ctx->remote_port - 2

Above addresses map to ->remote_ip6 field, which precedes ->remote_port,
and are populated during the bpf_sk_lookup IPv6 tests.

Unsurprisingly, on s390x we observe:

  #136/38 sk_lookup/narrow access to ctx v4:OK
  #136/39 sk_lookup/narrow access to ctx v6:FAIL

Fix it by removing the checks for 1-byte loads from offsets outside of the
->remote_port field.

Fixes: 9a69e2b385f4 ("bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide")
Suggested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20220319183356.233666-3-jakub@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
@@ -404,8 +404,7 @@ int ctx_narrow_access(struct bpf_sk_look
 
 	/* Narrow loads from remote_port field. Expect SRC_PORT. */
 	if (LSB(ctx->remote_port, 0) != ((SRC_PORT >> 0) & 0xff) ||
-	    LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff) ||
-	    LSB(ctx->remote_port, 2) != 0 || LSB(ctx->remote_port, 3) != 0)
+	    LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff))
 		return SK_DROP;
 	if (LSW(ctx->remote_port, 0) != SRC_PORT)
 		return SK_DROP;


