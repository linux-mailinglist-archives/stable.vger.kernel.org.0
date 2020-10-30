Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2462A07D7
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 15:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgJ3O3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 10:29:35 -0400
Received: from foss.arm.com ([217.140.110.172]:35924 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgJ3O3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 10:29:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5D45139F;
        Fri, 30 Oct 2020 07:29:34 -0700 (PDT)
Received: from [10.57.54.223] (unknown [10.57.54.223])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE0733F68F;
        Fri, 30 Oct 2020 07:29:33 -0700 (PDT)
Subject: Re: [PATCH v2] drm/panfrost: Move the GPU reset bits outside the
 timeout handler
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20201030105336.764009-1-boris.brezillon@collabora.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <7c840f9f-a6cb-af80-0c21-da5608e00fbb@arm.com>
Date:   Fri, 30 Oct 2020 14:29:32 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030105336.764009-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-10-30 10:53, Boris Brezillon wrote:
[...]
> +	/* Schedule a reset if there's no reset in progress. */
> +	if (!atomic_cmpxchg(&pfdev->reset.pending, 0, 1))

Nit: this could just be a simple xchg with 1 - you don't need the 
compare aspect, since setting it to true when it was already true is 
still harmless ;)

Robin.
