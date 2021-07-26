Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A183D61B2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhGZPci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236791AbhGZP3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 183CE60FF3;
        Mon, 26 Jul 2021 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315654;
        bh=VGyoVYkRzIp27UeMvuqYUiTyiwLx8aO8kbggpO6HfO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vm0sqDM8aPZeOqP0CTijW9DVd1CUVKalWJBreT6nQI+vJvseJO4+tZYGbu/m+jguF
         kmvF+kMivyV1C7sDD0UtH8vK4fMr9n+9GbrZF/xX+7P1Xqeg+XVqRVeakmFKz5cdOZ
         H7qvUU8bfyjYnYKJd9vxGmJzVD+Id2WZ4jisul4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Hai <wanghai38@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 014/223] bpf, samples: Fix xdpsock with -M parameter missing unload process
Date:   Mon, 26 Jul 2021 17:36:46 +0200
Message-Id: <20210726153846.727497218@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 2620e92ae6ed83260eb46d214554cd308ee35d92 ]

Execute the following command and exit, then execute it again, the following
error will be reported:

  $ sudo ./samples/bpf/xdpsock -i ens4f2 -M
  ^C
  $ sudo ./samples/bpf/xdpsock -i ens4f2 -M
  libbpf: elf: skipping unrecognized data section(16) .eh_frame
  libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
  libbpf: Kernel error message: XDP program already attached
  ERROR: link set xdp fd failed

Commit c9d27c9e8dc7 ("samples: bpf: Do not unload prog within xdpsock") removed
the unloading prog code because of the presence of bpf_link. This is fine if
XDP_SHARED_UMEM is disabled, but if it is enabled, unloading the prog is still
needed.

Fixes: c9d27c9e8dc7 ("samples: bpf: Do not unload prog within xdpsock")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/bpf/20210628091815.2373487-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdpsock_user.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 53e300f860bb..33d0bdebbed8 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -96,6 +96,7 @@ static int opt_xsk_frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 static int opt_timeout = 1000;
 static bool opt_need_wakeup = true;
 static u32 opt_num_xsks = 1;
+static u32 prog_id;
 static bool opt_busy_poll;
 static bool opt_reduced_cap;
 
@@ -461,6 +462,23 @@ static void *poller(void *arg)
 	return NULL;
 }
 
+static void remove_xdp_program(void)
+{
+	u32 curr_prog_id = 0;
+
+	if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
+		printf("bpf_get_link_xdp_id failed\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (prog_id == curr_prog_id)
+		bpf_set_link_xdp_fd(opt_ifindex, -1, opt_xdp_flags);
+	else if (!curr_prog_id)
+		printf("couldn't find a prog id on a given interface\n");
+	else
+		printf("program on interface changed, not removing\n");
+}
+
 static void int_exit(int sig)
 {
 	benchmark_done = true;
@@ -471,6 +489,9 @@ static void __exit_with_error(int error, const char *file, const char *func,
 {
 	fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
 		line, error, strerror(error));
+
+	if (opt_num_xsks > 1)
+		remove_xdp_program();
 	exit(EXIT_FAILURE);
 }
 
@@ -490,6 +511,9 @@ static void xdpsock_cleanup(void)
 		if (write(sock, &cmd, sizeof(int)) < 0)
 			exit_with_error(errno);
 	}
+
+	if (opt_num_xsks > 1)
+		remove_xdp_program();
 }
 
 static void swap_mac_addresses(void *data)
@@ -857,6 +881,10 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem,
 	if (ret)
 		exit_with_error(-ret);
 
+	ret = bpf_get_link_xdp_id(opt_ifindex, &prog_id, opt_xdp_flags);
+	if (ret)
+		exit_with_error(-ret);
+
 	xsk->app_stats.rx_empty_polls = 0;
 	xsk->app_stats.fill_fail_polls = 0;
 	xsk->app_stats.copy_tx_sendtos = 0;
-- 
2.30.2



