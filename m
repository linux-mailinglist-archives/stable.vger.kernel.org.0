Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B049FC44D8
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 02:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfJBAR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 20:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbfJBAR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 20:17:29 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D550B20815;
        Wed,  2 Oct 2019 00:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569975449;
        bh=OrDxYjzuePo+bgSDlMBbf2dr4fp03Kb0+bL8nImiBy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2sSkuPH7QIhuQ1rlykYEDncpQesvqaTWXlbEHPfQUenzhPcwI8P6QviWBbV3eFTHH
         QyZYD6wQucHaX5qLpY7ACsStakFjxrs3vquXLzbz7V2Qp5GUYoF2SnqGcXhTC1lHLd
         ARVcf21lBCh1IzRL/6bCYC2FfBfxo6V5hwIJ5qQA=
Date:   Tue, 1 Oct 2019 20:17:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v4.19-stable PATCH] ceph: use ceph_evict_inode to cleanup
 inode's resource
Message-ID: <20191002001727.GI17454@sasha-vm>
References: <20191001212425.3085-1-jlayton@kernel.org>
 <20191001212425.3085-2-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191001212425.3085-2-jlayton@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 05:24:25PM -0400, Jeff Layton wrote:
>From: "Yan, Zheng" <zyan@redhat.com>
>
>[ Upstream commit 87bc5b895d94a0f40fe170d4cf5771c8e8f85d15 ]
>
>remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
>freeing inode to remove its caps. But VFS wakes freeing inode waiters
>before calling destroy_inode().
>
>[ jlayton: mainline moved to ->free_inode before the original patch was
>	   merged. This backport reinstates ceph_destroy_inode and just
>	   has it do the call_rcu call. ]
>
>Cc: stable@vger.kernel.org
>Link: https://tracker.ceph.com/issues/40102
>Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>Reviewed-by: Jeff Layton <jlayton@redhat.com>
>Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>Signed-off-by: Sasha Levin <sashal@kernel.org>
>---
> fs/ceph/inode.c | 10 ++++++++--
> fs/ceph/super.c |  1 +
> fs/ceph/super.h |  1 +
> 3 files changed, 10 insertions(+), 2 deletions(-)
>
>Hi Sasha,
>
>Sorry for the resend -- forgot to cc stable@vger on the first one.
>
>This patch should be applied after commit 81281039999 is reverted.
>Sorry for the mixup!

I've queued it up for the next release, thank you!

--
Thanks,
Sasha
