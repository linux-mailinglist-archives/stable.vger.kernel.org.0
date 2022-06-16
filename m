Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770D554E216
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377078AbiFPNgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376839AbiFPNgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:36:19 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F2724096;
        Thu, 16 Jun 2022 06:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=cyWgBVSU437H0cH5AK9e5im0OrC0JXMOv/o9/Fwf120=; b=mMacv3x8e2S6aOvOI07Vr6PyY5
        Lg1CSP9y4voZOzwtdgVox3avr1sLZ4CKtGFNcLLC2LOHiBxDVB1j8YcER+ZjKs7/PD8MEdgTG2xYF
        1QolQ9/oFemDvDYxDseqySgxCz7b+FVKLSAudaxQokiGtXSZwvZ/4+S4a7svr1ggfQolceWdCgnus
        vWTSaswjJCAEgCfpls5Su27yzQfNZNzP3RHc05EDrh+gBBsBLqN+IcQWV/eXx7SqViyXNuO5lFlXY
        x8nPQr0id7E4lifrISpPz9iEdJAEqRePkJ0P14YKzn0BRwb6jJ4mHn9qiBBocLaOltYHlN7s2kbZG
        dMkVjdyZVoxbyRFrCNiADOluiG6LaWIri3vWAgb6JpVTNOkJ9muM3Q/G7rTLnBZWcsrA1o5Jt5v03
        mK01tooy//VW/wEWrHWIZLjPNmhPdJWNKgCHMqa/zTdJSkmLelZxkU6HYgn+vhHHSFaH9+O/IZfLX
        C7/ApVrcuxhZtjNN89VKruFtROCKmbtqs1QutQry1vUyW4j1R3l+Gf9a3LJqmo8dxWK4NWJpFBaJ7
        8tdiO5RO9bdgejZ6Ywyj75a6+EoZvwLcG0TFTW6TL1x2vmPsmxn/9kO1VTKIHuuQIUNDQ+oIwqp8u
        8yjVwUdA7To1kCuieodJv6yWkPXXA87IhDv+Te1To=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Date:   Thu, 16 Jun 2022 15:35:59 +0200
Message-ID: <22073313.PYDa2UxuuP@silver>
In-Reply-To: <1796737.mFSqR1lx0c@silver>
References: <YqW5s+GQZwZ/DP5q@codewreck.org> <YqiC8luskkxUftQl@codewreck.org>
 <1796737.mFSqR1lx0c@silver>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Dienstag, 14. Juni 2022 16:11:35 CEST Christian Schoenebeck wrote:
> On Dienstag, 14. Juni 2022 14:45:38 CEST Dominique Martinet wrote:
[...]
> > Please let me know how that works out, I'd be happy to use either of
> > your versions instead of mine.
> > If I can be greedy though I'd like to post it together with the other
> > couple of fixes next week, so having something before the end of the
> > week would be great -- I think even my first overkill version early and
> > building on it would make sense at this point.
> > 
> > But I think you've got the right end, so hopefully won't be needing to
> > delay
> 
> I need a day or two for testing, then I will report back for sure. So it
> should perfectly fit into your intended schedule.

Two things:

1. your EBADF patch is based on you recent get/put refactoring patch, so it won't apply on stable.

2. I fixed the conflict and gave your patch a test spin, and it triggers
the BUG_ON(!fid); that you added with that patch. Backtrace based on
30306f6194ca ("Merge tag 'hardening-v5.19-rc3' ..."):

[    2.211473] kernel BUG at fs/9p/vfs_addr.c:65!
...
[    2.244415] netfs_alloc_request (fs/netfs/objects.c:42) netfs
[    2.245438] netfs_readahead (fs/netfs/buffered_read.c:166) netfs
[    2.246392] read_pages (./include/linux/pagemap.h:1264 ./include/linux/pagemap.h:1306 mm/readahead.c:164) 
[    2.247120] ? folio_add_lru (./arch/x86/include/asm/preempt.h:103 mm/swap.c:468) 
[    2.247911] page_cache_ra_unbounded (./include/linux/fs.h:808 mm/readahead.c:264) 
[    2.248875] filemap_get_pages (mm/filemap.c:2594) 
[    2.249723] filemap_read (mm/filemap.c:2679) 
[    2.250478] ? ptep_set_access_flags (./arch/x86/include/asm/paravirt.h:441 arch/x86/mm/pgtable.c:493) 
[    2.251417] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:103 ./include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:186) 
[    2.252253] ? do_wp_page (mm/memory.c:3293 mm/memory.c:3393) 
[    2.253012] ? aa_file_perm (security/apparmor/file.c:604) 
[    2.253824] new_sync_read (fs/read_write.c:402 (discriminator 1)) 
[    2.254616] vfs_read (fs/read_write.c:482) 
[    2.255313] ksys_read (fs/read_write.c:620) 
[    2.256000] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
[    2.256764] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:115)

Did your patch work there for you? I mean I have not applied the other pending
9p patches, but they should not really make difference, right? I won't have
time today, but I will continue to look at it tomorrow. If you already had
some thoughts on this, that would be great of course.

Best regards,
Christian Schoenebeck


