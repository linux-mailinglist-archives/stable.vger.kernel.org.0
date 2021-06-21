Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35CE3AEB4D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 16:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFUOcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 10:32:12 -0400
Received: from foss.arm.com ([217.140.110.172]:35508 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230061AbhFUOcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 10:32:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F401D6E;
        Mon, 21 Jun 2021 07:29:58 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C615F3F694;
        Mon, 21 Jun 2021 07:29:56 -0700 (PDT)
Subject: Re: [PATCH v2 01/12] drm/panfrost: Make sure MMU context lifetime is
 not bound to panfrost_priv
To:     Alyssa Rosenzweig <alyssa@collabora.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        dri-devel@lists.freedesktop.org, Icecream95 <ixn@keemail.me>,
        stable@vger.kernel.org
References: <20210621133907.1683899-1-boris.brezillon@collabora.com>
 <20210621133907.1683899-2-boris.brezillon@collabora.com>
 <YNCa46vEbjzWvrLn@maud>
From:   Steven Price <steven.price@arm.com>
Message-ID: <828f1e50-323e-7f67-009f-e465720e303c@arm.com>
Date:   Mon, 21 Jun 2021 15:29:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YNCa46vEbjzWvrLn@maud>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/06/2021 14:57, Alyssa Rosenzweig wrote:
>> Jobs can be in-flight when the file descriptor is closed (either because
>> the process did not terminate properly, or because it didn't wait for
>> all GPU jobs to be finished), and apparently panfrost_job_close() does
>> not cancel already running jobs. Let's refcount the MMU context object
>> so it's lifetime is no longer bound to the FD lifetime and running jobs
>> can finish properly without generating spurious page faults.
> 
> Remind me - why can't we hard stop in-flight jobs when the fd is closed?
> I've seen cases where kill -9'ing a badly behaved process doesn't end
> the fault storm, or unfreeze the desktop.
> 

Hard-stopping the in-flight jobs would also make sense. But unless we
want to actually hang the close() then there will be a period between
issuing the hard-stop and actually having completed all jobs in the context.

But equally to be fair I've been cherry-picking this patch myself for
quite some time, so we should just merge it and improve from there. So
you can have my:

Reviewed-by: Steven Price <steven.price@arm.com>
