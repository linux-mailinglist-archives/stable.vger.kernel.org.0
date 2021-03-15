Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A5B33B951
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbhCOOFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233027AbhCOOAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 672EC64FF5;
        Mon, 15 Mar 2021 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816826;
        bh=ptP88J8fbBddTH3RACRuBf+OOYL2SZ1GE4DIz1hGU5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXac40ThIjUlH3sDUeobq7P1GwMsYWXjv72S//GzYJQz99lmFe7SVfUOXMaLIQsut
         oVh+dHg4Pda5ltDPkVQBEBFgR3mMKAqtZsiP22aof6BnyaIFzWvf07FdeuJPtD2aFT
         NpkBXfwH1fkf33vKEYUwz036xKIcjl/gxa0oevJY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 87/95] prctl: fix PR_SET_MM_AUXV kernel stack leak
Date:   Mon, 15 Mar 2021 14:57:57 +0100
Message-Id: <20210315135743.145446328@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
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
index 2e4f017f7c5a..03fc0152cc54 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2005,7 +2005,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 	 * up to the caller to provide sane values here, otherwise userspace
 	 * tools which use this vector might be unhappy.
 	 */
-	unsigned long user_auxv[AT_VECTOR_SIZE];
+	unsigned long user_auxv[AT_VECTOR_SIZE] = {};
 
 	if (len > sizeof(user_auxv))
 		return -EINVAL;
-- 
2.30.1



