Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30043493EC3
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 18:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356304AbiASRFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 12:05:01 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:12834 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356299AbiASRFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 12:05:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1642611901; x=1674147901;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=wNvxhWN+s72+gYCkF7CK/B4m+DlwHrxIAxTnWyHbsW0=;
  b=W4b2dFU/+CWZedFyLxjZ8YiCJtEu8dCrsO1+KV+m+cCCeGarApfpuzfS
   6WaUG6Nt0pjqFIY+HnAKWqT8Xg8oHL8jA612icEFEb4FAG5QhlmGyoMDC
   c8tijqtQZd4qu06yrgzP3o+GHxuHvqO0eVW9qZQpNrLH5vsmsuLGGSCRe
   Y=;
X-IronPort-AV: E=Sophos;i="5.88,299,1635206400"; 
   d="scan'208";a="985810275"
Subject: Re: [PATCH 4.14 1/2] fuse: fix bad inode
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 19 Jan 2022 17:04:37 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id 53C1FA2780;
        Wed, 19 Jan 2022 17:04:37 +0000 (UTC)
Received: from EX13D01UWA003.ant.amazon.com (10.43.160.107) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Wed, 19 Jan 2022 17:04:37 +0000
Received: from localhost (10.43.160.93) by EX13d01UWA003.ant.amazon.com
 (10.43.160.107) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Wed, 19 Jan
 2022 17:04:36 +0000
Date:   Wed, 19 Jan 2022 09:04:36 -0800
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Miklos Szeredi <mszeredi@redhat.com>,
        "Amir Goldstein" <amir73il@gmail.com>
Message-ID: <20220119170436.2lhqyx66nwvaovov@u46989501580c5c.ant.amazon.com>
References: <20220119005201.130738-1-samjonas@amazon.com>
 <Yef4Ejks7hTSgl6C@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yef4Ejks7hTSgl6C@kroah.com>
X-Originating-IP: [10.43.160.93]
X-ClientProxiedBy: EX13D22UWC002.ant.amazon.com (10.43.162.29) To
 EX13d01UWA003.ant.amazon.com (10.43.160.107)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 12:37:54PM +0100, Greg KH wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Tue, Jan 18, 2022 at 04:52:00PM -0800, Samuel Mendoza-Jonas wrote:
> > From: Miklos Szeredi <mszeredi@redhat.com>
> >
> > commit 5d069dbe8aaf2a197142558b6fb2978189ba3454 upstream.
> >
> > Jan Kara's analysis of the syzbot report (edited):
> >
> >   The reproducer opens a directory on FUSE filesystem, it then attaches
> >   dnotify mark to the open directory.  After that a fuse_do_getattr() call
> >   finds that attributes returned by the server are inconsistent, and calls
> >   make_bad_inode() which, among other things does:
> >
> >           inode->i_mode = S_IFREG;
> >
> >   This then confuses dnotify which doesn't tear down its structures
> >   properly and eventually crashes.
> >
> > Avoid calling make_bad_inode() on a live inode: switch to a private flag on
> > the fuse inode.  Also add the test to ops which the bad_inode_ops would
> > have caught.
> >
> > This bug goes back to the initial merge of fuse in 2.6.14...
> >
> > Reported-by: syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > Tested-by: Jan Kara <jack@suse.cz>
> > Cc: <stable@vger.kernel.org>
> > [adjusted for missing fs/fuse/readdir.c and changes in fuse_evict_inode() in 4.14]
> > Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> 
> What about 4.19.y, will this work there as well?  We need it for that
> kernel before we can take it into 4.14.y.
> 
> Also what about 4.4.y and 4.9.y?

Hi,

This applies & builds on 4.19.y and 4.9.y fine as well, 4.4.y runs into
a conflict which I'll have a closer look at.

Cheers,
Sam

> 
> thanks,
> 
> greg k-h
