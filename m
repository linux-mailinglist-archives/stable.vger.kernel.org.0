Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B451E74F7
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 16:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbfJ1PWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 11:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbfJ1PWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 11:22:01 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0117921744;
        Mon, 28 Oct 2019 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572276120;
        bh=mZ0qdaqT5jEGWNb/a1QyE1AWCwKJ8E5blPq9MtUyNNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a7kSdNUw6rpalitxTv0Lsmevm5DAnwdOyJE4WT3CNbSoRCClpj1ZrPV7m0+riA91w
         5ev6Z0Gt7A3phFdsLCx1PC/1e2N3k1JoC53qNQghdrkk1X6GF4UOAra/1+AgIzUINn
         kQsBKs9sgU66GHcoK32/LeEqQTBa73MG5sQYt/zg=
Date:   Mon, 28 Oct 2019 11:21:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     wqu@suse.com, dsterba@suse.com, nborisov@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: tracepoints: Fix wrong parameter
 order for qgroup" failed to apply to 4.19-stable tree
Message-ID: <20191028152157.GC1554@sasha-vm>
References: <157219129664247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157219129664247@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 04:48:16PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From fd2b007eaec898564e269d1f478a2da0380ecf51 Mon Sep 17 00:00:00 2001
>From: Qu Wenruo <wqu@suse.com>
>Date: Thu, 17 Oct 2019 10:38:36 +0800
>Subject: [PATCH] btrfs: tracepoints: Fix wrong parameter order for qgroup
> events
>
>[BUG]
>For btrfs:qgroup_meta_reserve event, the trace event can output garbage:
>
>  qgroup_meta_reserve: 9c7f6acc-b342-4037-bc47-7f6e4d2232d7: refroot=5(FS_TREE) type=DATA diff=2
>
>The diff should always be alinged to sector size (4k), so there is
>definitely something wrong.
>
>[CAUSE]
>For the wrong @diff, it's caused by wrong parameter order.
>The correct parameters are:
>
>  struct btrfs_root, s64 diff, int type.
>
>However the parameters used are:
>
>  struct btrfs_root, int type, s64 diff.
>
>Fixes: 4ee0d8832c2e ("btrfs: qgroup: Update trace events for metadata reservation")
>CC: stable@vger.kernel.org # 4.19+
>Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>Signed-off-by: Qu Wenruo <wqu@suse.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

Just needed some love to work around missing 4fd786e6c3d67 ("btrfs:
Remove 'objectid' member from struct btrfs_root"). Queued up for 4.19.

-- 
Thanks,
Sasha
