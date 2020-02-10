Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A99F157AC0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgBJNZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgBJMg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:57 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687862080C;
        Mon, 10 Feb 2020 12:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338217;
        bh=x7mbJwPnoYiCrby8z4so/XhuqJLNCKJT4HctfRopyZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sS+MNX9DSmjJ7koXqRYShfMLx3vtIFFIfQIHa/RpejMoQ8VFrHcAi1Y6zRoX0p+mM
         XMMexID842BwPM0HjZyCkRi2yDDGF96Z+w78jx3TzMyc58vWnVE6yvGZZo8ZpaGegj
         zi7ehwC4+YEcXTh4jH05nT9xbyO/0XNv/cW6aZJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pingfan Liu <kernelfans@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Baoquan He <bhe@redhat.com>, Qian Cai <cai@lca.pw>,
        Kazuhito Hagio <k-hagio@ab.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 049/309] mm/sparse.c: reset sections mem_map when fully deactivated
Date:   Mon, 10 Feb 2020 04:30:05 -0800
Message-Id: <20200210122410.721455186@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

commit 1f503443e7df8dc8366608b4d810ce2d6669827c upstream.

After commit ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug"),
when a mem section is fully deactivated, section_mem_map still records
the section's start pfn, which is not used any more and will be
reassigned during re-addition.

In analogy with alloc/free pattern, it is better to clear all fields of
section_mem_map.

Beside this, it breaks the user space tool "makedumpfile" [1], which
makes assumption that a hot-removed section has mem_map as NULL, instead
of checking directly against SECTION_MARKED_PRESENT bit.  (makedumpfile
will be better to change the assumption, and need a patch)

The bug can be reproduced on IBM POWERVM by "drmgr -c mem -r -q 5" ,
trigger a crash, and save vmcore by makedumpfile

[1]: makedumpfile, commit e73016540293 ("[v1.6.7] Update version")

Link: http://lkml.kernel.org/r/1579487594-28889-1-git-send-email-kernelfans@gmail.com
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Kazuhito Hagio <k-hagio@ab.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -787,7 +787,7 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		ms->section_mem_map = sparse_encode_mem_map(NULL, section_nr);
+		ms->section_mem_map = (unsigned long)NULL;
 	}
 
 	if (section_is_early && memmap)


