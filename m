Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843E149289
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfFQVVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729283AbfFQVVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:21:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 389D52133F;
        Mon, 17 Jun 2019 21:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806470;
        bh=9TW6nDFtpQbe3fp7IK28uSIKJirN5VvFnYjgLlKLX1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1Jju1cxhzZiL7pGCNjmTvTzPckc8WBaW/ahMKDhQK04JamCKS/cWixrIDKSlD682
         RyZNuMH6AuzEf99m3Yp/pdF8b5gpFl2srnpmFOh3CFi8WIUbdMpewRsPMz2D9cIz+c
         H/1EtVtfVnu9tsOGlirmzsyiqpGyZbWMiyceEsqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 063/115] tools/bpftool: move set_max_rlimit() before __bpf_object__open_xattr()
Date:   Mon, 17 Jun 2019 23:09:23 +0200
Message-Id: <20190617210803.429088914@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ac4e0e055fee5751c78bba1fc9ce508a6874d916 ]

For a host which has a lower rlimit for max locked memory (e.g., 64KB),
the following error occurs in one of our production systems:
  # /usr/sbin/bpftool prog load /paragon/pods/52877437/home/mark.o \
    /sys/fs/bpf/paragon_mark_21 type cgroup/skb \
    map idx 0 pinned /sys/fs/bpf/paragon_map_21
  libbpf: Error in bpf_object__probe_name():Operation not permitted(1).
    Couldn't load basic 'r0 = 0' BPF program.
  Error: failed to open object file

The reason is due to low locked memory during bpf_object__probe_name()
which probes whether program name is supported in kernel or not
during __bpf_object__open_xattr().

bpftool program load already tries to relax mlock rlimit before
bpf_object__load(). Let us move set_max_rlimit() before
__bpf_object__open_xattr(), which fixed the issue here.

Fixes: 47eff61777c7 ("bpf, libbpf: introduce bpf_object__probe_caps to test BPF capabilities")
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index d2be5a06c339..ed8ef5c82256 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -873,6 +873,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 	}
 
+	set_max_rlimit();
+
 	obj = __bpf_object__open_xattr(&attr, bpf_flags);
 	if (IS_ERR_OR_NULL(obj)) {
 		p_err("failed to open object file");
@@ -952,8 +954,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		goto err_close_obj;
 	}
 
-	set_max_rlimit();
-
 	err = bpf_object__load(obj);
 	if (err) {
 		p_err("failed to load object file");
-- 
2.20.1



