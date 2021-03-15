Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B9F33BA82
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhCOOJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhCOODx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9529600EF;
        Mon, 15 Mar 2021 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817033;
        bh=kS+ZPXV7JrwZH1yID6qLLiZfV2jBJJqvvHJx4T01hpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHRAwjtUaUmeh9p+jMqLy6V/pXJE7RpRMlQou0TWNK+krt+dDwZrXTUO1hLKGHZu/
         Nff2iUuMV4n+WXMorvTTpVN/qTHLOcFW9N6bbHheYrsJQKGdhBTao9+RQeWIypAB91
         jrJ4IlZO/MMynGXEmHykOygFp6l2t5OWZ+Iju9uc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 268/306] prctl: fix PR_SET_MM_AUXV kernel stack leak
Date:   Mon, 15 Mar 2021 14:55:31 +0100
Message-Id: <20210315135516.707577306@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit c995f12ad8842dbf5cfed113fb52cdd083f5afd1 ]

Doing a

	prctl(PR_SET_MM, PR_SET_MM_AUXV, addr, 1);

will copy 1 byte from userspace to (quite big) on-stack array
and then stash everything to mm->saved_auxv.
AT_NULL terminator will be inserted at the very end.

/proc/*/auxv handler will find that AT_NULL terminator
and copy original stack contents to userspace.

This devious scheme requires CAP_SYS_RESOURCE.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 51f00fe20e4d..7cf21c947649 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2080,7 +2080,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 	 * up to the caller to provide sane values here, otherwise userspace
 	 * tools which use this vector might be unhappy.
 	 */
-	unsigned long user_auxv[AT_VECTOR_SIZE];
+	unsigned long user_auxv[AT_VECTOR_SIZE] = {};
 
 	if (len > sizeof(user_auxv))
 		return -EINVAL;
-- 
2.30.1



