Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F29137C28C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhELPLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhELPJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A983061554;
        Wed, 12 May 2021 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831743;
        bh=gp9BWunF/72yHeXsBup/AYqV2mZwp9RbJVFcGYlS7mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiS12ZSuZ4eRSTvBfWPslsf27gZWLr3psOW4VxiqWFH7lK4G8j2nznde7QgLSe8WS
         FkNViRvlt3YuYI5YD6rFOrUzTEa+l1Z/MAv1feTIhfv9pcYnTiCpGDjVXeMiNQhbOt
         JJJE8aEngFrmzFKCM60KBJt2nmg3/6fqiHWBHrT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 5.4 243/244] Revert "of/fdt: Make sure no-map does not remove already reserved regions"
Date:   Wed, 12 May 2021 16:50:14 +0200
Message-Id: <20210512144750.779966197@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

This reverts commit 3cbd3038c9155038020560729cde50588311105d.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/fdt.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1153,16 +1153,8 @@ int __init __weak early_init_dt_mark_hot
 int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
-	if (nomap) {
-		/*
-		 * If the memory is already reserved (by another region), we
-		 * should not allow it to be marked nomap.
-		 */
-		if (memblock_is_region_reserved(base, size))
-			return -EBUSY;
-
+	if (nomap)
 		return memblock_mark_nomap(base, size);
-	}
 	return memblock_reserve(base, size);
 }
 


