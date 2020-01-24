Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CB3147A79
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgAXJdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730715AbgAXJdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:33:54 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E07A2077C;
        Fri, 24 Jan 2020 09:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858433;
        bh=vbzmyzYcAV7aS/qk3wdRn0yPSZAZJ+k4SYii2WzMliA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV9PiYQu2U1JLTcS6JMuAZELg5zM9mLblrlk6rezqrYQ19QRrhNXgpqTjWvQ5t0VU
         yl+HiEGDINu4GgP4xHowUqTOwvHSz2KU0rM4hwe4z34tBPf3VZb/RhVt83uJjrBEhS
         4ZMjfVPZc0ZfQmyxmcr9bUghRdQZN5YJY/P7Mlbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 009/102] samples: bpf: update map definition to new syntax BTF-defined map
Date:   Fri, 24 Jan 2020 10:30:10 +0100
Message-Id: <20200124092807.503070263@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel T. Lee <danieltimlee@gmail.com>

commit 451d1dc886b548d6e18c933adca326c1307023c9 upstream.

Since, the new syntax of BTF-defined map has been introduced,
the syntax for using maps under samples directory are mixed up.
For example, some are already using the new syntax, and some are using
existing syntax by calling them as 'legacy'.

As stated at commit abd29c931459 ("libbpf: allow specifying map
definitions using BTF"), the BTF-defined map has more compatablility
with extending supported map definition features.

The commit doesn't replace all of the map to new BTF-defined map,
because some of the samples still use bpf_load instead of libbpf, which
can't properly create BTF-defined map.

This will only updates the samples which uses libbpf API for loading bpf
program. (ex. bpf_prog_load_xattr)

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 samples/bpf/sockex1_kern.c          |   12 ++--
 samples/bpf/sockex2_kern.c          |   12 ++--
 samples/bpf/xdp1_kern.c             |   12 ++--
 samples/bpf/xdp2_kern.c             |   12 ++--
 samples/bpf/xdp_adjust_tail_kern.c  |   12 ++--
 samples/bpf/xdp_fwd_kern.c          |   13 ++--
 samples/bpf/xdp_redirect_cpu_kern.c |  108 ++++++++++++++++++------------------
 samples/bpf/xdp_redirect_kern.c     |   24 ++++----
 samples/bpf/xdp_redirect_map_kern.c |   24 ++++----
 samples/bpf/xdp_router_ipv4_kern.c  |   64 ++++++++++-----------
 samples/bpf/xdp_rxq_info_kern.c     |   37 ++++++------
 samples/bpf/xdp_tx_iptunnel_kern.c  |   24 ++++----
 12 files changed, 177 insertions(+), 177 deletions(-)

--- a/samples/bpf/sockex1_kern.c
+++ b/samples/bpf/sockex1_kern.c
@@ -4,12 +4,12 @@
 #include <uapi/linux/ip.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = 256,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 256);
+} my_map SEC(".maps");
 
 SEC("socket1")
 int bpf_prog1(struct __sk_buff *skb)
--- a/samples/bpf/sockex2_kern.c
+++ b/samples/bpf/sockex2_kern.c
@@ -189,12 +189,12 @@ struct pair {
 	long bytes;
 };
 
-struct bpf_map_def SEC("maps") hash_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(__be32),
-	.value_size = sizeof(struct pair),
-	.max_entries = 1024,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __be32);
+	__type(value, struct pair);
+	__uint(max_entries, 1024);
+} hash_map SEC(".maps");
 
 SEC("socket2")
 int bpf_prog2(struct __sk_buff *skb)
--- a/samples/bpf/xdp1_kern.c
+++ b/samples/bpf/xdp1_kern.c
@@ -14,12 +14,12 @@
 #include <linux/ipv6.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") rxcnt = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = 256,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 256);
+} rxcnt SEC(".maps");
 
 static int parse_ipv4(void *data, u64 nh_off, void *data_end)
 {
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -14,12 +14,12 @@
 #include <linux/ipv6.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") rxcnt = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = 256,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 256);
+} rxcnt SEC(".maps");
 
 static void swap_src_dst_mac(void *data)
 {
--- a/samples/bpf/xdp_adjust_tail_kern.c
+++ b/samples/bpf/xdp_adjust_tail_kern.c
@@ -25,12 +25,12 @@
 #define ICMP_TOOBIG_SIZE 98
 #define ICMP_TOOBIG_PAYLOAD_SIZE 92
 
-struct bpf_map_def SEC("maps") icmpcnt = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, __u32);
+	__type(value, __u64);
+	__uint(max_entries, 1);
+} icmpcnt SEC(".maps");
 
 static __always_inline void count_icmp(void)
 {
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -23,13 +23,12 @@
 
 #define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
 
-/* For TX-traffic redirect requires net_device ifindex to be in this devmap */
-struct bpf_map_def SEC("maps") xdp_tx_ports = {
-	.type = BPF_MAP_TYPE_DEVMAP,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
-	.max_entries = 64,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 64);
+} xdp_tx_ports SEC(".maps");
 
 /* from include/net/ip.h */
 static __always_inline int ip_decrease_ttl(struct iphdr *iph)
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu_kern.c
@@ -18,12 +18,12 @@
 #define MAX_CPUS 64 /* WARNING - sync with _user.c */
 
 /* Special map type that can XDP_REDIRECT frames to another CPU */
-struct bpf_map_def SEC("maps") cpu_map = {
-	.type		= BPF_MAP_TYPE_CPUMAP,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(u32),
-	.max_entries	= MAX_CPUS,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_CPUMAP);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u32));
+	__uint(max_entries, MAX_CPUS);
+} cpu_map SEC(".maps");
 
 /* Common stats data record to keep userspace more simple */
 struct datarec {
@@ -35,67 +35,67 @@ struct datarec {
 /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
  * feedback.  Redirect TX errors can be caught via a tracepoint.
  */
-struct bpf_map_def SEC("maps") rx_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} rx_cnt SEC(".maps");
 
 /* Used by trace point */
-struct bpf_map_def SEC("maps") redirect_err_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= 2,
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 2);
 	/* TODO: have entries for all possible errno's */
-};
+} redirect_err_cnt SEC(".maps");
 
 /* Used by trace point */
-struct bpf_map_def SEC("maps") cpumap_enqueue_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= MAX_CPUS,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, MAX_CPUS);
+} cpumap_enqueue_cnt SEC(".maps");
 
 /* Used by trace point */
-struct bpf_map_def SEC("maps") cpumap_kthread_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} cpumap_kthread_cnt SEC(".maps");
 
 /* Set of maps controlling available CPU, and for iterating through
  * selectable redirect CPUs.
  */
-struct bpf_map_def SEC("maps") cpus_available = {
-	.type		= BPF_MAP_TYPE_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(u32),
-	.max_entries	= MAX_CPUS,
-};
-struct bpf_map_def SEC("maps") cpus_count = {
-	.type		= BPF_MAP_TYPE_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(u32),
-	.max_entries	= 1,
-};
-struct bpf_map_def SEC("maps") cpus_iterator = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(u32),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(max_entries, MAX_CPUS);
+} cpus_available SEC(".maps");
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(max_entries, 1);
+} cpus_count SEC(".maps");
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(max_entries, 1);
+} cpus_iterator SEC(".maps");
 
 /* Used by trace point */
-struct bpf_map_def SEC("maps") exception_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} exception_cnt SEC(".maps");
 
 /* Helper parse functions */
 
--- a/samples/bpf/xdp_redirect_kern.c
+++ b/samples/bpf/xdp_redirect_kern.c
@@ -19,22 +19,22 @@
 #include <linux/ipv6.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") tx_port = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, int);
+	__uint(max_entries, 1);
+} tx_port SEC(".maps");
 
 /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
  * feedback.  Redirect TX errors can be caught via a tracepoint.
  */
-struct bpf_map_def SEC("maps") rxcnt = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 1);
+} rxcnt SEC(".maps");
 
 static void swap_src_dst_mac(void *data)
 {
--- a/samples/bpf/xdp_redirect_map_kern.c
+++ b/samples/bpf/xdp_redirect_map_kern.c
@@ -19,22 +19,22 @@
 #include <linux/ipv6.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") tx_port = {
-	.type = BPF_MAP_TYPE_DEVMAP,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
-	.max_entries = 100,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 100);
+} tx_port SEC(".maps");
 
 /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
  * feedback.  Redirect TX errors can be caught via a tracepoint.
  */
-struct bpf_map_def SEC("maps") rxcnt = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 1);
+} rxcnt SEC(".maps");
 
 static void swap_src_dst_mac(void *data)
 {
--- a/samples/bpf/xdp_router_ipv4_kern.c
+++ b/samples/bpf/xdp_router_ipv4_kern.c
@@ -42,44 +42,44 @@ struct direct_map {
 };
 
 /* Map for trie implementation*/
-struct bpf_map_def SEC("maps") lpm_map = {
-	.type = BPF_MAP_TYPE_LPM_TRIE,
-	.key_size = 8,
-	.value_size = sizeof(struct trie_value),
-	.max_entries = 50,
-	.map_flags = BPF_F_NO_PREALLOC,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_LPM_TRIE);
+	__uint(key_size, 8);
+	__uint(value_size, sizeof(struct trie_value));
+	__uint(max_entries, 50);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+} lpm_map SEC(".maps");
 
 /* Map for counter*/
-struct bpf_map_def SEC("maps") rxcnt = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u64),
-	.max_entries = 256,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, 256);
+} rxcnt SEC(".maps");
 
 /* Map for ARP table*/
-struct bpf_map_def SEC("maps") arp_table = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(__be32),
-	.value_size = sizeof(__be64),
-	.max_entries = 50,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __be32);
+	__type(value, __be64);
+	__uint(max_entries, 50);
+} arp_table SEC(".maps");
 
 /* Map to keep the exact match entries in the route table*/
-struct bpf_map_def SEC("maps") exact_match = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(__be32),
-	.value_size = sizeof(struct direct_map),
-	.max_entries = 50,
-};
-
-struct bpf_map_def SEC("maps") tx_port = {
-	.type = BPF_MAP_TYPE_DEVMAP,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
-	.max_entries = 100,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __be32);
+	__type(value, struct direct_map);
+	__uint(max_entries, 50);
+} exact_match SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 100);
+} tx_port SEC(".maps");
 
 /* Function to set source and destination mac of the packet */
 static inline void set_src_dst_mac(void *data, void *src, void *dst)
--- a/samples/bpf/xdp_rxq_info_kern.c
+++ b/samples/bpf/xdp_rxq_info_kern.c
@@ -23,12 +23,13 @@ enum cfg_options_flags {
 	READ_MEM = 0x1U,
 	SWAP_MAC = 0x2U,
 };
-struct bpf_map_def SEC("maps") config_map = {
-	.type		= BPF_MAP_TYPE_ARRAY,
-	.key_size	= sizeof(int),
-	.value_size	= sizeof(struct config),
-	.max_entries	= 1,
-};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, struct config);
+	__uint(max_entries, 1);
+} config_map SEC(".maps");
 
 /* Common stats data record (shared with userspace) */
 struct datarec {
@@ -36,22 +37,22 @@ struct datarec {
 	__u64 issue;
 };
 
-struct bpf_map_def SEC("maps") stats_global_map = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} stats_global_map SEC(".maps");
 
 #define MAX_RXQs 64
 
 /* Stats per rx_queue_index (per CPU) */
-struct bpf_map_def SEC("maps") rx_queue_index_map = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= MAX_RXQs + 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, MAX_RXQs + 1);
+} rx_queue_index_map SEC(".maps");
 
 static __always_inline
 void swap_src_dst_mac(void *data)
--- a/samples/bpf/xdp_tx_iptunnel_kern.c
+++ b/samples/bpf/xdp_tx_iptunnel_kern.c
@@ -19,19 +19,19 @@
 #include "bpf_helpers.h"
 #include "xdp_tx_iptunnel_common.h"
 
-struct bpf_map_def SEC("maps") rxcnt = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
-	.max_entries = 256,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, __u32);
+	__type(value, __u64);
+	__uint(max_entries, 256);
+} rxcnt SEC(".maps");
 
-struct bpf_map_def SEC("maps") vip2tnl = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct vip),
-	.value_size = sizeof(struct iptnl_info),
-	.max_entries = MAX_IPTNL_ENTRIES,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct vip);
+	__type(value, struct iptnl_info);
+	__uint(max_entries, MAX_IPTNL_ENTRIES);
+} vip2tnl SEC(".maps");
 
 static __always_inline void count_tx(u32 protocol)
 {


