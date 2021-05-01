Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAC7370854
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 20:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhEASGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 14:06:01 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:29908 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhEASGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 14:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619892311; x=1651428311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mlEVsC/MgixL1++qUxUO5VczIeZsu1kDac0ReqIV0Ek=;
  b=A0j0Gxksa1kcz01TijNO9vFsdrFIZ4EVwEwZIhYl0QzG96P3EBJuOCSQ
   GRtwS8sAw5CF47omMU3UH5eNKyn3Jvca5lg8LMmbWBjmPAJwN2HgflSUK
   2ko1ycKmXyAKquFbUd87VPozmQDzD4CRRXdOlKOdGVKUhm/+t5NspN9FH
   0=;
X-IronPort-AV: E=Sophos;i="5.82,266,1613433600"; 
   d="scan'208";a="105149223"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 01 May 2021 18:05:10 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 6489BA1C89;
        Sat,  1 May 2021 18:05:09 +0000 (UTC)
Received: from EX13D01UWA003.ant.amazon.com (10.43.160.107) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 18:05:08 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13d01UWA003.ant.amazon.com (10.43.160.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 18:05:08 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 18:05:07 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 27144A6; Sat,  1 May 2021 18:05:06 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <samjonas@amazon.com>
Subject: [PATCH 4.14 2/2] bpf: fix up selftests after backports were fixed
Date:   Sat, 1 May 2021 18:05:06 +0000
Message-ID: <20210501180506.19154-3-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501180506.19154-1-fllinden@amazon.com>
References: <20210501180506.19154-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After the backport of the changes to fix CVE 2019-7308, the
selftests also need to be fixed up, as was done originally
in mainline 80c9b2fae87b ("bpf: add various test cases to selftests").

4.14 commit 03f11a51a19 ("bpf: Fix selftests are changes for CVE 2019-7308")
did that, but since there was an error in the backport, some
selftests did not change output. So, add them now that this error
has been fixed, and their output has actually changed as expected.

This adds the rest of the changed test outputs from 80c9b2fae87b.

Fixes: 03f11a51a19 ("bpf: Fix selftests are changes for CVE 2019-7308")
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 9babb3fef8e2..9f7fc30d247d 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -6207,6 +6207,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6231,6 +6232,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6257,6 +6259,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6282,6 +6285,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6330,6 +6334,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6401,6 +6406,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6452,6 +6458,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6479,6 +6486,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6505,6 +6513,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6534,6 +6543,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6592,6 +6602,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 		.result_unpriv = REJECT,
 	},
@@ -6644,6 +6655,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "R0 min value is negative, either use unsigned index or do a if (index >=0) check.",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
-- 
2.23.3

