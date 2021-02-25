Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7987324D72
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhBYKBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235279AbhBYJ66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:58:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8DEC64EBA;
        Thu, 25 Feb 2021 09:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246905;
        bh=raU4MGqjBAmfuxy7acDYtTLSzIYckDSt6CZlH5zXx88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEI23AyXWiTPnCusOTpVAuILNNU0Ew690J+y7XUOraQCdyPtuYJnlcygci9XBYzhc
         QFZ+AxifjlbGttm2s9JtMB91h2u+Els2VY9xzhmDX3iu6VZUpLC7SQQgeorYWlk+EY
         EJsyWtbhVodiaWf7nW6PZV+rLmxY/h0wWEQxQL8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 13/23] mm: unexport follow_pte_pmd
Date:   Thu, 25 Feb 2021 10:53:44 +0100
Message-Id: <20210225092517.163803871@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7336375734d65ecc82956b59a79cf5deccce880c upstream.

Patch series "simplify follow_pte a bit".

This small series drops the not needed follow_pte_pmd exports, and
simplifies the follow_pte family of functions a bit.

This patch (of 2):

follow_pte_pmd() is only used by the DAX code, which can't be modular.

Link: https://lkml.kernel.org/r/20201029101432.47011-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4798,7 +4798,6 @@ int follow_pte_pmd(struct mm_struct *mm,
 						    ptepp, pmdpp, ptlp)));
 	return res;
 }
-EXPORT_SYMBOL(follow_pte_pmd);
 
 /**
  * follow_pfn - look up PFN at a user virtual address


