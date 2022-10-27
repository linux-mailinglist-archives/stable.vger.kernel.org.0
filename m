Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B383460FE6C
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbiJ0RFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbiJ0RFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBDF5F7FC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE090B82561
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5ADC433C1;
        Thu, 27 Oct 2022 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890298;
        bh=sCuLsfho8avh6U137l5CQMsogzthBagkig63456NyFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onGCHrlO3hhVhnBS2RFtEX+p1tif5DeogDK+T29ibGcr6U1SFFIhLxJ1nnEY65P7C
         gUFzb+IaCq1UGzVVDAHnFd/QaZCuQCHDRVe41dLq6HO/8JXQIsg6d9y2vhu8oAipYF
         ja63gQIlwDOkTQQTeX/Y0qxYtUEu9hszyuuYSsIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hao Luo <haoluo@google.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 18/79] kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21
Date:   Thu, 27 Oct 2022 18:55:28 +0200
Message-Id: <20221027165054.986514671@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/link-vmlinux.sh |    5 +++++
 1 file changed, 5 insertions(+)

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
 


