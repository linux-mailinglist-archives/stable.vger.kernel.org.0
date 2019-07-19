Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2C56EC2C
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 23:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfGSVnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 17:43:20 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:37241 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728564AbfGSVnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 17:43:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=bo.liu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0TXJI3wZ_1563572595;
Received: from US-160370MP2.local(mailfrom:bo.liu@linux.alibaba.com fp:SMTPD_---0TXJI3wZ_1563572595)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Jul 2019 05:43:18 +0800
Date:   Fri, 19 Jul 2019 14:43:15 -0700
From:   Liu Bo <bo.liu@linux.alibaba.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
        Peng Tao <tao.peng@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] mm: fix livelock caused by iterating multi order entry
Message-ID: <20190719214314.26ftdpdyf4tixxca@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1563495160-25647-1-git-send-email-bo.liu@linux.alibaba.com>
 <CAPcyv4jR3vscppooTFBEU=Kp4CNVfthNNz1pV6jxwyg2bmdBjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jR3vscppooTFBEU=Kp4CNVfthNNz1pV6jxwyg2bmdBjg@mail.gmail.com>
User-Agent: NeoMutt/20180323
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 07:53:42PM -0700, Dan Williams wrote:
> [ add Sasha for -stable advice ]
> 
> On Thu, Jul 18, 2019 at 5:13 PM Liu Bo <bo.liu@linux.alibaba.com> wrote:
> >
> > The livelock can be triggerred in the following pattern,
> >
> >         while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
> >                                 min(end - index, (pgoff_t)PAGEVEC_SIZE),
> >                                 indices)) {
> >                 ...
> >                 for (i = 0; i < pagevec_count(&pvec); i++) {
> >                         index = indices[i];
> >                         ...
> >                 }
> >                 index++; /* BUG */
> >         }
> >
> > multi order exceptional entry is not specially considered in
> > invalidate_inode_pages2_range() and it ended up with a livelock because
> > both index 0 and index 1 finds the same pmd, but this pmd is binded to
> > index 0, so index is set to 0 again.
> >
> > This introduces a helper to take the pmd entry's length into account when
> > deciding the next index.
> >
> > Note that there're other users of the above pattern which doesn't need to
> > fix,
> >
> > - dax_layout_busy_page
> > It's been fixed in commit d7782145e1ad
> > ("filesystem-dax: Fix dax_layout_busy_page() livelock")
> >
> > - truncate_inode_pages_range
> > This won't loop forever since the exceptional entries are immediately
> > removed from radix tree after the search.
> >
> > Fixes: 642261a ("dax: add struct iomap based DAX PMD support")
> > Cc: <stable@vger.kernel.org> since 4.9 to 4.19
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >
> > The problem is gone after commit f280bf092d48 ("page cache: Convert
> > find_get_entries to XArray"), but since xarray seems too new to backport
> > to 4.19, I made this fix based on radix tree implementation.
> 
> I think in this situation, since mainline does not need this change
> and the bug has been buried under a major refactoring, is to send a
> backport directly against the v4.19 kernel. Include notes about how it
> replaces the fix that was inadvertently contained in f280bf092d48
> ("page cache: Convert find_get_entries to XArray"). Do you have a test
> case that you can include in the changelog?

The root cause behind the bug is exactly same as what commit
d7782145e1ad ("filesystem-dax: Fix dax_layout_busy_page() livelock")
does.

For test case, I have a not 100% reproducible one based on ltp's
rwtest[1] and virtiofs.

[1]:
$mount -t virtio_fs -o tag=alwaysdax -o rootmode=040000,user_id=0,group_id=0,dax,default_permissions,allow_other alwaysdax /mnt/virtio-fs/
$cat test.txt
rwtest01 export LTPROOT; rwtest -N rwtest01 -c -q -i 60s -f sync 10%25000:$TMPDIR/rw-sync-$$
$runltp -d /mnt/virtio-fs -f test.txt

thanks,
-liubo
