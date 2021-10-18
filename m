Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F0B431B46
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhJRNcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232518AbhJRNaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A29F61354;
        Mon, 18 Oct 2021 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563690;
        bh=aie0rVgh2GXA4o4dbwnc3y+pXKr+uqUMVv2dMXjW5kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKh6waEIC+55S8Nw7N1pgnD+TiJeJ9BbhOec7NPPeWPmDkXbVHq5GYu1bFXr6xH22
         SwQeWzE2zfzE00fg1AtZmsEEn2KDD7jsTaB2Mv0oZ/ESeeizCIENWA5Ae4S2EBAY/q
         krl5Hs2HwI6rk3ZkSzsxDzhjbxi7bzShCAA220uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.19 06/50] s390: fix strrchr() implementation
Date:   Mon, 18 Oct 2021 15:24:13 +0200
Message-Id: <20211018132326.732689189@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
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
 


