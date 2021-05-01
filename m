Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5820370586
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhEAEb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:26 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:38613 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhEAEb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843437; x=1651379437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QuFA/QPPO23yYM1DS1S2M8tnxdppiUlVlMJ6Qw+0yQk=;
  b=kfUvx1eqCkNJNwqyed4A7QTz9xV55i9veIwoUNClhvdG5ZzMxg8JlaFg
   2+iuOhDewSgx4zAOd525h+P74YD9jkYc4iptRiLHF6rqxhtLu6zP02wod
   w8M44W5h7u0gVoennhEPd2UYnnCQBf0A0dhzJdaqGqRO7Uc9IhaRBQM1t
   k=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="132286640"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 01 May 2021 04:30:37 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id B75AA1A04A7;
        Sat,  1 May 2021 04:30:36 +0000 (UTC)
Received: from EX13D01UWA003.ant.amazon.com (10.43.160.107) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:17 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13d01UWA003.ant.amazon.com (10.43.160.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:16 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 42A09107; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 13/15] bpf/verifier: disallow pointer subtraction
Date:   Sat, 1 May 2021 04:30:12 +0000
Message-ID: <20210501043014.33300-14-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Upstream commit dd066823db2ac4e22f721ec85190817b58059a54

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
index 8ef1c74eaa11..abf85414c8d1 100644
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
2.23.3

