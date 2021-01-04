Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757292EA06B
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 00:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbhADXHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 18:07:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbhADXHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 18:07:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20B4F207BC;
        Mon,  4 Jan 2021 23:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609801603;
        bh=Sfwx449nsHFdYh7noCwwAejhJk8gHAupfrB4AoBvnj0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n5zc0OnswJ5YIFyS6i16MYGmMcerCOA4njm+GO7KmL6ZVx5qEkHCSAXo48IGadNXf
         zg8AKqF2OAQyOtMl5sO3fDzn+iAHxDJ7wAsQqNJyfRmKbhy76wiHfJRC9G/HYE6tB1
         FCw7LU32ZrVNlJvcbGplSGWeKc65s3MMsnmnp9++5r2kRGPfvjPckQt92WLzdiPJQk
         xXsE5R3gO1Ok5LrSM+XwFdpa8oK0zVrNj+wr42mzL2jpeVhD2TB9d2C1vEAd6f1Z8s
         A7fumhs1WHyNEKDE0psr4UKH8cXifcRQSH8MCKPAZbyeY3qrJBuSr9c29wauNuWGOB
         WsmOAfnTSCNFQ==
Date:   Mon, 4 Jan 2021 15:06:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com,
        Davide Caratti <dcaratti@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH 5.10 01/63] net/sched: sch_taprio: reset child qdiscs
 before freeing them
Message-ID: <20210104150642.23546136@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210104225827.GF3665355@sasha-vm>
References: <20210104155708.800470590@linuxfoundation.org>
        <20210104155708.875695855@linuxfoundation.org>
        <20210104225827.GF3665355@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Jan 2021 17:58:27 -0500 Sasha Levin wrote:
> On Mon, Jan 04, 2021 at 04:56:54PM +0100, Greg Kroah-Hartman wrote:
> >From: Davide Caratti <dcaratti@redhat.com>
> >
> >[ Upstream commit 44d4775ca51805b376a8db5b34f650434a08e556 ]
> >
> >syzkaller shows that packets can still be dequeued while taprio_destroy()
> >is running. Let sch_taprio use the reset() function to cancel the advance
> >timer and drop all skbs from the child qdiscs.
> >
> >Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> >Link: https://syzkaller.appspot.com/bug?id=f362872379bf8f0017fb667c1ab158f2d1e764ae
> >Reported-by: syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com
> >Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> >Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >Link: https://lore.kernel.org/r/63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com
> >Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>  
> 
> I noticed that there's a fix for this patch going through netdev (but
> not yet in Linus's tree). The fix reads to me like it fixes a missed
> corner case by this patch rather than this patch being incorrect, so
> I'll leave this patch in. If anyone disagrees please speak up :)

Right, the other fix is independent, it came up in review and we decided
to address it separately.
