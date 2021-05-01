Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D5A370590
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhEAEb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:57 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:65315 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbhEAEby (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843465; x=1651379465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t6qP31dHq7cwVWiw5AC1ZP43G5sk5RdS6EK1+Ijr4WQ=;
  b=Gua1nozH0uVsigXpOlNbcNJKec9HnBQB5y+o1RLbC5foVHypFfIVXLyo
   v4efYTfHw6j+V8Nbble6wExqVHSXxUcTGA+bu5zKXmR8Ls3PIqedZJ/4B
   yL6/6UJ6/UevA/wmsTvHcCEBCu39NqF+gXLxe3WihqahsMOTxhGzz5/SU
   c=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="109535169"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 01 May 2021 04:31:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id B795CA18CA;
        Sat,  1 May 2021 04:31:02 +0000 (UTC)
Received: from EX13D01UWB004.ant.amazon.com (10.43.161.157) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB004.ant.amazon.com (10.43.161.157) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 4496CBC6; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 01/15] bpf: Fix backport of "bpf: restrict unknown scalars of mixed signed bounds for unprivileged"
Date:   Sat, 1 May 2021 04:30:00 +0000
Message-ID: <20210501043014.33300-2-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
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

