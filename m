Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E923024BEF6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbgHTNda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbgHTJau (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75523207DE;
        Thu, 20 Aug 2020 09:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915849;
        bh=kJJouGqpk7y9KGYIB/qSQlzNKFugPURJbr0dDf5g/yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0YkF4dUR4AcpAj0qzjv3EwIrbuaCM/4kTsWMyH651WyJDJINAlH/Z0j8LPWP9VTk
         A4scw0gWOCBjMXzWLYhAKnVBIlYeu+gVN5C6NxTDBGzecZjHXzRawVxf2idme6+5Eu
         9qy10tSyrLil7WyaWxMaFXBlySmFkokpRRdg9gtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 154/232] selftests/powerpc: ptrace-pkey: Dont update expected UAMOR value
Date:   Thu, 20 Aug 2020 11:20:05 +0200
Message-Id: <20200820091620.269436164@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 3563b9bea0ca7f53e4218b5e268550341a49f333 ]

With commit 4a4a5e5d2aad ("powerpc/pkeys: key allocation/deallocation
must not change pkey registers") we are not updating UAMOR on key
allocation. So don't update the expected uamor value in the test.

Fixes: 4a4a5e5d2aad ("powerpc/pkeys: key allocation/deallocation must not change pkey registers")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200709032946.881753-23-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c b/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
index bc33d748d95b4..3694613f418f6 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c
@@ -101,15 +101,20 @@ static int child(struct shared_info *info)
 	 */
 	info->invalid_amr = info->amr2 | (~0x0UL & ~info->expected_uamor);
 
+	/*
+	 * if PKEY_DISABLE_EXECUTE succeeded we should update the expected_iamr
+	 */
 	if (disable_execute)
 		info->expected_iamr |= 1ul << pkeyshift(pkey1);
 	else
 		info->expected_iamr &= ~(1ul << pkeyshift(pkey1));
 
-	info->expected_iamr &= ~(1ul << pkeyshift(pkey2) | 1ul << pkeyshift(pkey3));
+	/*
+	 * We allocated pkey2 and pkey 3 above. Clear the IAMR bits.
+	 */
+	info->expected_iamr &= ~(1ul << pkeyshift(pkey2));
+	info->expected_iamr &= ~(1ul << pkeyshift(pkey3));
 
-	info->expected_uamor |= 3ul << pkeyshift(pkey1) |
-				3ul << pkeyshift(pkey2);
 	/*
 	 * Create an IAMR value different from expected value.
 	 * Kernel will reject an IAMR and UAMOR change.
-- 
2.25.1



