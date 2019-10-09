Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD740CFF1B
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 18:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfJHQn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 12:43:28 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:8260 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbfJHQn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 12:43:28 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 8 Oct 2019 09:43:23 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 1624D40C43;
        Tue,  8 Oct 2019 09:43:20 -0700 (PDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <punit.agrawal@arm.com>,
        <akpm@linux-foundation.org>, <kirill.shutemov@linux.intel.com>,
        <willy@infradead.org>, <will.deacon@arm.com>,
        <mszeredi@redhat.com>, <stable@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <amakhalov@vmware.com>, <srinidhir@vmware.com>,
        <bvikas@vmware.com>, <anishs@vmware.com>, <vsirnapalli@vmware.com>,
        <srostedt@vmware.com>, <akaher@vmware.com>
Subject: [PATCH v2 0/8] Backported fixes for 4.4 stable tree
Date:   Wed, 9 Oct 2019 06:14:15 +0530
Message-ID: <1570581863-12090-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches include few backported fixes for the 4.4 stable
tree.
I would appreciate if you could kindly consider including them in the
next release.

Ajay

---

[Changes from v1]: No changes, only answering Greg's below queries:

>> Why are these needed?  From what I remember, the last patch here is only
>> needed for machines that are "HUGE" and for those, you shouldn't be
>> using 4.4.y anymore anyway, right?  You just end up saving so much more
>> speed and energy using a newer kernel, why would you want to waste it
>> using an older one?
>>
>> So I need a really good reason why to accept these :)
>
> It's been a week, so I'm dropping this from my queue now.  Please resend
> with this information if you still want these in the tree.

> thanks,
> greg k-h

Indeed, the machine needs to have about 140 GB of RAM to exploit
this vulnerability (CVE-2019-11487). However, Photon OS doesn't
impose any limits on the amount of RAM that it supports, so we would
like to safeguard the kernel against this CVE. Also, while newer
versions of Photon OS are on more recent kernels, Photon OS 1.0 uses
the 4.4 stable series, so it would be great to get these patches
included in an upcoming 4.4 stable release.
    
We would also like to have the following patches that are for machines
that are huge:
    
Patch 1: Introduced page_ref_zero_or_close_to_overflow() which helps to
check for small underflows (or _very_ close to overflowing), and ignore
overflows which have strayed into negative territory.
And this is being used inside get_page() and get_page_foll() to reduce the
possibility of overflowing.  
    
Patch 6: Attacker could do direct IO on a page multiple times to trigger 
an overflowing. This patch makes get_user_pages() refuse to if there is
an overflow.
    
Patch 8: This removes another mechanism for overflowing the page refcount
inside pipe_buf_get().
    
---

[PATCH v2 1/8]:
Backporting of upstream commit f958d7b528b1:
mm: make page ref count overflow check tighter and more explicit

[PATCH v2 2/8]:
Backporting of upstream commit 88b1a17dfc3e:
mm: add 'try_get_page()' helper function

[PATCH v2 3/8]:
Backporting of upstream commit 7aef4172c795:
mm: handle PTE-mapped tail pages in gerneric fast gup implementaiton

[PATCH v2 4/8]:
Backporting of upstream commit a3e328556d41:
mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

[PATCH v2 5/8]:
Backporting of upstream commit d63206ee32b6:
mm, gup: ensure real head page is ref-counted when using hugepages

[PATCH v2 6/8]:
Backporting of upstream commit 8fde12ca79af:
mm: prevent get_user_pages() from overflowing page refcount

[PATCH v2 7/8]:
Backporting of upstream commit 7bf2d1df8082:
pipe: add pipe_buf_get() helper

[PATCH v2 8/8]:
Backporting of upstream commit 15fab63e1e57:
fs: prevent page refcount overflow in pipe_buf_get

