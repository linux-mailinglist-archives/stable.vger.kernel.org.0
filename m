Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F19F19913E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbgCaJS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbgCaJS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:18:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E6B920787;
        Tue, 31 Mar 2020 09:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646305;
        bh=AWCdgu6dNEmRTTcrueFTFFBMA8I6/uWJz3XKank3eVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoXT5MhmGNcZH6QG8YYKVB0aJhLpJInJIFjGXABng3ShXkhlZNcQ2rCHZD6XnZayG
         85JacuKoCnh+sCVszEuXSDHXcn4KkOBmoy52xMgRCl5YhotNuddCdxCd8KT548P3es
         ZRfcqmBUiPOinqZB9OPmCA5cEnXOiUepj8HLSia0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Roman Gushchin <guro@fb.com>
Subject: [PATCH 5.4 107/155] bpf: Fix cgroup ref leak in cgroup_bpf_inherit on out-of-memory
Date:   Tue, 31 Mar 2020 10:59:07 +0200
Message-Id: <20200331085430.647094972@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 1d8006abaab4cb90f81add86e8d1bf9411add05a upstream.

There is no compensating cgroup_bpf_put() for each ancestor cgroup in
cgroup_bpf_inherit(). If compute_effective_progs returns error, those cgroups
won't be freed ever. Fix it by putting them in cleanup code path.

Fixes: e10360f815ca ("bpf: cgroup: prevent out-of-order release of cgroup bpf")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Link: https://lore.kernel.org/bpf/20200309224017.1063297-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -228,6 +228,9 @@ cleanup:
 	for (i = 0; i < NR; i++)
 		bpf_prog_array_free(arrays[i]);
 
+	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
+		cgroup_bpf_put(p);
+
 	percpu_ref_exit(&cgrp->bpf.refcnt);
 
 	return -ENOMEM;


