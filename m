Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9190138A478
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhETKFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234756AbhETKD1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6DC1613BA;
        Thu, 20 May 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503608;
        bh=2l3NEuziJ9EVnMkTSCwU7k8snLlxBFt3IaaXmm8n8Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUjSGlgG1QnuQ7Qw3FxIL0tUQelU9+hMnUDCUlJVaHq1+iFRMyXAWH8PvJkAP1Qrp
         iybN0vDf5pYJyzKnYM3htV5cey71jDNtMcCdC/x0b2MIW/L8JqXRYCH83eOJBL/3Lp
         kNc1vKImbXv9VeKNPojLNJSoQ0nUC7Oadqve0+fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 4.19 299/425] Revert "of/fdt: Make sure no-map does not remove already reserved regions"
Date:   Thu, 20 May 2021 11:21:08 +0200
Message-Id: <20210520092141.274600221@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

This reverts commit 74f2678aab60c9915daa83e6e23d31a896932d9d.
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
@@ -1172,16 +1172,8 @@ int __init __weak early_init_dt_mark_hot
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
 


