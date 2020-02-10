Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83F815786D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgBJNHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgBJMjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:40 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E342051A;
        Mon, 10 Feb 2020 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338378;
        bh=Iaomh9OrMmWwgmV3r5KWLTmAR3fNuUtA1Fh7Wys/DQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BC8CDaAY8P1OdQuXXiR3Hmpt+NtUDxIDofxD/tuz5OD0b1v9No5mIxmQZwrXemx6i
         bIPvbKehwh1MKzwAJhJDa+vlxFV1l9ZeF+rxPJb5vJrmxSyf51Ewru8aGSV35VB/FU
         UEoHrHJj7GDH79zX/4XWnFSUx5zBq+fm8i0J4lb0=
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
Subject: [PATCH 5.5 055/367] mm/sparse.c: reset sections mem_map when fully deactivated
Date:   Mon, 10 Feb 2020 04:29:28 -0800
Message-Id: <20200210122429.133079039@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -789,7 +789,7 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		ms->section_mem_map = sparse_encode_mem_map(NULL, section_nr);
+		ms->section_mem_map = (unsigned long)NULL;
 	}
 
 	if (section_is_early && memmap)


