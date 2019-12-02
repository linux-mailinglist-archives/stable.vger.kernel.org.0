Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF510EAD1
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 14:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfLBNc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 08:32:29 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35446 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbfLBNc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 08:32:28 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id B11C128F684;
        Mon,  2 Dec 2019 13:32:27 +0000 (GMT)
Date:   Mon, 2 Dec 2019 14:32:24 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 8/8] drm/panfrost: Make sure the shrinker does not
 reclaim referenced BOs
Message-ID: <20191202143224.445ad75d@collabora.com>
In-Reply-To: <7258aca4-115d-d511-4c0a-fb3ba142f382@arm.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
        <20191129135908.2439529-9-boris.brezillon@collabora.com>
        <7258aca4-115d-d511-4c0a-fb3ba142f382@arm.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2 Dec 2019 12:50:20 +0000
Robin Murphy <robin.murphy@arm.com> wrote:

> On 29/11/2019 1:59 pm, Boris Brezillon wrote:
> > Userspace might tag a BO purgeable while it's still referenced by GPU
> > jobs. We need to make sure the shrinker does not purge such BOs until
> > all jobs referencing it are finished.  
> 
> Nit: for extra robustness, perhaps it's worth using the refcount_t API 
> rather than bare atomic_t?

I considered doing that. The problem is, we start counting from 0, not
1, and the refcount API assumes counters start at 0, and should never
see a 0 -> 1 transition. I guess we could do

	if (refcount_inc_not_zero()) {
		...
	} else {
		refcount_set(1);
		...
	}

so we at least get the integer overflow/underflow protection.

Anyway, I'm reworking the gem_shmem code so we can refcount the sgt
users (I actually re-use the page_use_count counter and turn into a
refcount_t so we don't need to take the lock if it's > 0). With this
change I think I won't need the gpu_usecount.

