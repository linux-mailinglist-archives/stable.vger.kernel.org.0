Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7476AF44C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbjCGTP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjCGTPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EA6CB67A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13AF661520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA8AC433EF;
        Tue,  7 Mar 2023 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215542;
        bh=4LwU/GGSeHNYLLw4xW/1fafHDsydc52Rwh/zbJJN1Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hONIwFgM4NiTgWpCPFBHW0BaFhgLJSjadLklNQoUPcihBt7dn2L7ivyWSJCOJFaDb
         H/R4f/tudQhFk1ppGBHrzDvqqD8TD6mEVXzxu/AymRBKmCgKE6TMh7agQxhy53nbOf
         k67qrAuDdb1CqzQ7ml3fvPgyFT4OK6q5eKo3geMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/567] perf intel-pt: Add support for emulated ptwrite
Date:   Tue,  7 Mar 2023 18:00:00 +0100
Message-Id: <20230307165917.363951922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit d7015e50a9ed180dcc3947635bb2b5711c37f48b ]

ptwrite is an Intel x86 instruction that writes arbitrary values into an
Intel PT trace. It is not supported on all hardware, so provide an
alternative that makes use of TNT packets to convey the payload data.
TNT packets encode Taken/Not-taken conditional branch information, so
taking branches based on the payload value will encode the value into
the TNT packet. Refer to the changes to the documentation file
perf-intel-pt.txt in this patch for an example.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20220509152400.376613-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: aeb802f872a7 ("perf intel-pt: Do not try to queue auxtrace data on pipe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-intel-pt.txt    | 88 +++++++++++++++++
 .../util/intel-pt-decoder/intel-pt-decoder.c  | 99 ++++++++++++++++++-
 .../util/intel-pt-decoder/intel-pt-decoder.h  |  1 +
 .../intel-pt-decoder/intel-pt-insn-decoder.c  |  1 +
 .../intel-pt-decoder/intel-pt-insn-decoder.h  |  1 +
 tools/perf/util/intel-pt.c                    | 37 ++++++-
 6 files changed, 224 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index d44e6a332dfb1..5415c4993c6b4 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -457,6 +457,8 @@ ptw		Enable PTWRITE packets which are produced when a ptwrite instruction
 		which contains "1" if the feature is supported and
 		"0" otherwise.
 
+		As an alternative, refer to "Emulated PTWRITE" further below.
+
 fup_on_ptw	Enable a FUP packet to follow the PTWRITE packet.  The FUP packet
 		provides the address of the ptwrite instruction.  In the absence of
 		fup_on_ptw, the decoder will use the address of the previous branch
@@ -1438,6 +1440,92 @@ In that case the --itrace q option is forced because walking executable code
 to reconstruct the control flow is not possible.
 
 
+Emulated PTWRITE
+----------------
+
+Later perf tools support a method to emulate the ptwrite instruction, which
+can be useful if hardware does not support the ptwrite instruction.
+
+Instead of using the ptwrite instruction, a function is used which produces
+a trace that encodes the payload data into TNT packets.  Here is an example
+of the function:
+
+ #include <stdint.h>
+
+ void perf_emulate_ptwrite(uint64_t x)
+ __attribute__((externally_visible, noipa, no_instrument_function, naked));
+
+ #define PERF_EMULATE_PTWRITE_8_BITS \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"
+
+ /* Undefined instruction */
+ #define PERF_EMULATE_PTWRITE_UD2        ".byte 0x0f, 0x0b\n"
+
+ #define PERF_EMULATE_PTWRITE_MAGIC        PERF_EMULATE_PTWRITE_UD2 ".ascii \"perf,ptwrite  \"\n"
+
+ void perf_emulate_ptwrite(uint64_t x __attribute__ ((__unused__)))
+ {
+          /* Assumes SysV ABI : x passed in rdi */
+         __asm__ volatile (
+                 "jmp 1f\n"
+                 PERF_EMULATE_PTWRITE_MAGIC
+                 "1: mov %rdi, %rax\n"
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 "1: ret\n"
+         );
+ }
+
+For example, a test program with the function above:
+
+ #include <stdio.h>
+ #include <stdint.h>
+ #include <stdlib.h>
+
+ #include "perf_emulate_ptwrite.h"
+
+ int main(int argc, char *argv[])
+ {
+         uint64_t x = 0;
+
+         if (argc > 1)
+                 x = strtoull(argv[1], NULL, 0);
+         perf_emulate_ptwrite(x);
+         return 0;
+ }
+
+Can be compiled and traced:
+
+ $ gcc -Wall -Wextra -O3 -g -o eg_ptw eg_ptw.c
+ $ perf record -e intel_pt//u ./eg_ptw 0x1234567890abcdef
+ [ perf record: Woken up 1 times to write data ]
+ [ perf record: Captured and wrote 0.017 MB perf.data ]
+ $ perf script --itrace=ew
+           eg_ptw 19875 [007]  8061.235912:     ptwrite:  IP: 0 payload: 0x1234567890abcdef      55701249a196 perf_emulate_ptwrite+0x16 (/home/user/eg_ptw)
+ $
+
+
 EXAMPLE
 -------
 
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index b0034ee4bba50..a7daec6cdc7b2 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -137,6 +137,7 @@ struct intel_pt_decoder {
 	bool in_psb;
 	bool hop;
 	bool leap;
+	bool emulated_ptwrite;
 	bool vm_time_correlation;
 	bool vm_tm_corr_dry_run;
 	bool vm_tm_corr_reliable;
@@ -473,6 +474,8 @@ static int intel_pt_ext_err(int code)
 		return INTEL_PT_ERR_LOST;
 	case -ELOOP:
 		return INTEL_PT_ERR_NELOOP;
+	case -ECONNRESET:
+		return INTEL_PT_ERR_EPTW;
 	default:
 		return INTEL_PT_ERR_UNK;
 	}
@@ -489,6 +492,7 @@ static const char *intel_pt_err_msgs[] = {
 	[INTEL_PT_ERR_LOST]   = "Lost trace data",
 	[INTEL_PT_ERR_UNK]    = "Unknown error!",
 	[INTEL_PT_ERR_NELOOP] = "Never-ending loop (refer perf config intel-pt.max-loops)",
+	[INTEL_PT_ERR_EPTW]   = "Broken emulated ptwrite",
 };
 
 int intel_pt__strerror(int code, char *buf, size_t buflen)
@@ -1402,17 +1406,108 @@ static int intel_pt_walk_tip(struct intel_pt_decoder *decoder)
 	return intel_pt_bug(decoder);
 }
 
+struct eptw_data {
+	int bit_countdown;
+	uint64_t payload;
+};
+
+static int intel_pt_eptw_lookahead_cb(struct intel_pt_pkt_info *pkt_info)
+{
+	struct eptw_data *data = pkt_info->data;
+	int nr_bits;
+
+	switch (pkt_info->packet.type) {
+	case INTEL_PT_PAD:
+	case INTEL_PT_MNT:
+	case INTEL_PT_MODE_EXEC:
+	case INTEL_PT_MODE_TSX:
+	case INTEL_PT_MTC:
+	case INTEL_PT_FUP:
+	case INTEL_PT_CYC:
+	case INTEL_PT_CBR:
+	case INTEL_PT_TSC:
+	case INTEL_PT_TMA:
+	case INTEL_PT_PIP:
+	case INTEL_PT_VMCS:
+	case INTEL_PT_PSB:
+	case INTEL_PT_PSBEND:
+	case INTEL_PT_PTWRITE:
+	case INTEL_PT_PTWRITE_IP:
+	case INTEL_PT_EXSTOP:
+	case INTEL_PT_EXSTOP_IP:
+	case INTEL_PT_MWAIT:
+	case INTEL_PT_PWRE:
+	case INTEL_PT_PWRX:
+	case INTEL_PT_BBP:
+	case INTEL_PT_BIP:
+	case INTEL_PT_BEP:
+	case INTEL_PT_BEP_IP:
+	case INTEL_PT_CFE:
+	case INTEL_PT_CFE_IP:
+	case INTEL_PT_EVD:
+		break;
+
+	case INTEL_PT_TNT:
+		nr_bits = data->bit_countdown;
+		if (nr_bits > pkt_info->packet.count)
+			nr_bits = pkt_info->packet.count;
+		data->payload <<= nr_bits;
+		data->payload |= pkt_info->packet.payload >> (64 - nr_bits);
+		data->bit_countdown -= nr_bits;
+		return !data->bit_countdown;
+
+	case INTEL_PT_TIP_PGE:
+	case INTEL_PT_TIP_PGD:
+	case INTEL_PT_TIP:
+	case INTEL_PT_BAD:
+	case INTEL_PT_OVF:
+	case INTEL_PT_TRACESTOP:
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+static int intel_pt_emulated_ptwrite(struct intel_pt_decoder *decoder)
+{
+	int n = 64 - decoder->tnt.count;
+	struct eptw_data data = {
+		.bit_countdown = n,
+		.payload = decoder->tnt.payload >> n,
+	};
+
+	decoder->emulated_ptwrite = false;
+	intel_pt_log("Emulated ptwrite detected\n");
+
+	intel_pt_pkt_lookahead(decoder, intel_pt_eptw_lookahead_cb, &data);
+	if (data.bit_countdown)
+		return -ECONNRESET;
+
+	decoder->state.type = INTEL_PT_PTW;
+	decoder->state.from_ip = decoder->ip;
+	decoder->state.to_ip = 0;
+	decoder->state.ptw_payload = data.payload;
+	return 0;
+}
+
 static int intel_pt_walk_tnt(struct intel_pt_decoder *decoder)
 {
 	struct intel_pt_insn intel_pt_insn;
 	int err;
 
 	while (1) {
+		if (decoder->emulated_ptwrite)
+			return intel_pt_emulated_ptwrite(decoder);
 		err = intel_pt_walk_insn(decoder, &intel_pt_insn, 0);
-		if (err == INTEL_PT_RETURN)
+		if (err == INTEL_PT_RETURN) {
+			decoder->emulated_ptwrite = intel_pt_insn.emulated_ptwrite;
 			return 0;
-		if (err)
+		}
+		if (err) {
+			decoder->emulated_ptwrite = false;
 			return err;
+		}
 
 		if (intel_pt_insn.op == INTEL_PT_OP_RET) {
 			if (!decoder->return_compression) {
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
index 4b5e79fcf557f..0a641aba3c7cb 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
@@ -55,6 +55,7 @@ enum {
 	INTEL_PT_ERR_LOST,
 	INTEL_PT_ERR_UNK,
 	INTEL_PT_ERR_NELOOP,
+	INTEL_PT_ERR_EPTW,
 	INTEL_PT_ERR_MAX,
 };
 
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
index 593f20e9774c0..9f29cf7210773 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
@@ -32,6 +32,7 @@ static void intel_pt_insn_decoder(struct insn *insn,
 	int ext;
 
 	intel_pt_insn->rel = 0;
+	intel_pt_insn->emulated_ptwrite = false;
 
 	if (insn_is_avx(insn)) {
 		intel_pt_insn->op = INTEL_PT_OP_OTHER;
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
index c2861cfdd768d..e3338b56a75f2 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
@@ -37,6 +37,7 @@ enum intel_pt_insn_branch {
 struct intel_pt_insn {
 	enum intel_pt_insn_op		op;
 	enum intel_pt_insn_branch	branch;
+	bool				emulated_ptwrite;
 	int				length;
 	int32_t				rel;
 	unsigned char			buf[INTEL_PT_INSN_BUF_SZ];
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 6324195467056..89863efedc82c 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -506,6 +506,7 @@ struct intel_pt_cache_entry {
 	u64				byte_cnt;
 	enum intel_pt_insn_op		op;
 	enum intel_pt_insn_branch	branch;
+	bool				emulated_ptwrite;
 	int				length;
 	int32_t				rel;
 	char				insn[INTEL_PT_INSN_BUF_SZ];
@@ -592,6 +593,7 @@ static int intel_pt_cache_add(struct dso *dso, struct machine *machine,
 	e->byte_cnt = byte_cnt;
 	e->op = intel_pt_insn->op;
 	e->branch = intel_pt_insn->branch;
+	e->emulated_ptwrite = intel_pt_insn->emulated_ptwrite;
 	e->length = intel_pt_insn->length;
 	e->rel = intel_pt_insn->rel;
 	memcpy(e->insn, intel_pt_insn->buf, INTEL_PT_INSN_BUF_SZ);
@@ -678,6 +680,28 @@ static int intel_pt_get_guest(struct intel_pt_queue *ptq)
 	return 0;
 }
 
+static inline bool intel_pt_jmp_16(struct intel_pt_insn *intel_pt_insn)
+{
+	return intel_pt_insn->rel == 16 && intel_pt_insn->branch == INTEL_PT_BR_UNCONDITIONAL;
+}
+
+#define PTWRITE_MAGIC		"\x0f\x0bperf,ptwrite  "
+#define PTWRITE_MAGIC_LEN	16
+
+static bool intel_pt_emulated_ptwrite(struct dso *dso, struct machine *machine, u64 offset)
+{
+	unsigned char buf[PTWRITE_MAGIC_LEN];
+	ssize_t len;
+
+	len = dso__data_read_offset(dso, machine, offset, buf, PTWRITE_MAGIC_LEN);
+	if (len == PTWRITE_MAGIC_LEN && !memcmp(buf, PTWRITE_MAGIC, PTWRITE_MAGIC_LEN)) {
+		intel_pt_log("Emulated ptwrite signature found\n");
+		return true;
+	}
+	intel_pt_log("Emulated ptwrite signature not found\n");
+	return false;
+}
+
 static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 				   uint64_t *insn_cnt_ptr, uint64_t *ip,
 				   uint64_t to_ip, uint64_t max_insn_cnt,
@@ -740,6 +764,7 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 				*ip += e->byte_cnt;
 				intel_pt_insn->op = e->op;
 				intel_pt_insn->branch = e->branch;
+				intel_pt_insn->emulated_ptwrite = e->emulated_ptwrite;
 				intel_pt_insn->length = e->length;
 				intel_pt_insn->rel = e->rel;
 				memcpy(intel_pt_insn->buf, e->insn,
@@ -771,8 +796,18 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 
 			insn_cnt += 1;
 
-			if (intel_pt_insn->branch != INTEL_PT_BR_NO_BRANCH)
+			if (intel_pt_insn->branch != INTEL_PT_BR_NO_BRANCH) {
+				bool eptw;
+				u64 offs;
+
+				if (!intel_pt_jmp_16(intel_pt_insn))
+					goto out;
+				/* Check for emulated ptwrite */
+				offs = offset + intel_pt_insn->length;
+				eptw = intel_pt_emulated_ptwrite(al.map->dso, machine, offs);
+				intel_pt_insn->emulated_ptwrite = eptw;
 				goto out;
+			}
 
 			if (max_insn_cnt && insn_cnt >= max_insn_cnt)
 				goto out_no_cache;
-- 
2.39.2



