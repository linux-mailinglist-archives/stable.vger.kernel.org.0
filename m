Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F93831D6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbhEQOlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240874AbhEQOjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16DFD6139A;
        Mon, 17 May 2021 14:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261104;
        bh=Y1Fi/8EmZWG4KsmdkBqPpUUPzppWQTtjsGwFkKKu/P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19j4hvdi+fDGmBa1H6CR/00j8vtQqkaPbHPPpzk5nuzqlCkHAOsHwr+JUCM2uDyMv
         D7R4Qr1jc3byZiR7+TqttI2HlqIdeBDlzEIgX8RKqCkTxpkW801iH2Lf7yAsJoQXuE
         IHBlGf0TtxRZIPs0dkwKPw1QmQ6XF5wG354FWJJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 282/363] dax: Wake up all waiters after invalidating dax entry
Date:   Mon, 17 May 2021 16:02:28 +0200
Message-Id: <20210517140312.145203437@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

[ Upstream commit 237388320deffde7c2d65ed8fc9eef670dc979b3 ]

I am seeing missed wakeups which ultimately lead to a deadlock when I am
using virtiofs with DAX enabled and running "make -j". I had to mount
virtiofs as rootfs and also reduce to dax window size to 256M to reproduce
the problem consistently.

So here is the problem. put_unlocked_entry() wakes up waiters only
if entry is not null as well as !dax_is_conflict(entry). But if I
call multiple instances of invalidate_inode_pages2() in parallel,
then I can run into a situation where there are waiters on
this index but nobody will wake these waiters.

invalidate_inode_pages2()
  invalidate_inode_pages2_range()
    invalidate_exceptional_entry2()
      dax_invalidate_mapping_entry_sync()
        __dax_invalidate_entry() {
                xas_lock_irq(&xas);
                entry = get_unlocked_entry(&xas, 0);
                ...
                ...
                dax_disassociate_entry(entry, mapping, trunc);
                xas_store(&xas, NULL);
                ...
                ...
                put_unlocked_entry(&xas, entry);
                xas_unlock_irq(&xas);
        }

Say a fault in in progress and it has locked entry at offset say "0x1c".
Now say three instances of invalidate_inode_pages2() are in progress
(A, B, C) and they all try to invalidate entry at offset "0x1c". Given
dax entry is locked, all tree instances A, B, C will wait in wait queue.

When dax fault finishes, say A is woken up. It will store NULL entry
at index "0x1c" and wake up B. When B comes along it will find "entry=0"
at page offset 0x1c and it will call put_unlocked_entry(&xas, 0). And
this means put_unlocked_entry() will not wake up next waiter, given
the current code. And that means C continues to wait and is not woken
up.

This patch fixes the issue by waking up all waiters when a dax entry
has been invalidated. This seems to fix the deadlock I am facing
and I can make forward progress.

Reported-by: Sergio Lopez <slp@redhat.com>
Fixes: ac401cc78242 ("dax: New fault locking")
Reviewed-by: Jan Kara <jack@suse.cz>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: https://lore.kernel.org/r/20210428190314.1865312-4-vgoyal@redhat.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 56eb1c759ca5..df5485b4bddf 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -675,7 +675,7 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	mapping->nrexceptional--;
 	ret = 1;
 out:
-	put_unlocked_entry(&xas, entry, WAKE_NEXT);
+	put_unlocked_entry(&xas, entry, WAKE_ALL);
 	xas_unlock_irq(&xas);
 	return ret;
 }
-- 
2.30.2



