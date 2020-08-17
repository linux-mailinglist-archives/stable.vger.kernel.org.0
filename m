Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FA82474E5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392113AbgHQTQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730429AbgHQPjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:39:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C9C422DD6;
        Mon, 17 Aug 2020 15:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678748;
        bh=6yYRTnNR6djOLWx2A2eTDjEiDgP+loFwD6B73wRHmec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xE3Cq/iXv185zCJ5SRXcb6qmucQ7xdkByNySq/gzhzOavQ1viaGNsEBtA7x7swJrJ
         9GsLSOjRY5RWLgVsKAo2HdeWkjbrN9K5c+uUTjZN5E5f+k0cl/XzlZXWl1zLVcLL0F
         UX2rU7SdhPxU7d4YGDY33HKqic2zFFsCIQMIlHi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sonny Rao <sonnyrao@chromium.org>,
        Baoquan He <bhe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 440/464] Revert "mm/vmstat.c: do not show lowmem reserve protection information of empty zone"
Date:   Mon, 17 Aug 2020 17:16:33 +0200
Message-Id: <20200817143854.851550056@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit a8a4b7aeaf841311cb13ff0f6c4710c7a00e68d4 upstream.

This reverts commit 26e7deadaae175.

Sonny reported that one of their tests started failing on the latest
kernel on their Chrome OS platform.  The root cause is that the above
commit removed the protection line of empty zone, while the parser used in
the test relies on the protection line to mark the end of each zone.

Let's revert it to avoid breaking userspace testing or applications.

Fixes: 26e7deadaae175 ("mm/vmstat.c: do not show lowmem reserve protection information of empty zone)"
Reported-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[5.8.x]
Link: http://lkml.kernel.org/r/20200811075412.12872-1-bhe@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmstat.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1596,12 +1596,6 @@ static void zoneinfo_show_print(struct s
 		   zone->present_pages,
 		   zone_managed_pages(zone));
 
-	/* If unpopulated, no other information is useful */
-	if (!populated_zone(zone)) {
-		seq_putc(m, '\n');
-		return;
-	}
-
 	seq_printf(m,
 		   "\n        protection: (%ld",
 		   zone->lowmem_reserve[0]);
@@ -1609,6 +1603,12 @@ static void zoneinfo_show_print(struct s
 		seq_printf(m, ", %ld", zone->lowmem_reserve[i]);
 	seq_putc(m, ')');
 
+	/* If unpopulated, no other information is useful */
+	if (!populated_zone(zone)) {
+		seq_putc(m, '\n');
+		return;
+	}
+
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", zone_stat_name(i),
 			   zone_page_state(zone, i));


