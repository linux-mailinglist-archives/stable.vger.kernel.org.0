Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE7045C52D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352303AbhKXNzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354431AbhKXNur (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3988E610A2;
        Wed, 24 Nov 2021 13:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759021;
        bh=JV9t9wa9X2hNfq9CZr2MZNyyaDBGI9nOFSSrub9/6P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbnVflIf9FYK/XsTrXlvlWshRD//luCi7UxUIfqqKHkZ9KgibwOLrGpXkMLM5BarF
         0ITbZOXk16+KL5EmOLvHRTmQiVtlFaTjccnforjD39eYBlQqx6e912a4j58OLyDdUu
         qGSPLjyJ1kdqbDyvf9fdNqCd4QC/5doHqErDCpk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/279] samples/bpf: Fix incorrect use of strlen in xdp_redirect_cpu
Date:   Wed, 24 Nov 2021 12:56:34 +0100
Message-Id: <20211124115722.471257128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 2453afe3845523d9dfe89dbfb3d71abfa095e260 ]

Commit b599015f044d ("samples/bpf: Fix application of sizeof to pointer")
tried to fix a bug where sizeof was incorrectly applied to a pointer instead
of the array string was being copied to, to find the destination buffer size,
but ended up using strlen, which is still incorrect. However, on closer look
ifname_buf has no other use, hence directly use optarg.

Fixes: b599015f044d ("samples/bpf: Fix application of sizeof to pointer")
Fixes: e531a220cc59 ("samples: bpf: Convert xdp_redirect_cpu to XDP samples helper")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/bpf/20211112020301.528357-1-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_redirect_cpu_user.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index d84e6949007cc..a81704d3317ba 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -309,7 +309,6 @@ int main(int argc, char **argv)
 	const char *mprog_filename = NULL, *mprog_name = NULL;
 	struct xdp_redirect_cpu *skel;
 	struct bpf_map_info info = {};
-	char ifname_buf[IF_NAMESIZE];
 	struct bpf_cpumap_val value;
 	__u32 infosz = sizeof(info);
 	int ret = EXIT_FAIL_OPTION;
@@ -390,10 +389,10 @@ int main(int argc, char **argv)
 		case 'd':
 			if (strlen(optarg) >= IF_NAMESIZE) {
 				fprintf(stderr, "-d/--dev name too long\n");
+				usage(argv, long_options, __doc__, mask, true, skel->obj);
 				goto end_cpu;
 			}
-			safe_strncpy(ifname_buf, optarg, strlen(ifname_buf));
-			ifindex = if_nametoindex(ifname_buf);
+			ifindex = if_nametoindex(optarg);
 			if (!ifindex)
 				ifindex = strtoul(optarg, NULL, 0);
 			if (!ifindex) {
-- 
2.33.0



