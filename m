Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B41B9A7E5
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 08:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404704AbfHWG5g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 23 Aug 2019 02:57:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404336AbfHWG5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 02:57:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E00232A09BB;
        Fri, 23 Aug 2019 06:57:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D816D600CD;
        Fri, 23 Aug 2019 06:57:35 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB6702551B;
        Fri, 23 Aug 2019 06:57:35 +0000 (UTC)
Date:   Fri, 23 Aug 2019 02:57:35 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>
Message-ID: <900819847.7915389.1566543455477.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190822233717.GA24034@kroah.com>
References: <cki.A52B1C532D.YEFB2VN58T@redhat.com> <20190822233717.GA24034@kroah.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Stable_queue:_queue-5.2?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.204.212, 10.4.195.29]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Stable queue: queue-5.2
Thread-Index: U3MQvafBGRDex3jLm/ZeKTGgWTXfhg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 23 Aug 2019 06:57:35 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> On Thu, Aug 22, 2019 at 06:48:50PM -0400, CKI Project wrote:
> > 
> > Hello,
> > 
> > We ran automated tests on a patchset that was proposed for merging into
> > this
> > kernel tree. The patches were applied to:
> > 
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: aad39e30fb9e - Linux 5.2.9
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download
> > here:
> > 
> >   https://artifacts.cki-project.org/pipelines/116984
> > 
> > 
> > 
> > One or more kernel tests failed:
> > 
> >   aarch64:
> >     ❌ LTP lite
> >     ❌ Loopdev Sanity
> 
> Odd, what suddenly broke?  No new patches had been added to the queue
> since Tuesday, except I removed a single patch.  Removing a patch
> shouldn't break anything, right?

It's a race:
  [ 1289.578972] LTP: starting mtest06 (  mmap1) 
  ...
  [ 1455.794564] kernel BUG at mm/filemap.c:171! 

Here's a verbose description:
  https://lore.kernel.org/lkml/50b8914e20d1d62bb2dee42d342836c2c16ebee7.1563438048.git.jstancek@redhat.com/

Final (less verbose) patch:
  e1b98fa31664 ("locking/rwsem: Add missing ACQUIRE to read_slowpath exit when queue is empty")

Code review found also this issue, which is theoretical and very unlikely, but it's a small patch:
  99143f82a255 ("lcoking/rwsem: Add missing ACQUIRE to read_slowpath sleep loop")

Regards,
Jan
