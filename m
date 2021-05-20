Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E80F38A964
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbhETLBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239551AbhETK7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D70961D04;
        Thu, 20 May 2021 10:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504983;
        bh=zmheuGEIVSckVMyyv4arLnlmE4cyggUMR0mEGACkVs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3SX4FInVnKRPkRruzJ6d+CoAZaGr2T0sGwSKFrc3A+8MJ2//YPkfWEH+X0w+rCuU
         cx9RtlgNt5ItsLOE+KcD53xfFklpF/Loj5ciolhVvih/cX0lWnE8OZL+In/+mBjieJ
         uWAJSvHeEabVLRSvXBHNQZb7zDHWc3U2bMjxxXss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 4.9 169/240] Revert "fdt: Properly handle "no-map" field in the memory region"
Date:   Thu, 20 May 2021 11:22:41 +0200
Message-Id: <20210520092114.320010701@linuxfoundation.org>
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

This reverts commit 86ac82a7c708acf4738c396228be7b8fdaae4d99.
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
@@ -1159,7 +1159,7 @@ int __init __weak early_init_dt_reserve_
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_mark_nomap(base, size);
+		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
 }
 


