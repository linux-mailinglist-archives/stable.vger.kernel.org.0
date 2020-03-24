Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0961910D6
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgCXNT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgCXNTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B58D20870;
        Tue, 24 Mar 2020 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055992;
        bh=cvGcIc2c7FEbl/5gIogoRTLaX9Jd2iA3AwynJj81h5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVDxCchVAExufYKo118WBKAgEBZUY1KeO4UOIEVir+DvQ8lNRwPCZnyqaOI/IQ+TW
         5WoMeU1D7XHbkRiooGsRCF168QZx7gTReEC5nLi8KjIYJhl1InNpQCa70P/ezs/drS
         2hyFonaLCvosJlggnn13PCZ0AzYVjvGARwk1Svfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 092/102] page-flags: fix a crash at SetPageError(THP_SWAP)
Date:   Tue, 24 Mar 2020 14:11:24 +0100
Message-Id: <20200324130816.171850987@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit d72520ad004a8ce18a6ba6cde317f0081b27365a upstream.

Commit bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped
out") supported writing THP to a swap device but forgot to upgrade an
older commit df8c94d13c7e ("page-flags: define behavior of FS/IO-related
flags on compound pages") which could trigger a crash during THP
swapping out with DEBUG_VM_PGFLAGS=y,

  kernel BUG at include/linux/page-flags.h:317!

  page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
  page:fffff3b2ec3a8000 refcount:512 mapcount:0 mapping:000000009eb0338c index:0x7f6e58200 head:fffff3b2ec3a8000 order:9 compound_mapcount:0 compound_pincount:0
  anon flags: 0x45fffe0000d8454(uptodate|lru|workingset|owner_priv_1|writeback|head|reclaim|swapbacked)

  end_swap_bio_write()
    SetPageError(page)
      VM_BUG_ON_PAGE(1 && PageCompound(page))

  <IRQ>
  bio_endio+0x297/0x560
  dec_pending+0x218/0x430 [dm_mod]
  clone_endio+0xe4/0x2c0 [dm_mod]
  bio_endio+0x297/0x560
  blk_update_request+0x201/0x920
  scsi_end_request+0x6b/0x4b0
  scsi_io_completion+0x509/0x7e0
  scsi_finish_command+0x1ed/0x2a0
  scsi_softirq_done+0x1c9/0x1d0
  __blk_mqnterrupt+0xf/0x20
  </IRQ>

Fix by checking PF_NO_TAIL in those places instead.

Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200310235846.1319-1-cai@lca.pw
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -311,7 +311,7 @@ static inline int TestClearPage##uname(s
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
 PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD) __CLEARPAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
-PAGEFLAG(Error, error, PF_NO_COMPOUND) TESTCLEARFLAG(Error, error, PF_NO_COMPOUND)
+PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
 PAGEFLAG(Referenced, referenced, PF_HEAD)
 	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
 	__SETPAGEFLAG(Referenced, referenced, PF_HEAD)


