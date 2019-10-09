Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A374D0B5C
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfJIJfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfJIJfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 05:35:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E01621835;
        Wed,  9 Oct 2019 09:35:49 +0000 (UTC)
Date:   Wed, 9 Oct 2019 11:35:47 +0200
From:   Greg KH <greg@kroah.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        suzuki.poulose@arm.com, andrew.murray@arm.com
Subject: Re: [PATCH] coresight: etm4x: Use explicit barriers on enable/disable
Message-ID: <20191009093547.GE3901624@kroah.com>
References: <20191001171411.16602-1-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001171411.16602-1-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 11:14:11AM -0600, Mathieu Poirier wrote:
> From: Andrew Murray <andrew.murray@arm.com>
> 
> commit 1004ce4c255fc3eb3ad9145ddd53547d1b7ce327 upstream
> 
> Synchronization is recommended before disabling the trace registers
> to prevent any start or stop points being speculative at the point
> of disabling the unit (section 7.3.77 of ARM IHI 0064D).
> 
> Synchronization is also recommended after programming the trace
> registers to ensure all updates are committed prior to normal code
> resuming (section 4.3.7 of ARM IHI 0064D).
> 
> Let's ensure these syncronization points are present in the code
> and clearly commented.
> 
> Note that we could rely on the barriers in CS_LOCK and
> coresight_disclaim_device_unlocked or the context switch to user
> space - however coresight may be of use in the kernel.
> 
> On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
> only used on armv8 let's directly use dsb(sy) instead of mb(). This
> removes some ambiguity and makes it easier to correlate the code with
> the TRM.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> [Fixed capital letter for "use" in title]
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Link: https://lore.kernel.org/r/20190829202842.580-11-mathieu.poirier@linaro.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org # 4.9+
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  drivers/hwtracing/coresight/coresight-etm4x.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
