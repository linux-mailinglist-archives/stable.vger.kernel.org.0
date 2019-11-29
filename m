Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753FC10D83F
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 17:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfK2QHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 11:07:38 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37572 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfK2QHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 11:07:38 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 42FE5292AB2;
        Fri, 29 Nov 2019 16:07:37 +0000 (GMT)
Date:   Fri, 29 Nov 2019 17:07:34 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 8/8] drm/panfrost: Make sure the shrinker does not
 reclaim referenced BOs
Message-ID: <20191129170734.50bb02ad@collabora.com>
In-Reply-To: <64a6a09a-e83a-05be-8576-79a74f971286@arm.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
        <20191129135908.2439529-9-boris.brezillon@collabora.com>
        <64a6a09a-e83a-05be-8576-79a74f971286@arm.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Nov 2019 15:48:15 +0000
Steven Price <steven.price@arm.com> wrote:

> On 29/11/2019 13:59, Boris Brezillon wrote:
> > Userspace might tag a BO purgeable while it's still referenced by GPU
> > jobs. We need to make sure the shrinker does not purge such BOs until
> > all jobs referencing it are finished.
> > 
> > Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>  
> 
> I'm happy with this, but I would also argue that it was previously user
> space's job not to mark a BO purgeable while it's in use by the GPU.

I was not aware of this design choice.

> This is in some ways an ABI change so we should be sure this is
> something that we want to support "forever" more.

Well, in that case, the ABI change is bringing extra robustness, with
AFAICT, no downside for those that were taking care of that in
userspace.

> But if Mesa has
> 'always' been assuming this behaviour we might as well match.

I think so, and VC4 seems to have the same expectations.

> 
> Reviewed-by: Steven Price <steven.price@arm.com>

Thanks for the review.
