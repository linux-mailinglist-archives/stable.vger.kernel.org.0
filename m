Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB379520CA
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 04:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbfFYC4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 22:56:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46784 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730451AbfFYC4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 22:56:43 -0400
Received: by mail-pg1-f193.google.com with SMTP id v9so8123642pgr.13
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 19:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YO0bThXqTcc6bfzETNLQtMqrYVELFDQSwIky8BHaw0o=;
        b=Bx9ijhCyv+qDDpgNjYwCARypnkpBMXSIfsR5NMneqB8EfAMJaE1Dk6zgnG8eQM2I7T
         CeMwMYUfhuwFP/g4y8sAuyVzOGxB4qCZtxsI2aorROBq998HyfrSsdHFsJmN+2mjF3jv
         jM2qTzz7d/exRSXLjy/cA4IYG6o432XpNXHDdSA6ZzHnn+hbGmZFE3xDQpfaVkIhYy2A
         IeKlHruNXP0kWrKahXZEZnF00yoh+ieGi3ZOWVJ11SN4QlUcMhA2q5Dw2OEp4lGMytkA
         ywcxFtykUCY5jIZM8mmoKqBzsCBOyzi1cg1e354dW6FZVwQh2DC7TQpKNTFbB/ZEMQAZ
         MWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YO0bThXqTcc6bfzETNLQtMqrYVELFDQSwIky8BHaw0o=;
        b=mDRwsZKNpie/DuyzHMCcOBRn8uzg77F6h/WG/nwevvbuIPGEC3hc8cJGnVKA3Qk4yw
         0ssmPGP+IEclXZuxzTts5wQli1Y1aH1/K21rMKFBNbCdiEGWKENKnvenVsxZe6qDf7IT
         Xosf1CS0t9T6uYjjlGzbqmEg6a1bmQ0mRMc6e4OGyvfiwvwuss1xpKub3qKF3tUynKp4
         vDBSyy/r41+KMBfgPkHK57y8rDIZTDS5/0ZDE985RCjGpC/8WoV+bJGoGr/BW0zBwkK/
         DQaRgQMyvoccUGyrjm+1gsQT1qGI7Xq1/E0x+FFpLaKyjPByTWeDaD8/W+6iv4CrTAeX
         GQig==
X-Gm-Message-State: APjAAAXkEpHeowQnY9CISPqxJBRZ1XRnf9pGHOmSON+qJhgrEsz13NEf
        BAdgZZfz0Ntvfd8cv4LF6nbTRw==
X-Google-Smtp-Source: APXvYqyx/gDR63NsqUOWYoNRoRisc658vThdjlLJwR5idm3YD/+u1Yv3FZcqnJExF3POzJXmkBMuWQ==
X-Received: by 2002:a17:90a:2641:: with SMTP id l59mr27107858pje.55.1561431403086;
        Mon, 24 Jun 2019 19:56:43 -0700 (PDT)
Received: from localhost.localdomain (1-164-148-41.dynamic-ip.hinet.net. [1.164.148.41])
        by smtp.gmail.com with ESMTPSA id y12sm15092473pfn.187.2019.06.24.19.56.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 19:56:42 -0700 (PDT)
From:   Green Wan <green.wan@sifive.com>
To:     green.wan@sifive.com
Cc:     Oscar Salvador <osalvador@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PREVIEW PATCH v1 v1 1/4] mm, page_alloc: fix has_unmovable_pages for HugePages
Date:   Tue, 25 Jun 2019 10:56:30 +0800
Message-Id: <20190625025633.2938-2-green.wan@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625025633.2938-1-green.wan@sifive.com>
References: <20190625025633.2938-1-green.wan@sifive.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>

While playing with gigantic hugepages and memory_hotplug, I triggered
the following #PF when "cat memoryX/removable":

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  #PF error: [normal kernel read fault]
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP PTI
  CPU: 1 PID: 1481 Comm: cat Tainted: G            E     4.20.0-rc6-mm1-1-default+ #18
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
  RIP: 0010:has_unmovable_pages+0x154/0x210
  Call Trace:
   is_mem_section_removable+0x7d/0x100
   removable_show+0x90/0xb0
   dev_attr_show+0x1c/0x50
   sysfs_kf_seq_show+0xca/0x1b0
   seq_read+0x133/0x380
   __vfs_read+0x26/0x180
   vfs_read+0x89/0x140
   ksys_read+0x42/0x90
   do_syscall_64+0x5b/0x180
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason is we do not pass the Head to page_hstate(), and so, the call
to compound_order() in page_hstate() returns 0, so we end up checking
all hstates's size to match PAGE_SIZE.

Obviously, we do not find any hstate matching that size, and we return
NULL.  Then, we dereference that NULL pointer in
hugepage_migration_supported() and we got the #PF from above.

Fix that by getting the head page before calling page_hstate().

Also, since gigantic pages span several pageblocks, re-adjust the logic
for skipping pages.  While are it, we can also get rid of the
round_up().

[osalvador@suse.de: remove round_up(), adjust skip pages logic per Michal]
  Link: http://lkml.kernel.org/r/20181221062809.31771-1-osalvador@suse.de
Link: http://lkml.kernel.org/r/20181217225113.17864-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/page_alloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e2afdb2dc2c5..e95b5b7c9c3d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7814,11 +7814,14 @@ bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
 		 * handle each tail page individually in migration.
 		 */
 		if (PageHuge(page)) {
+			struct page *head = compound_head(page);
+			unsigned int skip_pages;
 
-			if (!hugepage_migration_supported(page_hstate(page)))
+			if (!hugepage_migration_supported(page_hstate(head)))
 				goto unmovable;
 
-			iter = round_up(iter + 1, 1<<compound_order(page)) - 1;
+			skip_pages = (1 << compound_order(head)) - (page - head);
+			iter += skip_pages - 1;
 			continue;
 		}
 
-- 
2.17.1

