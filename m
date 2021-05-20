Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCF38A965
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239331AbhETLBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239548AbhETK7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62E9261D05;
        Thu, 20 May 2021 10:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504980;
        bh=yO0ZRCe6xcQUM/ujBAPsg/qgeWWTk8klaqAEMid8Xrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxvnvxOKf9cVy8xvxtk+41QiMPZlj7HmEzTfVwFSwchfOQqseyaVHs/4vl7jeqTa0
         HdTZemjOdB+FanGmdznTSoGTYGp5O1IWViwp81GUP8KHcvFzS8xsCPk9xAWJ42P0MJ
         SHNw2rlx4TITHX+BeluJ6TUux2rUBtnFBIaUQPdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 4.9 168/240] Revert "of/fdt: Make sure no-map does not remove already reserved regions"
Date:   Thu, 20 May 2021 11:22:40 +0200
Message-Id: <20210520092114.287417646@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

This reverts commit 666ae7c255f9eb7a8fd8e55641542f3624a78b43.
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
@@ -1158,16 +1158,8 @@ void __init __weak early_init_dt_add_mem
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
 


