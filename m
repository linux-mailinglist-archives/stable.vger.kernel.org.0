Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E734B37C28E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhELPLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233505AbhELPJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BF6B6141C;
        Wed, 12 May 2021 15:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831745;
        bh=z1XmGwu2LnFhq20KZvQg3phF9qMRyTebkECAEr9asmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5Wd82ly/Gwo8vbQRkQFZi+8whDjV235djNcgFD1H4AC+yEf4veLT2Wwr5HeQ3TP9
         9K6kKwpaz60QaXQty+hEfm8SpFsL5jb/0cBqWlc1Euo8Sul6ikhnPx/vWMzaw+rbIk
         puG7LqSFqFEclVkCeWFyo41N9bPS+dqDlN4I/QQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 5.4 244/244] Revert "fdt: Properly handle "no-map" field in the memory region"
Date:   Wed, 12 May 2021 16:50:15 +0200
Message-Id: <20210512144750.811516557@linuxfoundation.org>
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

This reverts commit fb326c6ce0dcbb6273202c6e012759754ec8538d.
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
@@ -1154,7 +1154,7 @@ int __init __weak early_init_dt_reserve_
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_mark_nomap(base, size);
+		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
 }
 


