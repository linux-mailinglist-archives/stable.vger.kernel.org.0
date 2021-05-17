Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0467C38371E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbhEQPkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244224AbhEQPg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A48661360;
        Mon, 17 May 2021 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262417;
        bh=a4yamCC8qnVv/cSRaTHuXgN9RNgwx+1LS01fGTGFiGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3ToTHAgP3Zd+jGF0If6wqM06WMQHUuFBhC/fwDDsw2DP/13zlW699V211vFRovh5
         6K2QJlxiGiS5aew5+L7dklBVU87/agbPQVWM+K2DGcZ3gaxMO5W3PCcEeEODenui8Q
         V5IhCnZe0IiP6mqZ+mIhux1yGbSTFhknDa43x9Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>
Subject: [PATCH 5.10 183/289] fs/proc/generic.c: fix incorrect pde_is_permanent check
Date:   Mon, 17 May 2021 16:01:48 +0200
Message-Id: <20210517140311.269772793@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f4bf74d82915708208bc9d0c9bd3f769f56bfbec ]

Currently the pde_is_permanent() check is being run on root multiple times
rather than on the next proc directory entry.  This looks like a
copy-paste error.  Fix this by replacing root with next.

Addresses-Coverity: ("Copy-paste error")
Link: https://lkml.kernel.org/r/20210318122633.14222-1-colin.king@canonical.com
Fixes: d919b33dafb3 ("proc: faster open/read/close with "permanent" files")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 6c0a05f55d6b..09e4d8a499a3 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -754,7 +754,7 @@ int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
 	while (1) {
 		next = pde_subdir_first(de);
 		if (next) {
-			if (unlikely(pde_is_permanent(root))) {
+			if (unlikely(pde_is_permanent(next))) {
 				write_unlock(&proc_subdir_lock);
 				WARN(1, "removing permanent /proc entry '%s/%s'",
 					next->parent->name, next->name);
-- 
2.30.2



