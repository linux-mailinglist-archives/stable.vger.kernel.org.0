Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA73967CF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhEaS1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:27:48 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:12136 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbhEaS1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485560; x=1654021560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gnkO6HbxtWgpLLubZF5txt5lfMb6qkJdo86vYzWv6r8=;
  b=OVy280LXJ4R1AkYRIoaRy8tk3N6d1TORyGMu/v/BjvOu0OISRohvxoK3
   ZRHtNMco4qIqguSdmw+pI8yqAmxPMohCqEza3OHfAi0u+f+iOYyzEwPsJ
   qFQvQVgY3c+PDzVvTJgtUvWJuGRdRh7PPuKQFsSq4OPlJoEu5ggAuXApR
   4=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="115653031"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 31 May 2021 18:25:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 07DD1A18E6;
        Mon, 31 May 2021 18:25:57 +0000 (UTC)
Received: from EX13D07UWB004.ant.amazon.com (10.43.161.196) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D07UWB004.ant.amazon.com (10.43.161.196) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:57 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:57
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 899D079; Mon, 31 May 2021 18:25:57 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 17/17] bpf: No need to simulate speculative domain for immediates
Date:   Mon, 31 May 2021 18:25:56 +0000
Message-ID: <20210531182556.25277-18-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210531182556.25277-1-fllinden@amazon.com>
References: <20210531182556.25277-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit a7036191277f9fa68d92f2071ddc38c09b1e5ee5 upstream.

In 801c6058d14a ("bpf: Fix leakage of uninitialized bpf stack under
speculation") we replaced masking logic with direct loads of immediates
if the register is a known constant. Given in this case we do not apply
any masking, there is also no reason for the operation to be truncated
under the speculative domain.

Therefore, there is also zero reason for the verifier to branch-off and
simulate this case, it only needs to do it for unknown but bounded scalars.
As a side-effect, this also enables few test cases that were previously
rejected due to simulation under zero truncation.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f3f14519708d..4a3333039bf2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2169,8 +2169,12 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	/* If we're in commit phase, we're done here given we already
 	 * pushed the truncated dst_reg into the speculative verification
 	 * stack.
+	 *
+	 * Also, when register is a known constant, we rewrite register-based
+	 * operation to immediate-based, and thus do not need masking (and as
+	 * a consequence, do not need to simulate the zero-truncation either).
 	 */
-	if (commit_window)
+	if (commit_window || off_is_imm)
 		return 0;
 
 	/* Simulate and find potential out-of-bounds access under
-- 
2.23.4

