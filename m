Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4380395B2B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhEaNSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhEaNR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:17:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5500161287;
        Mon, 31 May 2021 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622466977;
        bh=ky1acnZWizAomY1ZkvXyF+Ayfvqw981YaW9vR2OKY9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vm14+ELPZ775D9oV8JcmjYRfdRcSPItq8LrVtrzJj08KRNKFGu38PSTzhXHBHjxz8
         JvUVRx3oMacas6D2ubZYOq0/FlmZhkbSuHkc6D66hoqcUaZgHnzh/bPIXXxvBll9S/
         8yqmcKx0Dsbmqd8lw5z75DYn5ExOyG0KXmJnZ7gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Khalid Aziz <khalid.aziz@oracle.com>
Subject: [PATCH 4.4 01/54] mm, vmstat: drop zone->lock in /proc/pagetypeinfo
Date:   Mon, 31 May 2021 15:13:27 +0200
Message-Id: <20210531130635.122884655@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Brennan <stephen.s.brennan@oracle.com>

Commit 93b3a674485f6a4b8ffff85d1682d5e8b7c51560 upstream

Commit 93b3a674485f ("mm,vmstat: reduce zone->lock holding time by
/proc/pagetypeinfo") upstream caps the number of iterations over each
free_list at 100,000, and also drops the zone->lock in between each
migrate type. Capping the iteration count alters the file contents in
some cases, which means this approach may not be suitable for stable
backports.

However, dropping zone->lock in between migrate types (and, as a result,
page orders) will not change the /proc/pagetypeinfo file contents. It
can significantly reduce the length of time spent with IRQs disabled,
which can prevent missed interrupts or soft lockups which we have
observed on systems with particularly large memory.

Thus, this commit is a modified version of the upstream one which only
drops the lock in between migrate types.

Fixes: 467c996c1e19 ("Print out statistics in relation to fragmentation avoidance to /proc/pagetypeinfo")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmstat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -973,6 +973,9 @@ static void pagetypeinfo_showfree_print(
 			list_for_each(curr, &area->free_list[mtype])
 				freecount++;
 			seq_printf(m, "%6lu ", freecount);
+			spin_unlock_irq(&zone->lock);
+			cond_resched();
+			spin_lock_irq(&zone->lock);
 		}
 		seq_putc(m, '\n');
 	}


