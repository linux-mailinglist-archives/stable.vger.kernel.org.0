Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C063426660C
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgIKRUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgIKNBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:01:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63B702222D;
        Fri, 11 Sep 2020 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829004;
        bh=6XiXYf1OQACfz6Pl7MUVTDtIWF63t2t/6FVZNrXz7CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkSuYtEPJbNoqYhNCXSpTgL67XPtgSAJAU5LY3GrQx9UiDozXk1SzoWSSAabUQtrv
         TbJ8HLfPVkEsRWXIjkYrXA+3My6hdaE/J3A/9rdNYPuskMAI7NDqjB37o0cCQg0nr+
         y7E9X+cmKdBq6iCpLzOrun/XNnzyEB6cOXsBXPO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/71] include/linux/log2.h: add missing () around n in roundup_pow_of_two()
Date:   Fri, 11 Sep 2020 14:46:12 +0200
Message-Id: <20200911122506.337164398@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 428fc0aff4e59399ec719ffcc1f7a5d29a4ee476 ]

Otherwise gcc generates warnings if the expression is complicated.

Fixes: 312a0c170945 ("[PATCH] LOG2: Alter roundup_pow_of_two() so that it can use a ilog2() on a constant")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lkml.kernel.org/r/0-v1-8a2697e3c003+41165-log_brackets_jgg@nvidia.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/log2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index c373295f359fa..cca606609e1bc 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -159,7 +159,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 #define roundup_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 1 :			\
+		((n) == 1) ? 1 :		\
 		(1UL << (ilog2((n) - 1) + 1))	\
 				   ) :		\
 	__roundup_pow_of_two(n)			\
-- 
2.25.1



