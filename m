Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66D42B82BD
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 18:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgKRRNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 12:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgKRRNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 12:13:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3677A21D7E;
        Wed, 18 Nov 2020 17:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605719613;
        bh=zytBjFH2SuYYq9ueFmUnghxbqFnu7S45ZhSIcILInBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nyd+gCMg87bVUMCM1uDvb6NXhHLs/zGeNm/umWbdMCr6JWAM8rhaUyh+24PCN/mWd
         MRybLIV4eqClWZKRGXGylGq0ArVTB8k+C8ybR2nQ9VzG2o8BoAfQmJxnIcpxmHYTTR
         jYPkJpRxPSPEFeBJpC5wAMCnUmFDmeU2rBiK04uQ=
Date:   Wed, 18 Nov 2020 18:14:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhao Heming <heming.zhao@suse.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com,
        lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] md/cluster: block reshape with remote resync job
Message-ID: <X7VWa+6KnqNq9Ian@kroah.com>
References: <1605717954-20173-1-git-send-email-heming.zhao@suse.com>
 <1605717954-20173-2-git-send-email-heming.zhao@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605717954-20173-2-git-send-email-heming.zhao@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 12:45:53AM +0800, Zhao Heming wrote:
> Reshape request should be blocked with ongoing resync job. In cluster
> env, a node can start resync job even if the resync cmd isn't executed
> on it, e.g., user executes "mdadm --grow" on node A, sometimes node B
> will start resync job. However, current update_raid_disks() only check
> local recovery status, which is incomplete. As a result, we see user will
> execute "mdadm --grow" successfully on local, while the remote node deny
> to do reshape job when it doing resync job. The inconsistent handling
> cause array enter unexpected status. If user doesn't observe this issue
> and continue executing mdadm cmd, the array doesn't work at last.
> 
> Fix this issue by blocking reshape request. When node executes "--grow"
> and detects ongoing resync, it should stop and report error to user.
> 
> The following script reproduces the issue with ~100% probability.
> (two nodes share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB)
> ```
>  # on node1, node2 is the remote node.
> ssh root@node2 "mdadm -S --scan"
> mdadm -S --scan
> for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
> count=20; done
> 
> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh
> ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"
> 
> sleep 5
> 
> mdadm --manage --add /dev/md0 /dev/sdi
> mdadm --wait /dev/md0
> mdadm --grow --raid-devices=3 /dev/md0
> 
> mdadm /dev/md0 --fail /dev/sdg
> mdadm /dev/md0 --remove /dev/sdg
> mdadm --grow --raid-devices=2 /dev/md0
> ```
> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>  drivers/md/md.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
