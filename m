Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A047014838B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404976AbgAXLhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388743AbgAXLhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:37:00 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F3D206D4;
        Fri, 24 Jan 2020 11:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865819;
        bh=aQyNDUQ3C6+QBGz+8iD6Fpox3yVMod9VJAD6N27FgzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKuhRvDdaEnY3uyjab8I2fpXUdfVmS7X3vAe6rrddf4QQ5Oi8Szn1GguzfAZliq7W
         nPU17UzSoPZmEP/uD4vek7JKIrpCq/S/WnuUHjW5Xr9oLfgGIo2+rPU2aT3Z8UFhBk
         IfFWHYc4BtEyDC7TZZxJwHe3JuSI75zJWqNhk4vA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 634/639] samples/bpf: Fix broken xdp_rxq_info due to map order assumptions
Date:   Fri, 24 Jan 2020 10:33:24 +0100
Message-Id: <20200124093209.035359872@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit edbca120a8cdfa5a5793707e33497aa5185875ca ]

In the days of using bpf_load.c the order in which the 'maps' sections
were defines in BPF side (*_kern.c) file, were used by userspace side
to identify the map via using the map order as an index. In effect the
order-index is created based on the order the maps sections are stored
in the ELF-object file, by the LLVM compiler.

This have also carried over in libbpf via API bpf_map__next(NULL, obj)
to extract maps in the order libbpf parsed the ELF-object file.

When BTF based maps were introduced a new section type ".maps" were
created. I found that the LLVM compiler doesn't create the ".maps"
sections in the order they are defined in the C-file. The order in the
ELF file is based on the order the map pointer is referenced in the code.

This combination of changes lead to xdp_rxq_info mixing up the map
file-descriptors in userspace, resulting in very broken behaviour, but
without warning the user.

This patch fix issue by instead using bpf_object__find_map_by_name()
to find maps via their names. (Note, this is the ELF name, which can
be longer than the name the kernel retains).

Fixes: be5bca44aa6b ("samples: bpf: convert some XDP samples from bpf_load to libbpf")
Fixes: 451d1dc886b5 ("samples: bpf: update map definition to new syntax BTF-defined map")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/157529025128.29832.5953245340679936909.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_rxq_info_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index ef26f882f92f4..a55c81301c1a9 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -472,9 +472,9 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return EXIT_FAIL;
 
-	map = bpf_map__next(NULL, obj);
-	stats_global_map = bpf_map__next(map, obj);
-	rx_queue_index_map = bpf_map__next(stats_global_map, obj);
+	map =  bpf_object__find_map_by_name(obj, "config_map");
+	stats_global_map = bpf_object__find_map_by_name(obj, "stats_global_map");
+	rx_queue_index_map = bpf_object__find_map_by_name(obj, "rx_queue_index_map");
 	if (!map || !stats_global_map || !rx_queue_index_map) {
 		printf("finding a map in obj file failed\n");
 		return EXIT_FAIL;
-- 
2.20.1



