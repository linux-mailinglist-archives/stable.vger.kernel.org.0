Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A104FD919
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377530AbiDLHuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359332AbiDLHm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8286655BD5;
        Tue, 12 Apr 2022 00:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE6F161045;
        Tue, 12 Apr 2022 07:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC71BC385A1;
        Tue, 12 Apr 2022 07:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748102;
        bh=ukYIttTkRh32/HUCKuAwdQbcD6m6qpbo3GBE7o+PO2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiS5FvujV2JaM0bJy1K5n+TcNmS/g2rnNOLQyT+Bd6q186g16G7Ni1kM7JBwyiZO1
         t6NhVgRUXea9v8mZh10kQjYt6KGZ/hxL80FsWCs6u2eqCONFbFEzERdiFV7DSHKF3g
         MUDxHTmAveIaAUfE7oqx7Y0ojRwzEg5QKqiQOxXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5.17 318/343] selftests/bpf: Fix u8 narrow load checks for bpf_sk_lookup remote_port
Date:   Tue, 12 Apr 2022 08:32:16 +0200
Message-Id: <20220412063000.500098068@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
@@ -412,8 +412,7 @@ int ctx_narrow_access(struct bpf_sk_look
 
 	/* Narrow loads from remote_port field. Expect SRC_PORT. */
 	if (LSB(ctx->remote_port, 0) != ((SRC_PORT >> 0) & 0xff) ||
-	    LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff) ||
-	    LSB(ctx->remote_port, 2) != 0 || LSB(ctx->remote_port, 3) != 0)
+	    LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff))
 		return SK_DROP;
 	if (LSW(ctx->remote_port, 0) != SRC_PORT)
 		return SK_DROP;


