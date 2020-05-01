Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D601C160D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbgEANjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731119AbgEANi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:38:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D55E920757;
        Fri,  1 May 2020 13:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340339;
        bh=XpXa5FENFiLrqyQDdoQL5Q7GRlnfAR/wzA1XRDQltGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myDXmWw1tpZkjoNPs4VwsMuXbmsgK626LXL4JjFnC8UyMfqQB3LxefZQDThRvo5Pu
         Cs1CypHTmOeSmPm5DPSODJTtJtU8r73Wnt+jJSUd+w6vkCAt0GP1wnuzzkmlwluTUv
         ovcDQVVQ8JsH842no6aGTtOMA9noQzCufICpr7BI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.4 38/83] cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS is enabled
Date:   Fri,  1 May 2020 15:23:17 +0200
Message-Id: <20200501131535.507056182@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit bc23d0e3f717ced21fbfacab3ab887d55e5ba367 upstream.

When the kernel is built with CONFIG_DEBUG_PER_CPU_MAPS, the cpumap code
can trigger a spurious warning if CONFIG_CPUMASK_OFFSTACK is also set. This
happens because in this configuration, NR_CPUS can be larger than
nr_cpumask_bits, so the initial check in cpu_map_alloc() is not sufficient
to guard against hitting the warning in cpumask_check().

Fix this by explicitly checking the supplied key against the
nr_cpumask_bits variable before calling cpu_possible().

Fixes: 6710e1126934 ("bpf: introduce new bpf cpu map type BPF_MAP_TYPE_CPUMAP")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: Xiumei Mu <xmu@redhat.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20200416083120.453718-1-toke@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/cpumap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -486,7 +486,7 @@ static int cpu_map_update_elem(struct bp
 		return -EOVERFLOW;
 
 	/* Make sure CPU is a valid possible cpu */
-	if (!cpu_possible(key_cpu))
+	if (key_cpu >= nr_cpumask_bits || !cpu_possible(key_cpu))
 		return -ENODEV;
 
 	if (qsize == 0) {


