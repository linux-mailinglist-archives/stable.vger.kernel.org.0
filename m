Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA8C8C96
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 17:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfJBPRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 11:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfJBPRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 11:17:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6E3D21848;
        Wed,  2 Oct 2019 15:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570029473;
        bh=PFmYIaNXy6vtq/mdjpLzFTjO80J118W79JbEUkJYMfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3Pr3QAesDhKh6O9dfxT7jxn8uQ9ZIVWrckWbuWDif9e1cPlVH32TO28yqDhk5DgP
         rae8AhBkrNekkQ9ywyBOY9hDAqv48tKFlaMrPd2Rg9vePSyIc9I+MR75Vx/kzEhJQK
         NnNqRRAXAAzoBwPVborF2JYIAXpPy6aDyMOx9R6o=
Date:   Wed, 2 Oct 2019 11:17:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-stabley@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "open list:TPM DEVICE DRIVER" <linux-integrity@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tpm: Fix TPM 1.2 Shutdown sequence to prevent future
 TPM operations
Message-ID: <20191002151751.GP17454@sasha-vm>
References: <20191002131445.7793-1-jarkko.sakkinen@linux.intel.com>
 <20191002131445.7793-4-jarkko.sakkinen@linux.intel.com>
 <20191002135758.GA1738718@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191002135758.GA1738718@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 03:57:58PM +0200, Greg KH wrote:
>On Wed, Oct 02, 2019 at 04:14:44PM +0300, Jarkko Sakkinen wrote:
>> From: Vadim Sukhomlinov <sukhomlinov@google.com>
>>
>> commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
>>
>> TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
>> future TPM operations. TPM 1.2 behavior was different, future TPM
>> operations weren't disabled, causing rare issues. This patch ensures
>> that future TPM operations are disabled.
>>
>> Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
>> [dianders: resolved merge conflicts with mainline]
>> Signed-off-by: Douglas Anderson <dianders@chromium.org>
>> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> ---
>>  drivers/char/tpm/tpm-chip.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>
>What kernel version(s) is this for?

It would go to 4.19, we've recently reverted an incorrect backport of
this patch.

Jarkko, why is this patch 3/3? We haven't seen the first two on the
mailing list, do we need anything besides this patch?

--
Thanks,
Sasha
