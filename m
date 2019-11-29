Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D0F10D849
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfK2QMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 11:12:13 -0500
Received: from foss.arm.com ([217.140.110.172]:49788 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfK2QMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 11:12:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E247830E;
        Fri, 29 Nov 2019 08:12:12 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 323A23F68E;
        Fri, 29 Nov 2019 08:12:12 -0800 (PST)
Subject: Re: [PATCH 8/8] drm/panfrost: Make sure the shrinker does not reclaim
 referenced BOs
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Herring <robh+dt@kernel.org>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-9-boris.brezillon@collabora.com>
 <64a6a09a-e83a-05be-8576-79a74f971286@arm.com>
 <20191129170734.50bb02ad@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <7250d8a9-ff65-4e18-cc92-3ef645c3be31@arm.com>
Date:   Fri, 29 Nov 2019 16:12:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129170734.50bb02ad@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/11/2019 16:07, Boris Brezillon wrote:
> On Fri, 29 Nov 2019 15:48:15 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> On 29/11/2019 13:59, Boris Brezillon wrote:
>>> Userspace might tag a BO purgeable while it's still referenced by GPU
>>> jobs. We need to make sure the shrinker does not purge such BOs until
>>> all jobs referencing it are finished.
>>>
>>> Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>  
>>
>> I'm happy with this, but I would also argue that it was previously user
>> space's job not to mark a BO purgeable while it's in use by the GPU.
> 
> I was not aware of this design choice.

When I was maintaining mali_kbase I would have said no to this ;) But
thankfully I've moved on! I'm not sure whether anyone actually made a
design choice for Panfrost here.

>> This is in some ways an ABI change so we should be sure this is
>> something that we want to support "forever" more.
> 
> Well, in that case, the ABI change is bringing extra robustness, with
> AFAICT, no downside for those that were taking care of that in
> userspace.

Yes, there's no downside for user space - this is just giving user space
extra freedom.

>> But if Mesa has
>> 'always' been assuming this behaviour we might as well match.
> 
> I think so, and VC4 seems to have the same expectations.

This seems like enough justification to me.

Steve

>>
>> Reviewed-by: Steven Price <steven.price@arm.com>
> 
> Thanks for the review.
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

