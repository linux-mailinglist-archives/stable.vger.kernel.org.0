Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF23733B5BA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhCONzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231345AbhCONym (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85FBB64F3F;
        Mon, 15 Mar 2021 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816481;
        bh=9qnZvzzN/f+RXvncp2+igTK2OLeYBHrWIvYcYec0Jv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRuc8Z41Xtd3/m1UAqUoe7p9NCekZ0WzQXu6ihD9j2GkPxBiS5uRE3wPcXHlclpIG
         T12xyC89mHJGeZecF7eOzqKdiN3xcGCtEUm2OIbjt9C5eW3QovlTlNvajxceOj7z68
         Kt4t4UJy4JPdwCkzLzJ442lEePV4FZwJH+GyiDVk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 64/78] prctl: fix PR_SET_MM_AUXV kernel stack leak
Date:   Mon, 15 Mar 2021 14:52:27 +0100
Message-Id: <20210315135214.162644461@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
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
index 546cdc911dad..76b3d9262644 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1910,7 +1910,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 	 * up to the caller to provide sane values here, otherwise userspace
 	 * tools which use this vector might be unhappy.
 	 */
-	unsigned long user_auxv[AT_VECTOR_SIZE];
+	unsigned long user_auxv[AT_VECTOR_SIZE] = {};
 
 	if (len > sizeof(user_auxv))
 		return -EINVAL;
-- 
2.30.1



