Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C709E406D
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 01:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfJXXyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 19:54:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfJXXyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 19:54:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30898206DD;
        Thu, 24 Oct 2019 23:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571961288;
        bh=4E5oeQq3a6UfLqEybmggWpduoHMz222Y7XkVnyUVWzA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YrS7DlIVvCupAZPx2P9DvuW7Ea9WCgyXa++6qnz9EFPVsICN7XFAdauXW8QUBpTuo
         qpKXS/XEqrMWPNgcVEi6Ae3udOjSitcHYgF0eKMfdDPIgQSzhPlZby4XfdWpUf7Uh1
         2TgWzfBgQdhB4340SIMq7RUk2WQZ0r1xgD5vpfzw=
Date:   Thu, 24 Oct 2019 19:54:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     zhong jiang <zhongjiang@huawei.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        linux-mm@kvack.org
Subject: Re: [RPF STABLE PATCH] mm/memfd: should be lock the radix_tree when
 iterating its slot
Message-ID: <20191024235447.GD31224@sasha-vm>
References: <1571929400-12147-1-git-send-email-zhongjiang@huawei.com>
 <20191024174115.GI2963@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191024174115.GI2963@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 10:41:15AM -0700, Matthew Wilcox wrote:
>On Thu, Oct 24, 2019 at 11:03:20PM +0800, zhong jiang wrote:
>> By reviewing the code, I find that there is an race between iterate
>> the radix_tree and radix_tree_insert/delete. Because the former just
>> access its slot in rcu protected period. but it fails to prevent the
>> radix_tree from being changed.
>
>Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>
>The locking here now matches the locking in memfd_tag_pins() that
>was changed in ef3038a573aa8bf2f3797b110f7244b55a0e519c (part of 4.20-rc1).
>I didn't notice that I was fixing a bug when I changed the locking.
>This bug has been present since 05f65b5c70909ef686f865f0a85406d74d75f70f
>(part of 3.17) so backports will need to go further back.  This code has
>moved around a bit (mm/shmem.c) and the APIs have changed, so it will
>take some effort.

I've queued this up for 4.19. Patches for older branches are more than
welcome.

-- 
Thanks,
Sasha
