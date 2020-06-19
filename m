Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70D9200CE5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389025AbgFSOu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389384AbgFSOu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:50:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38B2E20776;
        Fri, 19 Jun 2020 14:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578256;
        bh=nvgbRfzR8VCuy4iYcmNPWSPTPLMDk7u16hUJ9OkYZOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7PWO/1C/nSTSXeZetXgROpWVMaDZdYrA0GkJLe5KUI/pEmUJ45vKLySQ3uy0I0DJ
         HaYmCYmY9+5akVc0nEpJviVrpDGxZQ7I7rum8Bd0jSpQikG5OBZ5zSCWtY98XcuYD9
         zuG6XooKXok5EMSR69PZH5wqF17i0UpBnlhABtm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 126/190] x86/mm: Stop printing BRK addresses
Date:   Fri, 19 Jun 2020 16:32:51 +0200
Message-Id: <20200619141639.921589009@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit 67d631b7c05eff955ccff4139327f0f92a5117e5 ]

This currently leaks kernel physical addresses into userspace.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Link: https://lkml.kernel.org/r/20200229231120.1147527-1-nivedita@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 32bb38f6fc18..8039a951db8f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -112,8 +112,6 @@ __ref void *alloc_low_pages(unsigned int num)
 	} else {
 		pfn = pgt_buf_end;
 		pgt_buf_end += num;
-		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
-			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
 	}
 
 	for (i = 0; i < num; i++) {
-- 
2.25.1



