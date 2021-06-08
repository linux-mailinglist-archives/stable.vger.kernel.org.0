Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F233A03D1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbhFHTWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235156AbhFHTSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:18:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A01ED61987;
        Tue,  8 Jun 2021 18:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178317;
        bh=0BCgrFCewNvWVUUHpFKWhVwnot4uLMCRIhqbXWz+pu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfezEIGqSbKIv8XTiUWWeDwwrEkhaGfXfDVO/M9VCyveT+8W/HbhC0g8LId1TOZnQ
         sS4sw1H19zMgzMdOuu7t7chJDtetmhnl7Um2ghxTUaUP5n28Dlgk34wJpHOW8T9RrZ
         9SzJmlrhPdLtIHU1edlDnfwY+Rf0Jy3g8ZsOXYLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Hillf Danton <hdanton@sina.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 124/161] kfence: use TASK_IDLE when awaiting allocation
Date:   Tue,  8 Jun 2021 20:27:34 +0200
Message-Id: <20210608175949.638879750@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 8fd0e995cc7b6a7a8a40bc03d52a2cd445beeff4 upstream.

Since wait_event() uses TASK_UNINTERRUPTIBLE by default, waiting for an
allocation counts towards load.  However, for KFENCE, this does not make
any sense, since there is no busy work we're awaiting.

Instead, use TASK_IDLE via wait_event_idle() to not count towards load.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1185565
Link: https://lkml.kernel.org/r/20210521083209.3740269-1-elver@google.com
Fixes: 407f1d8c1b5f ("kfence: await for allocation using wait_event")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -626,10 +626,10 @@ static void toggle_allocation_gate(struc
 		 * During low activity with no allocations we might wait a
 		 * while; let's avoid the hung task warning.
 		 */
-		wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
-				   sysctl_hung_task_timeout_secs * HZ / 2);
+		wait_event_idle_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
+					sysctl_hung_task_timeout_secs * HZ / 2);
 	} else {
-		wait_event(allocation_wait, atomic_read(&kfence_allocation_gate));
+		wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate));
 	}
 
 	/* Disable static key and reset timer. */


