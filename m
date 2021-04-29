Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BA036F267
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 00:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhD2WJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 18:09:30 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:24150 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhD2WJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 18:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619734122; x=1651270122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K6nHPxr0yf+rOR/71m3Z97bFk2dwojqgiMQCOl2/R+E=;
  b=SnS/mu3zSRnnjv3lXKKh9Wj36pWDZJgjytiHTIIJNcox1TZqa/ZAKXmF
   RAVh1V4i7FFHmc871x0wxbWGDecN5vVeZmgK1eWMwAeIU0M5BiOZDf/8c
   goZAyTKI09BRnC8WAitSlOMbaG+yo3DCTsCwnQYJboXyzHDN/ft/VTGIl
   g=;
X-IronPort-AV: E=Sophos;i="5.82,260,1613433600"; 
   d="scan'208";a="930209834"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 29 Apr 2021 22:08:41 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 46673240B05;
        Thu, 29 Apr 2021 22:08:41 +0000 (UTC)
Received: from EX13D21UEE004.ant.amazon.com (10.43.62.91) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D21UEE004.ant.amazon.com (10.43.62.91) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 22:08:40 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id D3DE1980; Thu, 29 Apr 2021 22:08:39 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>
Subject: [PATCH 5.4 6/8] bpf: Move sanitize_val_alu out of op switch
Date:   Thu, 29 Apr 2021 22:08:37 +0000
Message-ID: <20210429220839.15667-7-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210429220839.15667-1-fllinden@amazon.com>
References: <20210429220839.15667-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit f528819334881fd622fdadeddb3f7edaed8b7c9b upstream.

Add a small sanitize_needed() helper function and move sanitize_val_alu()
out of the main opcode switch. In upcoming work, we'll move sanitize_ptr_alu()
as well out of its opcode switch so this helps to streamline both.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backported to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 kernel/bpf/verifier.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fc33aed59333..b8abdbb4c063 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4352,6 +4352,11 @@ static int sanitize_val_alu(struct bpf_verifier_env *env,
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
@@ -4753,11 +4758,14 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
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
@@ -4777,9 +4785,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
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

