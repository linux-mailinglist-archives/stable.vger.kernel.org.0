Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B345F38A754
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbhETKhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237693AbhETKfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A22A61622;
        Thu, 20 May 2021 09:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504411;
        bh=2/Rl3W7X4b1oq6Dbm5G5YS7nPddJzKElO4sRm5F2M2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXbYW84ZJP87G02OYg4OO7IL2G/B4EMfaXtPJFX39ploPcWTl4xBRacVIFSAJolsD
         VFRJy5yLAoce2wp5WQ8ccY0S6IPoGcSfCu1RkTe+vhr4GqsViUgJXqzbE40jwZK+VY
         vDp0iesVnt6blsVcwIv1IgcJGEKZ2f+GrfQy4VPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 4.14 232/323] Revert "fdt: Properly handle "no-map" field in the memory region"
Date:   Thu, 20 May 2021 11:22:04 +0200
Message-Id: <20210520092128.112193143@linuxfoundation.org>
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

This reverts commit 71bc5d496725f7f923904d2f41cd39e32c647fdf.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/fdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1213,7 +1213,7 @@ int __init __weak early_init_dt_reserve_
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_mark_nomap(base, size);
+		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
 }
 


