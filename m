Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC830603DA9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiJSJF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiJSJEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04923AC3B6;
        Wed, 19 Oct 2022 01:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA2176186B;
        Wed, 19 Oct 2022 08:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677B2C433D7;
        Wed, 19 Oct 2022 08:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666169806;
        bh=FHplcX8F9FjqJEVgQ0myqZXIIqUdUA+fWPAh3k3STBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMbc1Id9QkMtEDL5f3VdQu/JF7COp9SBHborA0lIktnilsvzVRFJ2Aa2Go55ZLjlq
         5wpm3b6BQEdKwAA+VccyvB6sH3zTsAgQVPWFR4DSHZRarpWweRlIHiZInteaJmB2oN
         qD2CACWFrarMmgdVuMFy7N7GGG3pY0r2wi6CF+cNjOGbF2b0vgiZkMEkgbFd7FK0XN
         9T88abcmWKhoph3awtxGLOrG8gFjFbrVpOVVj4owi5JQqPDvio8rPMSmbeRNbfii+e
         EEH9xrecU681XGCHWAOf3t+wAuvU4oSgjvFUM6tcxludwucvagDTMIj2y+VbT8zFXY
         u+gmnnkukgogA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hao Luo <haoluo@google.com>,
        Michal Suchanek <msuchanek@suse.de>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>
Subject: [PATCH stable 5.10 3/5] kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21
Date:   Wed, 19 Oct 2022 10:56:02 +0200
Message-Id: <20221019085604.1017583-4-jolsa@kernel.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

commit a0b8200d06ad6450c179407baa5f0f52f8cfcc97 upstream.

[small context changes due to missing floats support in 5.10]

Commit "mm/page_alloc: convert per-cpu list protection to local_lock" will
introduce a zero-sized per-CPU variable, which causes pahole to generate
invalid BTF.  Only pahole versions 1.18 through 1.21 are impacted, as
before 1.18 pahole doesn't know anything about per-CPU variables, and 1.22
contains the proper fix for the issue.

Luckily, pahole 1.18 got --skip_encoding_btf_vars option disabling BTF
generation for per-CPU variables in anticipation of some unanticipated
problems.  So use this escape hatch to disable per-CPU var BTF info on
those problematic pahole versions.  Users relying on availability of
per-CPU var BTFs would need to upgrade to pahole 1.22+, but everyone won't
notice any regressions.

Link: https://lkml.kernel.org/r/20210530002536.3193829-1-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 scripts/link-vmlinux.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 72bf14df6903..bbb22be4c8f1 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -161,6 +161,11 @@ gen_btf()
 
 	vmlinux_link ${1}
 
+	if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
+		# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
+		extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
+	fi
+
 	info "BTF" ${2}
 	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${extra_paholeopt} ${1}
 
-- 
2.37.3

