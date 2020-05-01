Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6E31C1699
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbgEANuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729339AbgEANjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C34DB20757;
        Fri,  1 May 2020 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340376;
        bh=JEfPVeCIXS2ihp4wiKoaxqcfVeN9Aopia2uXZyuMbzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2sGXyFNmNM4fTIMGSsCDevmR2WfFS6hjWgxmnaBXqypLef57yjTY5Tcwoov0QTZx
         qV2RZXZ+L4y617cPoImMtvrOMJXCCE71+lWGKSryKkcimmmW/bsiihG5cpKsO4f9Ra
         2dpEe51tAD3b+VWOX/OcvuLhkLN/0vUwEZfOkQho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/83] libbpf: Initialize *nl_pid so gcc 10 is happy
Date:   Fri,  1 May 2020 15:23:32 +0200
Message-Id: <20200501131538.906016002@linuxfoundation.org>
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

From: Jeremy Cline <jcline@redhat.com>

[ Upstream commit 4734b0fefbbf98f8c119eb8344efa19dac82cd2c ]

Builds of Fedora's kernel-tools package started to fail with "may be
used uninitialized" warnings for nl_pid in bpf_set_link_xdp_fd() and
bpf_get_link_xdp_info() on the s390 architecture.

Although libbpf_netlink_open() always returns a negative number when it
does not set *nl_pid, the compiler does not determine this and thus
believes the variable might be used uninitialized. Assuage gcc's fears
by explicitly initializing nl_pid.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1807781

Signed-off-by: Jeremy Cline <jcline@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200404051430.698058-1-jcline@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index ce3ec81b71c01..88416be2bf994 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -137,7 +137,7 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 		struct ifinfomsg ifinfo;
 		char             attrbuf[64];
 	} req;
-	__u32 nl_pid;
+	__u32 nl_pid = 0;
 
 	sock = libbpf_netlink_open(&nl_pid);
 	if (sock < 0)
@@ -254,7 +254,7 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 {
 	struct xdp_id_md xdp_id = {};
 	int sock, ret;
-	__u32 nl_pid;
+	__u32 nl_pid = 0;
 	__u32 mask;
 
 	if (flags & ~XDP_FLAGS_MASK)
-- 
2.20.1



