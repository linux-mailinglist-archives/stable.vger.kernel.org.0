Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F270431AE6
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhJRN3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231921AbhJRN3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6987061371;
        Mon, 18 Oct 2021 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563602;
        bh=1S1QACtcwhixShhhtmO6ZqqEYgfaXBF0nZjGGYPVGZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kj0dEdCf/IHhpNBpQCG3Cg0HNXw7Ex2YqqQPhvlyMS+c/7uM/+BsUvZ7FM4M482H8
         WoX7ZHmovMqdIpIzYq6+1SwhQ3RnIzYWee3Jjmlfn0OVJDnDG8ckbZsUqIQfYYHq8c
         53NTMb7LJvNslKqfJDjaf57uNn3OnBJ3kBeE1UE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14 03/39] s390: fix strrchr() implementation
Date:   Mon, 18 Oct 2021 15:24:12 +0200
Message-Id: <20211018132325.536685997@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
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
@@ -227,14 +227,13 @@ EXPORT_SYMBOL(strcmp);
  */
 char * strrchr(const char * s, int c)
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
 


