Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8B1431CBC
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhJRNoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233258AbhJRNmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A003B61353;
        Mon, 18 Oct 2021 13:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564051;
        bh=cesyj4anBa+P1NwYCsv+OIjAb5LzGTtCQDFHTqD9RZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuUofMGt4CFSgXLiArmPLtum/chiqOSv1bmquRNNBoqfBRLgEAq0WoLhGvGzvkhrB
         +j0E2qYq1qO35fj4pyvVyOmtXJmH2Ud/WUfnY+eKmqSYBcBlhw/NdW5mhAwoeYT3X5
         6U+ZHQfLZzMpT1hEsFMRGiqy2pYinGuYGqsRKfDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 013/103] s390: fix strrchr() implementation
Date:   Mon, 18 Oct 2021 15:23:49 +0200
Message-Id: <20211018132335.141328601@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 8e0ab8e26b72a80e991c66a8abc16e6c856abe3d upstream.

Fix two problems found in the strrchr() implementation for s390
architectures: evaluate empty strings (return the string address instead of
NULL, if '\0' is passed as second argument); evaluate the first character
of non-empty strings (the current implementation stops at the second).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Heiko Carstens <hca@linux.ibm.com> (incorrect behavior with empty strings)
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Link: https://lore.kernel.org/r/20211005120836.60630-1-roberto.sassu@huawei.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/lib/string.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/arch/s390/lib/string.c
+++ b/arch/s390/lib/string.c
@@ -246,14 +246,13 @@ EXPORT_SYMBOL(strcmp);
 #ifdef __HAVE_ARCH_STRRCHR
 char *strrchr(const char *s, int c)
 {
-       size_t len = __strend(s) - s;
+	ssize_t len = __strend(s) - s;
 
-       if (len)
-	       do {
-		       if (s[len] == (char) c)
-			       return (char *) s + len;
-	       } while (--len > 0);
-       return NULL;
+	do {
+		if (s[len] == (char)c)
+			return (char *)s + len;
+	} while (--len >= 0);
+	return NULL;
 }
 EXPORT_SYMBOL(strrchr);
 #endif


