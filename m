Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21FF144EAC
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgAVJac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVJab (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:30:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 064802467A;
        Wed, 22 Jan 2020 09:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685431;
        bh=FsfF4NfcdYAvMcZURswP/E6Pd7la1YZs0Ix6zZrUEiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WO9OmUR4H0JNQcXu/vkpceApO2JZPz/JiZtB8cntHu5dZu6eMD4mkaYm8lnWC0nlG
         qb2k4h9ohrKz4M6/yv1CkIhukTqDJSNxEtoUeQLRp8DRdwbEwiOw37jtcqw6YopfCv
         wqR6hLwA+3rYgOZIToLzLtsIcdwi1LVmguW5+B7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 12/76] xen: let alloc_xenballooned_pages() fail if not enough memory free
Date:   Wed, 22 Jan 2020 10:28:28 +0100
Message-Id: <20200122092752.831204783@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit a1078e821b605813b63bf6bca414a85f804d5c66 upstream.

Instead of trying to allocate pages with GFP_USER in
add_ballooned_pages() check the available free memory via
si_mem_available(). GFP_USER is far less limiting memory exhaustion
than the test via si_mem_available().

This will avoid dom0 running out of memory due to excessive foreign
page mappings especially on ARM and on x86 in PVH mode, as those don't
have a pre-ballooned area which can be used for foreign mappings.

As the normal ballooning suffers from the same problem don't balloon
down more than si_mem_available() pages in one iteration. At the same
time limit the default maximum number of retries.

This is part of XSA-300.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/balloon.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -584,8 +584,15 @@ static void balloon_process(struct work_
 				state = reserve_additional_memory();
 		}
 
-		if (credit < 0)
-			state = decrease_reservation(-credit, GFP_BALLOON);
+		if (credit < 0) {
+			long n_pages;
+
+			n_pages = min(-credit, si_mem_available());
+			state = decrease_reservation(n_pages, GFP_BALLOON);
+			if (state == BP_DONE && n_pages != -credit &&
+			    n_pages < totalreserve_pages)
+				state = BP_EAGAIN;
+		}
 
 		state = update_schedule(state);
 
@@ -624,6 +631,9 @@ static int add_ballooned_pages(int nr_pa
 		}
 	}
 
+	if (si_mem_available() < nr_pages)
+		return -ENOMEM;
+
 	st = decrease_reservation(nr_pages, GFP_USER);
 	if (st != BP_DONE)
 		return -ENOMEM;
@@ -747,7 +757,7 @@ static int __init balloon_init(void)
 	balloon_stats.schedule_delay = 1;
 	balloon_stats.max_schedule_delay = 32;
 	balloon_stats.retry_count = 1;
-	balloon_stats.max_retry_count = RETRY_UNLIMITED;
+	balloon_stats.max_retry_count = 4;
 
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	set_online_page_callback(&xen_online_page);


