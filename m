Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1C52D046E
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgLFLph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:45:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbgLFLpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:45:36 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 38/46] net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled
Date:   Sun,  6 Dec 2020 12:17:46 +0100
Message-Id: <20201206111558.294498543@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 8a78a440108e55ddd845b0ef46df575248667520 ]

Fix build when CONFIG_IPV6 is not enabled by making a function
be built conditionally.

Fixes these build errors and warnings:

../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c: In function 'accel_fs_tcp_set_ipv6_flow':
../include/net/sock.h:380:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
  380 | #define sk_v6_daddr  __sk_common.skc_v6_daddr
      |                                  ^~~~~~~~~~~~
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: note: in expansion of macro 'sk_v6_daddr'
   55 |         &sk->sk_v6_daddr, 16);
      |              ^~~~~~~~~~~
At top level:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:47:13: warning: 'accel_fs_tcp_set_ipv6_flow' defined but not used [-Wunused-function]
   47 | static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)

Fixes: 5229a96e59ec ("net/mlx5e: Accel, Expose flow steering API for rules add/del")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -44,6 +44,7 @@ static void accel_fs_tcp_set_ipv4_flow(s
 			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)
 {
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
@@ -63,6 +64,7 @@ static void accel_fs_tcp_set_ipv6_flow(s
 			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
 	       0xff, 16);
 }
+#endif
 
 void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule)
 {


