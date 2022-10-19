Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C09604824
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiJSNtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbiJSNsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:48:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A50A169CE7;
        Wed, 19 Oct 2022 06:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9F9CB82403;
        Wed, 19 Oct 2022 08:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E977AC433D7;
        Wed, 19 Oct 2022 08:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666169826;
        bh=TWvekpxCQLsPdCpQ6E83BRmLzXBNTJyP0GcQMrJFkck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nw1qmLALAU7LVw6td58WiRkh86vmdlP6ufQAoVQITVnehA7Sfe/PLIpdRtc4Hv3jH
         WQBsBZwN812c6G8u28lqeqPkmwUBFmuD7PzQ+jIPHom5+Rg91olAxcSAJ8WRcpaSkN
         Q+jRVAdfCoh2VldfdHVlWDZOXX8VtXvakDtXM2RbOkfqOwaRizs+AvVbf6czVH1NFK
         LBE6hSqdXBid15L3KzS30vwPqbnWRQz0ssZsyOiaPvhzVaM93KYbnRJkrzlSOgGr/q
         zmlmvTfRjP2zDqWatv5jIsGvc6ejkwj9DZEvrcEiOGj0sugg78apiRB37XBTVObN52
         LT1JWQc9JbYbQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>
Subject: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64 option to pahole
Date:   Wed, 19 Oct 2022 10:56:04 +0200
Message-Id: <20221019085604.1017583-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019085604.1017583-1-jolsa@kernel.org>
References: <20221019085604.1017583-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 27445cb72974..8c82173e42e5 100755
--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -14,4 +14,8 @@ if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
 	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
 fi
 
+if [ "${pahole_ver}" -ge "124" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
+fi
+
 echo ${extra_paholeopt}
-- 
2.37.3

