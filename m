Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ED93C51FA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349624AbhGLHoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349500AbhGLHmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EA4A6112D;
        Mon, 12 Jul 2021 07:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075560;
        bh=/cFXXgNJwnh0heA08mwM0Etc/e7GsfXEwFPCw/mcvlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCfT+YQRHy6+CP1RjnS6x0P4+WZHIFygw+YWKWG0yYx4XhZcks0/9eAHq8OejjgMN
         NKXLiOgWZdQZ0MG2uQUipb9X+nr5sty3i6Q6HAls3DgG/VW7nlkWGQUPK0GD1jfRZL
         TIVl8lwS00WsEpKgvNZNWeKEqKsXQ4b0U3FRLjXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hao Luo <haoluo@google.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 266/800] kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21
Date:   Mon, 12 Jul 2021 08:04:49 +0200
Message-Id: <20210712060952.148978306@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit a0b8200d06ad6450c179407baa5f0f52f8cfcc97 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 0e0f6466b18d..475faa15854e 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -235,6 +235,10 @@ gen_btf()
 
 	vmlinux_link ${1}
 
+	if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
+		# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
+		extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
+	fi
 	if [ "${pahole_ver}" -ge "121" ]; then
 		extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
 	fi
-- 
2.30.2



