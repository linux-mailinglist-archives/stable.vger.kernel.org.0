Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D44445C163
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348794AbhKXNRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:17:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347239AbhKXNPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:15:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38A3561ACD;
        Wed, 24 Nov 2021 12:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757857;
        bh=5uQdcJAIYetkrhHHx+WfPhaPvW9ZoGT4goh/HTNtE+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3JMIHn5CsOW3Aoq0Tfs2OfCkSfewBgliqDUkMYbUtB9gPtStspROY2EMpjnxVc1T
         Rp9e4FxUlAa85NCLoTa0uujaw3IV0aUKY8l8cHwQIYxXPmwDaIUa8wMebRWVplWUky
         bpRXP/gA8M0KyWrOjzCdbaeSZHdd7+E4RvHDL2VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yue Hu <huyue2@yulong.com>,
        Gao Xiang <xiang@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 4.19 257/323] erofs: remove the occupied parameter from z_erofs_pagevec_enqueue()
Date:   Wed, 24 Nov 2021 12:57:27 +0100
Message-Id: <20211124115727.567335363@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

commit 7dea3de7d384f4c8156e8bd93112ba6db1eb276c upstream.

No any behavior to variable occupied in z_erofs_attach_page() which
is only caller to z_erofs_pagevec_enqueue().

Link: https://lore.kernel.org/r/20210419102623.2015-1-zbestahu@gmail.com
Signed-off-by: Yue Hu <huyue2@yulong.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
[ Gao Xiang: handle 4.19 codebase conflicts manually. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/unzip_pagevec.h |    5 +----
 drivers/staging/erofs/unzip_vle.c     |    4 +---
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/staging/erofs/unzip_pagevec.h
+++ b/drivers/staging/erofs/unzip_pagevec.h
@@ -117,10 +117,8 @@ static inline void z_erofs_pagevec_ctor_
 static inline bool
 z_erofs_pagevec_ctor_enqueue(struct z_erofs_pagevec_ctor *ctor,
 			     struct page *page,
-			     enum z_erofs_page_type type,
-			     bool *occupied)
+			     enum z_erofs_page_type type)
 {
-	*occupied = false;
 	if (unlikely(ctor->next == NULL && type))
 		if (ctor->index + 1 == ctor->nr)
 			return false;
@@ -135,7 +133,6 @@ z_erofs_pagevec_ctor_enqueue(struct z_er
 	/* should remind that collector->next never equal to 1, 2 */
 	if (type == (uintptr_t)ctor->next) {
 		ctor->next = page;
-		*occupied = true;
 	}
 
 	ctor->pages[ctor->index++] =
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -234,7 +234,6 @@ static int z_erofs_vle_work_add_page(
 	enum z_erofs_page_type type)
 {
 	int ret;
-	bool occupied;
 
 	/* give priority for the compressed data storage */
 	if (builder->role >= Z_EROFS_VLE_WORK_PRIMARY &&
@@ -242,8 +241,7 @@ static int z_erofs_vle_work_add_page(
 		try_to_reuse_as_compressed_page(builder, page))
 		return 0;
 
-	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector,
-		page, type, &occupied);
+	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector, page, type);
 	builder->work->vcnt += (unsigned)ret;
 
 	return ret ? 0 : -EAGAIN;


