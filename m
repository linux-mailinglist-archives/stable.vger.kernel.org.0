Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5D1406558
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 03:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhIJBos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 21:44:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhIJBor (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 21:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631238217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o7i81vt0ogrQwLehvxvlqLBNWf909L5fVcLE5L9Z+hE=;
        b=Z+Bu9AdnWa1AX9K+ujMJNtVa5vRYt+CN5Oc4BsEAIBSMlauRywX835jx4EDH+VMfo3HoF/
        AU9Uv7daUP8YS8+LRU17GK6Ye08qk+zvsyzzbXn1PCNjer/xpdzJkiK3gKaMqCXDOddAs3
        fQPzeI7NmyxO31Lt2nlVuN0LRr9MRDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-u9DriWUvN8-1w0T8mFFi3Q-1; Thu, 09 Sep 2021 21:43:36 -0400
X-MC-Unique: u9DriWUvN8-1w0T8mFFi3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC74A79EDD;
        Fri, 10 Sep 2021 01:43:34 +0000 (UTC)
Received: from T590 (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B907F6D980;
        Fri, 10 Sep 2021 01:43:24 +0000 (UTC)
Date:   Fri, 10 Sep 2021 09:43:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>,
        linux-block <linux-block@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [bug report] NULL pointer at blk_mq_put_rq_ref+0x20/0xb4
 observed with blktests on 5.13.15
Message-ID: <YTq4QFWexPF9aQvG@T590>
References: <CAHj4cs-noupgFn3QjB96Z20hv-BhFLHOyFZFEtrhGpESkeoRSA@mail.gmail.com>
 <CAFj5m9J4sxRwQb7+nHzYOurX9QRpEgsEMCqdx4SHA4THnsJXBA@mail.gmail.com>
 <YTnc5Ja/DKR30Euy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTnc5Ja/DKR30Euy@kroah.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 12:07:32PM +0200, Greg KH wrote:
> On Thu, Sep 09, 2021 at 05:14:18PM +0800, Ming Lei wrote:
> > On Thu, Sep 9, 2021 at 4:47 PM Yi Zhang <yi.zhang@redhat.com> wrote:
> > >
> > > Hello
> > >
> > > I found this issue with blktests on[1], did we miss some patch on stable?
> > > [1]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > queue/5.13
> > >
> > > [   68.989907] run blktests block/006 at 2021-09-09 04:34:35
> > > [   69.085724] null_blk: module loaded
> > > [   74.271624] Unable to handle kernel NULL pointer dereference at
> > > virtual address 00000000000002b8
> > > [   74.280414] Mem abort info:
> > > [   74.283195]   ESR = 0x96000004
> > > [   74.286245]   EC = 0x25: DABT (current EL), IL = 32 bits
> > > [   74.291545]   SET = 0, FnV = 0
> > > [   74.294587]   EA = 0, S1PTW = 0
> > > [   74.297720] Data abort info:
> > > [   74.300588]   ISV = 0, ISS = 0x00000004
> > > [   74.304411]   CM = 0, WnR = 0
> > > [   74.307368] user pgtable: 4k pages, 48-bit VAs, pgdp=000008004366e000
> > > [   74.313796] [00000000000002b8] pgd=0000000000000000, p4d=0000000000000000
> > > [   74.320577] Internal error: Oops: 96000004 [#1] SMP
> > > [   74.325443] Modules linked in: null_blk mlx5_ib ib_uverbs ib_core
> > > rfkill sunrpc vfat fat joydev acpi_ipmi ipmi_ssif cdc_ether usbnet mii
> > > mlx5_core psample ipmi_devintf mlxfw tls ipmi_msghandler arm_cmn
> > > cppc_cpufreq arm_dsu_pmu acpi_tad fuse zram ip_tables xfs ast
> > > i2c_algo_bit drm_vram_helper drm_kms_helper crct10dif_ce syscopyarea
> > > ghash_ce sysfillrect uas sysimgblt sbsa_gwdt fb_sys_fops cec
> > > drm_ttm_helper ttm nvme usb_storage nvme_core drm xgene_hwmon
> > > aes_neon_bs
> > > [   74.366458] CPU: 31 PID: 2511 Comm: fio Not tainted 5.13.15+ #1
> > 
> > Looks the fixes haven't land on linux-5.13.y:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9ed27a764156929efe714033edb3e9023c5f321
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c2da19ed50554ce52ecbad3655c98371fe58599f
> 
> Now queued up.  Someone could have told us they were needed :)

Thanks for queuing it up, sorry for not Cc stable.

BTW, the following two patches are missed too in linux-5.13-y:

364b61818f65 blk-mq: clearing flush request reference in tags->rqs[]
bd63141d585b blk-mq: clear stale request in tags->rq[] before freeing one request pool

Both can fix request UAF issue.

Thanks, 
Ming

