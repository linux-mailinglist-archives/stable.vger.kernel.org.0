Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B4717F9D7
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgCJNAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbgCJNAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:00:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5D5D20674;
        Tue, 10 Mar 2020 13:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845229;
        bh=drD9BmDnYOiF+wounImhcJd5qTAl34ML2BjUO+0KUXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjbjyBniByoBiz9VXCMCKQm9/r2LEmLafsCrVC+GtHtx+FSzp6VE6hLnhDDv9Gl38
         KDU3tL4KogncDh/qeIU31vlHOaDbtMTT4TSgvB2bLIT798SW6fKPRs//5+hMCeUV7T
         njDkDLkhc6+3QfV9vb6dW8QO+JkCAZEUF3+lNc7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.5 107/189] s390/mm: fix panic in gup_fast on large pud
Date:   Tue, 10 Mar 2020 13:39:04 +0100
Message-Id: <20200310123650.508914716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 582b4e55403e053d8a48ff687a05174da9cc3fb0 upstream.

On s390 there currently is no implementation of pud_write(). That was ok
as long as we had our own implementation of get_user_pages_fast() which
checked for pud protection by testing the bit directly w/o using
pud_write(). The other callers of pud_write() are not reachable on s390.

After commit 1a42010cdc26 ("s390/mm: convert to the generic
get_user_pages_fast code") we use the generic get_user_pages_fast(), which
does call pud_write() in pud_access_permitted() for FOLL_WRITE access on
a large pud. Without an s390 specific pud_write(), the generic version is
called, which contains a BUG() statement to remind us that we don't have a
proper implementation. This results in a kernel panic.

Fix this by providing an implementation of pud_write().

Cc: <stable@vger.kernel.org> # 5.2+
Fixes: 1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code")
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -750,6 +750,12 @@ static inline int pmd_write(pmd_t pmd)
 	return (pmd_val(pmd) & _SEGMENT_ENTRY_WRITE) != 0;
 }
 
+#define pud_write pud_write
+static inline int pud_write(pud_t pud)
+{
+	return (pud_val(pud) & _REGION3_ENTRY_WRITE) != 0;
+}
+
 static inline int pmd_dirty(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _SEGMENT_ENTRY_DIRTY) != 0;


