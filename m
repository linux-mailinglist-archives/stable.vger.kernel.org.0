Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D197CE3BA
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 15:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfJGN3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 09:29:52 -0400
Received: from know-smtprelay-omc-4.server.virginmedia.net ([80.0.253.68]:51755
        "EHLO know-smtprelay-omc-4.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbfJGN3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 09:29:52 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2019 09:29:50 EDT
Received: from mail0.xen.dingwall.me.uk ([82.47.84.47])
        by cmsmtp with ESMTPA
        id HSzli2qKKikXKHSzli2z4j; Mon, 07 Oct 2019 14:24:14 +0100
X-Originating-IP: [82.47.84.47]
X-Authenticated-User: james.dingwall@blueyonder.co.uk
X-Spam: 0
X-Authority: v=2.3 cv=JpzfUvwC c=1 sm=1 tr=0 a=0bfgdX8EJi0Cr9X0x0jFDA==:117
 a=0bfgdX8EJi0Cr9X0x0jFDA==:17 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10 a=XobE76Q3jBoA:10 a=5IRWAbXhAAAA:8
 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8 a=yPCof4ZbAAAA:8 a=8Yx54hmJfqv9zaizVboA:9
 a=NA0mioxrYjfIsyVE:21 a=yyYMGV6NDAEi3BFP:21 a=CjuIK1q_8ugA:10
 a=xo7gz2vLY8DhO4BdlxfM:22 a=AjGcO6oz07-iQ99wixmX:22 a=WzC6qhA0u3u7Ye7llzcV:22
Received: from localhost (localhost [IPv6:::1])
        by mail0.xen.dingwall.me.uk (Postfix) with ESMTP id ED85511B8E9;
        Mon,  7 Oct 2019 13:24:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at dingwall.me.uk
Received: from mail0.xen.dingwall.me.uk ([IPv6:::1])
        by localhost (mail0.xen.dingwall.me.uk [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id GHLMn-0h2pRW; Mon,  7 Oct 2019 13:24:12 +0000 (UTC)
Received: from behemoth.dingwall.me.uk (behemoth.dingwall.me.uk [IPv6:2001:470:695c:302::c0a8:105])
        by dingwall.me.uk (Postfix) with ESMTP id A18BE11B8E6;
        Mon,  7 Oct 2019 13:24:12 +0000 (UTC)
Received: by behemoth.dingwall.me.uk (Postfix, from userid 1000)
        id 821AD107673; Mon,  7 Oct 2019 13:24:12 +0000 (UTC)
Date:   Mon, 7 Oct 2019 13:24:12 +0000
From:   James Dingwall <james@dingwall.me.uk>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen/xenbus: fix self-deadlock after killing user process
Message-ID: <20191007132412.GA27773@dingwall.me.uk>
References: <20191001150355.25365-1-jgross@suse.com>
 <547479f7-bbb3-609c-fcc7-4e2e609823ae@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547479f7-bbb3-609c-fcc7-4e2e609823ae@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-CMAE-Envelope: MS4wfIW4I2E6zkZiCpUZ/S++fnzYeMMvjbPi6fGFkK6rapdFbM9gdoLT5/gBGyVI0nLCPpuIS1EWXnWGEK9ohK85n8r6/YHwXApZFYAhqkCEQCWPhPiuMCAN
 GsaxkL3utAI5Leyjbfkc9u4c8PTx3F0se5gXKJi4WC6J7G1/V2odnrG286MMHIWHDLv3GWTlVjq19j4LIELouDgy49UiZCObAu6etPwa/clnf2ECtyHQiHGl
 MpSeu6ptLegHZP457w/haphrNUeOY2x7ulIuCnLRIA5ojWeUYaKYCVoHO4mcvksI7G4rzIPoGaQ66Mw/hic5UUs4A6ihH+guhJSOTAHJc0Y=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 01:37:24PM -0400, Boris Ostrovsky wrote:
> On 10/1/19 11:03 AM, Juergen Gross wrote:
> > In case a user process using xenbus has open transactions and is killed
> > e.g. via ctrl-C the following cleanup of the allocated resources might
> > result in a deadlock due to trying to end a transaction in the xenbus
> > worker thread:
> >
> > [ 2551.474706] INFO: task xenbus:37 blocked for more than 120 seconds.
> > [ 2551.492215]       Tainted: P           OE     5.0.0-29-generic #5
> > [ 2551.510263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [ 2551.528585] xenbus          D    0    37      2 0x80000080
> > [ 2551.528590] Call Trace:
> > [ 2551.528603]  __schedule+0x2c0/0x870
> > [ 2551.528606]  ? _cond_resched+0x19/0x40
> > [ 2551.528632]  schedule+0x2c/0x70
> > [ 2551.528637]  xs_talkv+0x1ec/0x2b0
> > [ 2551.528642]  ? wait_woken+0x80/0x80
> > [ 2551.528645]  xs_single+0x53/0x80
> > [ 2551.528648]  xenbus_transaction_end+0x3b/0x70
> > [ 2551.528651]  xenbus_file_free+0x5a/0x160
> > [ 2551.528654]  xenbus_dev_queue_reply+0xc4/0x220
> > [ 2551.528657]  xenbus_thread+0x7de/0x880
> > [ 2551.528660]  ? wait_woken+0x80/0x80
> > [ 2551.528665]  kthread+0x121/0x140
> > [ 2551.528667]  ? xb_read+0x1d0/0x1d0
> > [ 2551.528670]  ? kthread_park+0x90/0x90
> > [ 2551.528673]  ret_from_fork+0x35/0x40
> >
> > Fix this by doing the cleanup via a workqueue instead.
> >
> > Reported-by: James Dingwall <james@dingwall.me.uk>
> > Fixes: fd8aa9095a95c ("xen: optimize xenbus driver for multiple concurrent xenstore accesses")
> > Cc: <stable@vger.kernel.org> # 4.11
> > Signed-off-by: Juergen Gross <jgross@suse.com>
> 
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> 

Tested-by: James Dingwall <james@dingwall.me.uk>

This patch does resolve the observed issue although for my (extreme and 
not representative of our normal workload) test case the worker still 
gets blocked for some time if the xenstore-rm is interrupted and no 
concurrent xenstore commands can run.  I assume that the worker 
completes the rm and then does a rollback in the background rather than 
being interrupted early as a result of the userspace program being 
terminated.

Thanks,
James
