Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AB13967DC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhEaS2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:28:01 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:15521 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhEaS1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485560; x=1654021560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Ujhe1o2//t2sL/Bdme2bYabu2VD1SRC6if9ge9pPb4=;
  b=wFT4XMy659rPn3XGWQ8xXC9yRMOy9sRMYvYzaphOvwtaCryw2ipeErOZ
   hQdgmUU6/iSH7s32ishv5KHilH1D4NM3IeGQUkqETp5ltyQwt4kRynHCS
   IAYs+1ogUlFGOQQi5gAaejZ1p7dRlB18et8pDDyyf2/pgK2y75yKp/AZh
   E=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="117089370"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 31 May 2021 18:25:59 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id C5DBBA1B29;
        Mon, 31 May 2021 18:25:58 +0000 (UTC)
Received: from EX13D48UWA003.ant.amazon.com (10.43.163.4) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D48UWA003.ant.amazon.com (10.43.163.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:58
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 907691F4; Mon, 31 May 2021 18:25:57 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 11/17] bpf/verifier: disallow pointer subtraction
Date:   Mon, 31 May 2021 18:25:50 +0000
Message-ID: <20210531182556.25277-12-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210531182556.25277-1-fllinden@amazon.com>
References: <20210531182556.25277-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit dd066823db2ac4e22f721ec85190817b58059a54 upstream.

Subtraction of pointers was accidentally allowed for unpriv programs
by commit 82abbf8d2fc4. Revert that part of commit.

Fixes: 82abbf8d2fc4 ("bpf: do not allow root to mangle valid pointers")
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[fllinden@amazon.com: backport to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b999e268ee23..5c440398e0a1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2754,7 +2754,7 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 				 * an arbitrary scalar. Disallow all math except
 				 * pointer subtraction
 				 */
-				if (opcode == BPF_SUB){
+				if (opcode == BPF_SUB && env->allow_ptr_leaks) {
 					mark_reg_unknown(regs, insn->dst_reg);
 					return 0;
 				}
-- 
2.23.4

