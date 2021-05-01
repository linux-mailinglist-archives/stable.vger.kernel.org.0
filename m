Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6544E370599
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhEAEcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:32:00 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:65315 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhEAEb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843469; x=1651379469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NuXKIZhE521cIFjdw5PpYHb3Rf6LX7jP4vQWqeJThJc=;
  b=Q1z/tyz/tichpYlI5jYewJf0x42zyQqHwsEiKH39QAcclLsf4HrTlO41
   5ep+KAEpq9t9hKesMRkGFVIfY3yfX0+iCB1Hz1P7+Zlb+0d+HP5WGpl6c
   ljrWM76HPcyTF+y31eXWGs7hFSgMiYjSgWkPQMQVYS02FJ+C92cocoe2G
   o=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="109535180"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 01 May 2021 04:31:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id DE892C010F;
        Sat,  1 May 2021 04:31:06 +0000 (UTC)
Received: from EX13D01UWB002.ant.amazon.com (10.43.161.136) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:23 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13d01UWB002.ant.amazon.com (10.43.161.136) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:22 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 41316DD0; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 09/15] bpf: Move sanitize_val_alu out of op switch
Date:   Sat, 1 May 2021 04:30:08 +0000
Message-ID: <20210501043014.33300-10-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Upstream commit f528819334881fd622fdadeddb3f7edaed8b7c9b

Add a small sanitize_needed() helper function and move sanitize_val_alu()
out of the main opcode switch. In upcoming work, we'll move sanitize_ptr_alu()
as well out of its opcode switch so this helps to streamline both.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backported to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 kernel/bpf/verifier.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 55ac2ab5eabc..db6b08058c19 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2110,6 +2110,11 @@ static int sanitize_val_alu(struct bpf_verifier_env *env,
 	return update_alu_sanitation_state(aux, BPF_ALU_NON_POINTER, 0);
 }
 
+static bool sanitize_needed(u8 opcode)
+{
+	return opcode == BPF_ADD || opcode == BPF_SUB;
+}
+
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
@@ -2510,11 +2515,14 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		return 0;
 	}
 
-	switch (opcode) {
-	case BPF_ADD:
+	if (sanitize_needed(opcode)) {
 		ret = sanitize_val_alu(env, insn);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, NULL, NULL);
+	}
+
+	switch (opcode) {
+	case BPF_ADD:
 		if (signed_add_overflows(dst_reg->smin_value, smin_val) ||
 		    signed_add_overflows(dst_reg->smax_value, smax_val)) {
 			dst_reg->smin_value = S64_MIN;
@@ -2534,9 +2542,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		dst_reg->var_off = tnum_add(dst_reg->var_off, src_reg.var_off);
 		break;
 	case BPF_SUB:
-		ret = sanitize_val_alu(env, insn);
-		if (ret < 0)
-			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_sub_overflows(dst_reg->smin_value, smax_val) ||
 		    signed_sub_overflows(dst_reg->smax_value, smin_val)) {
 			/* Overflow possible, we know nothing */
-- 
2.23.3

