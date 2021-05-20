Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4649F38A753
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbhETKhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237692AbhETKfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D75F261582;
        Thu, 20 May 2021 09:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504409;
        bh=rVNgWBzYJQW4cFfpHDK+NQlrI5Y2WbL1fz1YraVtl7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBnR9/cPev9lX2/9yScV2Dy9Y7Hbawb5fX3MGxQ/bHvp1wcPtadVyKYutUbriVm/G
         wrxUuzb9kslao9bml4t4k2XiaNiVv6XOVDzkB8yugndzFxW3HWKxsBb60ckZr8LrfZ
         EsUeB6Gjcv/x8q/d17udct0U85ZzEesqWOJvbtaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 4.14 231/323] Revert "of/fdt: Make sure no-map does not remove already reserved regions"
Date:   Thu, 20 May 2021 11:22:03 +0200
Message-Id: <20210520092128.080134633@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

This reverts commit 6793433fc8f263eaba1621d3724b6aeba511c6c5.
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
@@ -1212,16 +1212,8 @@ int __init __weak early_init_dt_mark_hot
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
 


