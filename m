Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41222EA03B
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 23:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADW7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 17:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADW7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 17:59:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B234220784;
        Mon,  4 Jan 2021 22:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609801109;
        bh=McSVoja0FAYaCdm3f5ezz5kbVb5dnoFzHZXUMiu8atE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b5v+cQy7U6BA7piielZd5VBOqth4tomTvnzukdSPjlmQ+dtJh84B2J711LvADEkAa
         bfMZ3/AfXlYniDNz/lgFsUq9PUy22uFMRKaM83AzMIeRR4TBbaNJ4S1hkBOwP7pbsx
         1YAncTFUex3AgHCXBAarND3Oi3558huFcey0X6B6v0cEnXwvahRyZnHlfBHN7nsZ52
         5v40Ph1Ala+HvX/dBux6aow3FPVryt3s6VU3qBK2MD1dHYMJ10TS8Xcc7xRBOw3UnY
         wlkuH+2C2Q4BIR9PQMIMeRSjdRZ4gWcVJNP+Zo1wLzulWmF3ddSHSYbx2gCb6mGkwL
         DwrCNkc0VsFRQ==
Date:   Mon, 4 Jan 2021 17:58:27 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com,
        Davide Caratti <dcaratti@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 01/63] net/sched: sch_taprio: reset child qdiscs
 before freeing them
Message-ID: <20210104225827.GF3665355@sasha-vm>
References: <20210104155708.800470590@linuxfoundation.org>
 <20210104155708.875695855@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210104155708.875695855@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 04:56:54PM +0100, Greg Kroah-Hartman wrote:
>From: Davide Caratti <dcaratti@redhat.com>
>
>[ Upstream commit 44d4775ca51805b376a8db5b34f650434a08e556 ]
>
>syzkaller shows that packets can still be dequeued while taprio_destroy()
>is running. Let sch_taprio use the reset() function to cancel the advance
>timer and drop all skbs from the child qdiscs.
>
>Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
>Link: https://syzkaller.appspot.com/bug?id=f362872379bf8f0017fb667c1ab158f2d1e764ae
>Reported-by: syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com
>Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>Link: https://lore.kernel.org/r/63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I noticed that there's a fix for this patch going through netdev (but
not yet in Linus's tree). The fix reads to me like it fixes a missed
corner case by this patch rather than this patch being incorrect, so
I'll leave this patch in. If anyone disagrees please speak up :)

-- 
Thanks,
Sasha
