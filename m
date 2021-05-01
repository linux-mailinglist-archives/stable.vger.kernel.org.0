Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8228A370853
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 20:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhEASGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 14:06:00 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:64919 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhEASGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 14:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619892311; x=1651428311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t6qP31dHq7cwVWiw5AC1ZP43G5sk5RdS6EK1+Ijr4WQ=;
  b=PJIt+3gz3AQEvkLnuNy1nOEJz1NFoHvI/QvzBcX6I7ZiEyN8Z7LXlecI
   qaR9P7lC5jnkalGBrXPHH55dzI17DMRRzI21CO8ckba5BBo82lhaMSAK2
   5WAWaUU+ShjNfTlXObgkNteqRFC3Z9/BozK6A9CSxy6bBRFWxWUm0pJxB
   s=;
X-IronPort-AV: E=Sophos;i="5.82,266,1613433600"; 
   d="scan'208";a="123142071"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-28209b7b.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 01 May 2021 18:05:11 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-28209b7b.us-east-1.amazon.com (Postfix) with ESMTPS id 33765EF31D;
        Sat,  1 May 2021 18:05:08 +0000 (UTC)
Received: from EX13D01UWA004.ant.amazon.com (10.43.160.99) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 18:05:08 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13d01UWA004.ant.amazon.com (10.43.160.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 18:05:08 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 18:05:07 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 2793D94F; Sat,  1 May 2021 18:05:06 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <samjonas@amazon.com>
Subject: [PATCH 4.14 1/2] bpf: Fix backport of "bpf: restrict unknown scalars of mixed signed bounds for unprivileged"
Date:   Sat, 1 May 2021 18:05:05 +0000
Message-ID: <20210501180506.19154-2-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501180506.19154-1-fllinden@amazon.com>
References: <20210501180506.19154-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Mendoza-Jonas <samjonas@amazon.com>

The 4.14 backport of 9d7eceede ("bpf: restrict unknown scalars of mixed
signed bounds for unprivileged") adds the PTR_TO_MAP_VALUE check to the
wrong location in adjust_ptr_min_max_vals(), most likely because 4.14
doesn't include the commit that updates the if-statement to a
switch-statement (aad2eeaf4 "bpf: Simplify ptr_min_max_vals adjustment").

Move the check to the proper location in adjust_ptr_min_max_vals().

Fixes: 17efa65350c5a ("bpf: restrict unknown scalars of mixed signed bounds for unprivileged")
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Reviewed-by: Frank van der Linden <fllinden@amazon.com>
Reviewed-by: Ethan Chen <yishache@amazon.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/verifier.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0c3a9302be93..9e9b7c076bcb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2204,6 +2204,13 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 				dst);
 		return -EACCES;
 	}
+	if (ptr_reg->type == PTR_TO_MAP_VALUE) {
+		if (!env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
+			verbose("R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
+				off_reg == dst_reg ? dst : src);
+			return -EACCES;
+		}
+	}
 
 	/* In case of 'scalar += pointer', dst_reg inherits pointer type and id.
 	 * The id may be overwritten later if we create a new variable offset.
@@ -2349,13 +2356,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			verbose("R%d bitwise operator %s on pointer prohibited\n",
 				dst, bpf_alu_string[opcode >> 4]);
 		return -EACCES;
-	case PTR_TO_MAP_VALUE:
-		if (!env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
-			verbose("R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
-				off_reg == dst_reg ? dst : src);
-			return -EACCES;
-		}
-		/* fall-through */
 	default:
 		/* other operators (e.g. MUL,LSH) produce non-pointer results */
 		if (!env->allow_ptr_leaks)
-- 
2.23.3

