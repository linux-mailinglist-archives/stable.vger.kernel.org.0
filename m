Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19582EA936
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbhAEKwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:52:17 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:4438 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbhAEKwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609843937; x=1641379937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=VTy5ZAV4gN8Vc803pdXcbifQcOM+i5GU7QrT5KV5nQk=;
  b=Yyo76unenFE0kkpXL+lGusJTlOLeWvlXrXS4cZTyXkygxZTqT1mxdf1c
   fTPz5JyDzlB5zLEzS5TIgpMcwVwPFoLcTmhSIrn+0+2T4Ml4IQ4NkDw2c
   AjC5NQUFv/QB3tEhOROtp7qDDpPCnqHxbk+K1jLIi/t+QKTY/8qJaTIXH
   E=;
X-IronPort-AV: E=Sophos;i="5.78,476,1599523200"; 
   d="scan'208";a="108306680"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 Jan 2021 10:51:30 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 11F1CA065D;
        Tue,  5 Jan 2021 10:51:29 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.161.68) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 Jan 2021 10:51:22 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>, <stable@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] Backport of patch series for stable 4.4 branch
Date:   Tue, 5 Jan 2021 11:51:07 +0100
Message-ID: <20210105105107.3564-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <X/RC3ghc7u4uPIjT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.68]
X-ClientProxiedBy: EX13D22UWB003.ant.amazon.com (10.43.161.76) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Jan 2021 11:43:42 +0100 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Jan 05, 2021 at 11:37:02AM +0100, SeongJae Park wrote:
> > Hi Greg,
> > 
> > On Mon, 28 Dec 2020 12:29:11 +0100 Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Thu, Dec 17, 2020 at 05:03:57PM +0100, SeongJae Park wrote:
> > > > From: SeongJae Park <sjpark@amazon.de>
> > > > 
> > > > Changes from v2
> > > > (https://lore.kernel.org/stable/20201217130501.12702-1-sjpark@amazon.com/)
> > > > - Move 'nr_pending' increase from 5th patch to 4th patch
> > > > 
> > > > Changes from v1
> > > > (https://lore.kernel.org/stable/20201217081727.8253-1-sjpark@amazon.com/)
> > > > - Remove wrong 'Signed-off-by' lines for 'Author Redacted'
> > > 
> > > All now queued up, but you also need a series of this for the 4.9.y tree
> > > as well.
> > 
> > Thank you for your efforts!
> > 
> > However, I was able to cherry-pick this series, which is already merged in
> > 4.4.y, to 4.9.y without conflicts.
> > 
> >     $ git checkout stable/linux-4.9.y -b xsa349_4.9
> >     $ git cherry-pick d8b0d52e408ca..3c71d2f637c8
> >     warning: inexact rename detection was skipped due to too many files.
> >     warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
> >     [xsa349_4.9 51b4cb3db28a] xen/xenbus: Allow watches discard events before queueing
> >      Date: Mon Dec 14 10:02:45 2020 +0100
> >      4 files changed, 16 insertions(+), 1 deletion(-)
> >     warning: inexact rename detection was skipped due to too many files.
> >     warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
> >     [xsa349_4.9 3242225d9645] xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
> >      Date: Mon Dec 14 10:04:18 2020 +0100
> >      6 files changed, 17 insertions(+), 7 deletions(-)
> >     warning: inexact rename detection was skipped due to too many files.
> >     warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
> >     [xsa349_4.9 10d6c1301412] xen/xenbus/xen_bus_type: Support will_handle watch callback
> >      Date: Mon Dec 14 10:05:47 2020 +0100
> >      2 files changed, 4 insertions(+), 1 deletion(-)
> >     warning: inexact rename detection was skipped due to too many files.
> >     warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
> >     [xsa349_4.9 3875703f1e6b] xen/xenbus: Count pending messages for each watch
> >      Date: Mon Dec 14 10:07:13 2020 +0100
> >      2 files changed, 21 insertions(+), 12 deletions(-)
> >     warning: inexact rename detection was skipped due to too many files.
> >     warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
> >     [xsa349_4.9 40e3b315cd18] xenbus/xenbus_backend: Disallow pending watch messages
> >      Date: Mon Dec 14 10:08:40 2020 +0100
> >      1 file changed, 7 insertions(+)
> > 
> > Seems you tried to merge the series for upstream in 4.9.y:
> > 
> >     https://lore.kernel.org/stable/1609154834239118@kroah.com/
> > 
> > This must because I didn't test this series with v4.9 and mention it.  Sorry
> > for making a confusion.  Could you please check this again?
> 
> I can't do anything with a set of git cherry-picks like above, can you
> please send the patches as a series so that I can apply them cleanly?

Sure, I will post it soon.

> 
> And I don't remember what happened with that failure, sorry, dealing
> with hundreds of patches a week makes them all blur together...

I understand.  No problem at all.


Thanks,
SeongJae Park
