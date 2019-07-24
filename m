Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D9E74544
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404473AbfGYFkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404472AbfGYFkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:40:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6707422BEF;
        Thu, 25 Jul 2019 05:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033244;
        bh=Pi54KJDX+OcWbvK6G50o5iySA586M1xu3zaALpLCW2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koFSEeZsj9ThyRjtdEMmY2yjWPtmvCpl13X+6lvHvvIWWmL7gq+/N5BH6UhTQfv7T
         4dwyZcNp+e+iBsePgRjHAUjAQjMPSOBN4yzSJFTLOV9RhFDBGBhBWQIxKpszu8MwzO
         ajT2QnDpLLsUXXYaNetlpyG2shR1HMqsQhIEAQSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/271] selftests: bpf: fix inlines in test_lwt_seg6local
Date:   Wed, 24 Jul 2019 21:20:11 +0200
Message-Id: <20190724191707.367144731@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 11aca65ec4db09527d3e9b6b41a0615b7da4386b ]

Selftests are reporting this failure in test_lwt_seg6local.sh:

+ ip netns exec ns2 ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
Error fetching program/map!
Failed to parse eBPF program: Operation not permitted

The problem is __attribute__((always_inline)) alone is not enough to prevent
clang from inserting those functions in .text. In that case, .text is not
marked as relocateable.

See the output of objdump -h test_lwt_seg6local.o:

Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         00003530  0000000000000000  0000000000000000  00000040  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, CODE

This causes the iproute bpf loader to fail in bpf_fetch_prog_sec:
bpf_has_call_data returns true but bpf_fetch_prog_relo fails as there's no
relocateable .text section in the file.

To fix this, convert to 'static __always_inline'.

v2: Use 'static __always_inline' instead of 'static inline
    __attribute__((always_inline))'

Fixes: c99a84eac026 ("selftests/bpf: test for seg6local End.BPF action")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lwt_seg6local.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_lwt_seg6local.c b/tools/testing/selftests/bpf/test_lwt_seg6local.c
index 0575751bc1bc..e2f6ed0a583d 100644
--- a/tools/testing/selftests/bpf/test_lwt_seg6local.c
+++ b/tools/testing/selftests/bpf/test_lwt_seg6local.c
@@ -61,7 +61,7 @@ struct sr6_tlv_t {
 	unsigned char value[0];
 } BPF_PACKET_HEADER;
 
-__attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff *skb)
+static __always_inline struct ip6_srh_t *get_srh(struct __sk_buff *skb)
 {
 	void *cursor, *data_end;
 	struct ip6_srh_t *srh;
@@ -95,7 +95,7 @@ __attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff *skb)
 	return srh;
 }
 
-__attribute__((always_inline))
+static __always_inline
 int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
 		   uint32_t old_pad, uint32_t pad_off)
 {
@@ -125,7 +125,7 @@ int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
 	return 0;
 }
 
-__attribute__((always_inline))
+static __always_inline
 int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
 			  uint32_t *tlv_off, uint32_t *pad_size,
 			  uint32_t *pad_off)
@@ -184,7 +184,7 @@ int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	return 0;
 }
 
-__attribute__((always_inline))
+static __always_inline
 int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
 	    struct sr6_tlv_t *itlv, uint8_t tlv_size)
 {
@@ -228,7 +228,7 @@ int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
 	return update_tlv_pad(skb, new_pad, pad_size, pad_off);
 }
 
-__attribute__((always_inline))
+static __always_inline
 int delete_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	       uint32_t tlv_off)
 {
@@ -266,7 +266,7 @@ int delete_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	return update_tlv_pad(skb, new_pad, pad_size, pad_off);
 }
 
-__attribute__((always_inline))
+static __always_inline
 int has_egr_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh)
 {
 	int tlv_offset = sizeof(struct ip6_t) + sizeof(struct ip6_srh_t) +
-- 
2.20.1



