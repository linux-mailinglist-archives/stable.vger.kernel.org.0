Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D07F3033CC
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbhAZFFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730650AbhAYSzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3B092075B;
        Mon, 25 Jan 2021 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600890;
        bh=dYV+tZd4GEFHW6Zq3N8EVPrfHAsiQAiTEqml3zHC67I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/XkVyIVIrawqsrUdIZ2LFz3rkAzzkctQwBFH/PfW0IGGnGyIOvhcz95JTd5DxU/n
         ITBrQTszpFTwi+jiPwNmxxMKRgJ85+09xFdMA/MamGFT2lSFfy9F6hUApBXDsP8Qax
         e4/iJQ89NJ7pOk5yXzDYEKzSXgac9IQGxyFonQA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eirik Fuller <efuller@redhat.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 160/199] selftests/powerpc: Fix exit status of pkey tests
Date:   Mon, 25 Jan 2021 19:39:42 +0100
Message-Id: <20210125183222.948455270@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan@linux.ibm.com>

commit 92a5e1fdb286851d5bd0eb966b8d075be27cf5ee upstream.

Since main() does not return a value explicitly, the
return values from FAIL_IF() conditions are ignored
and the tests can still pass irrespective of failures.
This makes sure that we always explicitly return the
correct test exit status.

Fixes: 1addb6444791 ("selftests/powerpc: Add test for execute-disabled pkeys")
Fixes: c27f2fd1705a ("selftests/powerpc: Add test for pkey siginfo verification")
Reported-by: Eirik Fuller <efuller@redhat.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210118093145.10134-1-sandipan@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/powerpc/mm/pkey_exec_prot.c |    2 +-
 tools/testing/selftests/powerpc/mm/pkey_siginfo.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/powerpc/mm/pkey_exec_prot.c
+++ b/tools/testing/selftests/powerpc/mm/pkey_exec_prot.c
@@ -290,5 +290,5 @@ static int test(void)
 
 int main(void)
 {
-	test_harness(test, "pkey_exec_prot");
+	return test_harness(test, "pkey_exec_prot");
 }
--- a/tools/testing/selftests/powerpc/mm/pkey_siginfo.c
+++ b/tools/testing/selftests/powerpc/mm/pkey_siginfo.c
@@ -329,5 +329,5 @@ static int test(void)
 
 int main(void)
 {
-	test_harness(test, "pkey_siginfo");
+	return test_harness(test, "pkey_siginfo");
 }


