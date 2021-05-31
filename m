Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613AE395C59
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhEaNb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232508AbhEaN30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1144613F2;
        Mon, 31 May 2021 13:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467369;
        bh=HBePkx2nmGVMGHgp7uzAfKPhGKbJLlS0tQOjlIGcr0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTX26Of94LLHDc9EOs2RmrnqcQcH9LaG2DLyN7QjOpW4b06Ulg4nmcNNaBScQfOyu
         4b053U47TgVYLkttY9bBH3zwvjzMbajcJBFrmKNJlJF1LCXmZjxL6K12NxsrkeTO6V
         nGBy27JuXpy6NHRjbhoYf9a3Jy+V1BhAbl95nYS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank van der Linden <fllinden@amazon.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 040/116] bpf: fix up selftests after backports were fixed
Date:   Mon, 31 May 2021 15:13:36 +0200
Message-Id: <20210531130641.522171175@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ovidiu Panait <ovidiu.panait@windriver.com>

After the backport of the changes to fix CVE 2019-7308, the
selftests also need to be fixed up, as was done originally
in mainline 80c9b2fae87b ("bpf: add various test cases to selftests").

This is a backport of upstream commit 80c9b2fae87b ("bpf: add various test
cases to selftests") adapted to 4.19 in order to fix the
selftests that began to fail after CVE-2019-7308 fixes.

Suggested-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2448,6 +2448,7 @@ static struct bpf_test tests[] = {
 		},
 		.result = REJECT,
 		.errstr = "invalid stack off=-79992 size=8",
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 	},
 	{
 		"PTR_TO_STACK store/load - out of bounds high",
@@ -2844,6 +2845,8 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
 	{
@@ -7457,6 +7460,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7481,6 +7485,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7507,6 +7512,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7532,6 +7538,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7580,6 +7587,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7651,6 +7659,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7702,6 +7711,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7729,6 +7739,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7755,6 +7766,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7784,6 +7796,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7814,6 +7827,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 4 },
 		.errstr = "R0 invalid mem access 'inv'",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7842,6 +7856,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 		.result_unpriv = REJECT,
 	},
@@ -7894,6 +7909,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "R0 min value is negative, either use unsigned index or do a if (index >=0) check.",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -8266,6 +8282,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "pointer offset 1073741822",
+		.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 		.result = REJECT
 	},
 	{
@@ -8287,6 +8304,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "pointer offset -1073741822",
+		.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 		.result = REJECT
 	},
 	{
@@ -8458,6 +8476,7 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN()
 		},
 		.errstr = "fp pointer offset 1073741822",
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 		.result = REJECT
 	},
 	{


