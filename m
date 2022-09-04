Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B158D5AC474
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 15:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbiIDNT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 09:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiIDNT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 09:19:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BB8F06;
        Sun,  4 Sep 2022 06:19:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 261E860F72;
        Sun,  4 Sep 2022 13:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75930C433D6;
        Sun,  4 Sep 2022 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662297565;
        bh=lWEhgTPceRtQtvF4si+5cmZLIdnJa5fVvWICEjPXDT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SizOlOp2A1FZw1mGqAA4hy4kW5wtx5psNWbGMDfLjyn1X+yGM17ZaXqetV9Z/V0am
         qupNhN+FJoYJUebGpbggC02vo07hX4ni25KKmM3HVFQiZLEJdPKP4rtRNVgSJdrA0y
         yWlh3PIpuj9g0EwUCedN7rvayQpDfGwUQz4dr88NxfvGQ8YrxcR+3CBLsJfB72TnbK
         N6IXr8T4u78/R77tlRBwvIQxgqQGCNmwOFCxHLL9dOMUF1HcmTE0tj7ONOZ7S6jCmg
         SgEvcm5Cv+uKezdYH4Obrm2orhKmqnrWHtqzud93kUS0bRB5ZHJX00e9ZMjBA/qrX6
         svkmPuMXEAfAQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH stable 5.15 2/2] kbuild: Add skip_encoding_btf_enum64 option to pahole
Date:   Sun,  4 Sep 2022 15:19:01 +0200
Message-Id: <20220904131901.13025-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220904131901.13025-1-jolsa@kernel.org>
References: <20220904131901.13025-1-jolsa@kernel.org>
MIME-Version: 1.0
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

From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>

New pahole (version 1.24) generates by default new BTF_KIND_ENUM64 BTF tag,
which is not supported by stable kernel.

As a result the kernel with CONFIG_DEBUG_INFO_BTF option will fail to
compile with following error:

  BTFIDS  vmlinux
FAILED: load BTF from vmlinux: Invalid argument

New pahole provides --skip_encoding_btf_enum64 option to skip BTF_KIND_ENUM64
generation and produce BTF supported by stable kernel.

Adding this option to scripts/pahole-flags.sh.

This change does not have equivalent commit in linus tree, because linus tree
has support for BTF_KIND_ENUM64 tag, so it does not need to be disabled.

Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 scripts/pahole-flags.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
index e6093adf4c06..7acee326aa6c 100755
--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -17,4 +17,8 @@ if [ "${pahole_ver}" -ge "121" ]; then
 	extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
 fi
 
+if [ "${pahole_ver}" -ge "124" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
+fi
+
 echo ${extra_paholeopt}
-- 
2.37.2

