Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781086D4916
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbjDCOfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbjDCOe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F5216F1E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:34:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D171561E5A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2406C433D2;
        Mon,  3 Apr 2023 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532471;
        bh=QNDokEx/WTQv/8WCRIggFhlLEZhe8iWxxqz+qQ6/Rj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tympOyWtPNawOyfMVEd75DJec70zw0u9ynBRKotsUkGOdmMid1WBBwwad7L1kV1t/
         Io9sdk1Q1VzicV0HSGtMvBB6cUx3djLRhgmBX5lYq/IIJ5oWr9UJCf0GMcYd3k6sRU
         u0caJeJyZOTQH9Pk/Eu1eP11ilI3QS3CZ8fHPQ70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 96/99] selftests/bpf: Add few corner cases to test padding handling of btf_dump
Date:   Mon,  3 Apr 2023 16:09:59 +0200
Message-Id: <20230403140406.934956822@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit b148c8b9b926e257a59c8eb2cd6fa3adfd443254 ]

Add few hand-crafted cases and few randomized cases found using script
from [0] that tests btf_dump's padding logic.

  [0] https://lore.kernel.org/bpf/85f83c333f5355c8ac026f835b18d15060725fcb.camel@ericsson.com/

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221212211505.558851-7-andrii@kernel.org
Stable-dep-of: 4fb877aaa179 ("libbpf: Fix btf_dump's packed struct determination")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/btf_dump_test_case_packing.c    |  61 +++++++++-
 .../bpf/progs/btf_dump_test_case_padding.c    | 104 ++++++++++++++++++
 2 files changed, 164 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
index 1cef3bec1dc7f..3f7755247591c 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
@@ -58,7 +58,64 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-/*------ END-EXPECTED-OUTPUT ------ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct nested_packed_but_aligned_struct {
+ *	int x1;
+ *	int x2;
+ *};
+ *
+ *struct outer_implicitly_packed_struct {
+ *	char y1;
+ *	struct nested_packed_but_aligned_struct y2;
+ *} __attribute__((packed));
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct nested_packed_but_aligned_struct {
+	int x1;
+	int x2;
+} __attribute__((packed));
+
+struct outer_implicitly_packed_struct {
+	char y1;
+	struct nested_packed_but_aligned_struct y2;
+};
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct usb_ss_ep_comp_descriptor {
+ *	char: 8;
+ *	char bDescriptorType;
+ *	char bMaxBurst;
+ *	short wBytesPerInterval;
+ *};
+ *
+ *struct usb_host_endpoint {
+ *	long: 64;
+ *	char: 8;
+ *	struct usb_ss_ep_comp_descriptor ss_ep_comp;
+ *	long: 0;
+ *} __attribute__((packed));
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct usb_ss_ep_comp_descriptor {
+	char: 8;
+	char bDescriptorType;
+	char bMaxBurst;
+	int: 0;
+	short wBytesPerInterval;
+} __attribute__((packed));
+
+struct usb_host_endpoint {
+	long: 64;
+	char: 8;
+	struct usb_ss_ep_comp_descriptor ss_ep_comp;
+	long: 0;
+};
+
 
 int f(struct {
 	struct packed_trailing_space _1;
@@ -69,6 +126,8 @@ int f(struct {
 	union union_is_never_packed _6;
 	union union_does_not_need_packing _7;
 	union jump_code_union _8;
+	struct outer_implicitly_packed_struct _9;
+	struct usb_host_endpoint _10;
 } *_)
 {
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index 28833f2694e9c..0b3cdffbfcf71 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -128,6 +128,98 @@ struct padding_weird_2 {
 	char: 8;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct exact_1byte {
+	char x;
+};
+
+struct padded_1byte {
+	char: 8;
+};
+
+struct exact_2bytes {
+	short x;
+};
+
+struct padded_2bytes {
+	short: 16;
+};
+
+struct exact_4bytes {
+	int x;
+};
+
+struct padded_4bytes {
+	int: 32;
+};
+
+struct exact_8bytes {
+	long x;
+};
+
+struct padded_8bytes {
+	long: 64;
+};
+
+struct ff_periodic_effect {
+	int: 32;
+	short magnitude;
+	long: 0;
+	short phase;
+	long: 0;
+	int: 32;
+	int custom_len;
+	short *custom_data;
+};
+
+struct ib_wc {
+	long: 64;
+	long: 64;
+	int: 32;
+	int byte_len;
+	void *qp;
+	union {} ex;
+	long: 64;
+	int slid;
+	int wc_flags;
+	long: 64;
+	char smac[6];
+	long: 0;
+	char network_hdr_type;
+};
+
+struct acpi_object_method {
+	long: 64;
+	char: 8;
+	char type;
+	short reference_count;
+	char flags;
+	short: 0;
+	char: 8;
+	char sync_level;
+	long: 64;
+	void *node;
+	void *aml_start;
+	union {} dispatch;
+	long: 64;
+	int aml_length;
+};
+
+struct nested_unpacked {
+	int x;
+};
+
+struct nested_packed {
+	struct nested_unpacked a;
+	char c;
+} __attribute__((packed));
+
+struct outer_mixed_but_unpacked {
+	struct nested_packed b1;
+	short a1;
+	struct nested_packed b2;
+};
+
 /* ------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct {
@@ -139,6 +231,18 @@ int f(struct {
 	struct padding_wo_named_members _6;
 	struct padding_weird_1 _7;
 	struct padding_weird_2 _8;
+	struct exact_1byte _100;
+	struct padded_1byte _101;
+	struct exact_2bytes _102;
+	struct padded_2bytes _103;
+	struct exact_4bytes _104;
+	struct padded_4bytes _105;
+	struct exact_8bytes _106;
+	struct padded_8bytes _107;
+	struct ff_periodic_effect _200;
+	struct ib_wc _201;
+	struct acpi_object_method _202;
+	struct outer_mixed_but_unpacked _203;
 } *_)
 {
 	return 0;
-- 
2.39.2



