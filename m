Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A139BD7D0
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 07:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404497AbfIYFkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 01:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404361AbfIYFkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 01:40:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFD021D7C;
        Wed, 25 Sep 2019 05:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569390054;
        bh=0tqAfD6FQ5W1loZDV2vAy3YrFX1Q+XsOKeCKol0gfCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZmhKboWH1UxIDNzRV8hayCCN304Lyk3lGDe19y3M6Pp3vLKKTXAW0Xwglo/kv2jJ
         68DgEIzzcpuMsAOHqMO0a0zCifGzQq/5oZspNlg2S6t+FhpBSAk3/m1QkdI1FVZP7p
         Siy2LZPQFGZU6I5SN7VfH2wLTHXnY22u0I0Py+Ic=
Date:   Wed, 25 Sep 2019 07:40:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     songliubraving@fb.com, linux-raid@vger.kernel.org, neilb@suse.de,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] md: no longer compare spare disk superblock events in
 super_load
Message-ID: <20190925054051.GA1436542@kroah.com>
References: <20190925055449.30091-1-yuyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925055449.30091-1-yuyufen@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 01:54:49PM +0800, Yufen Yu wrote:
> We have a test case as follow:
> 
>   mdadm -CR /dev/md1 -l 1 -n 4 /dev/sd[a-d] --assume-clean --bitmap=internal
>   mdadm -S /dev/md1
>   mdadm -A /dev/md1 /dev/sd[b-c] --run --force
> 
>   mdadm --zero /dev/sda
>   mdadm /dev/md1 -a /dev/sda
> 
>   echo offline > /sys/block/sdc/device/state
>   echo offline > /sys/block/sdb/device/state
>   sleep 5
>   mdadm -S /dev/md1
> 
>   echo running > /sys/block/sdb/device/state
>   echo running > /sys/block/sdc/device/state
>   mdadm -A /dev/md1 /dev/sd[a-c] --run --force
> 
> When we readd /dev/sda to the array, it started to do recovery.
> After offline the other two disks in md1, the recovery have
> been interrupted and superblock update info cannot be written
> to the offline disks. While the spare disk (/dev/sda) can continue
> to update superblock info.
> 
> After stopping the array and assemble it, we found the array
> run fail, with the follow kernel message:
> 
> [  172.986064] md: kicking non-fresh sdb from array!
> [  173.004210] md: kicking non-fresh sdc from array!
> [  173.022383] md/raid1:md1: active with 0 out of 4 mirrors
> [  173.022406] md1: failed to create bitmap (-5)
> [  173.023466] md: md1 stopped.
> 
> Since both sdb and sdc have the value of 'sb->events' smaller than
> that in sda, they have been kicked from the array. However, the only
> remained disk sda is in 'spare' state before stop and it cannot be
> added to conf->mirrors[] array. In the end, raid array assemble and run fail.
> 
> In fact, we can use the older disk sdb or sdc to assemble the array.
> That means we should not choose the 'spare' disk as the fresh disk in
> analyze_sbs().
> 
> To fix the problem, we do not compare superblock events when it is
> a spare disk, as same as validate_super.
> 
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> 
> v1->v2:
>   fix wrong return value in super_90_load
> ---
>  drivers/md/md.c | 44 ++++++++++++++++++++++++--------------------
>  1 file changed, 24 insertions(+), 20 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
