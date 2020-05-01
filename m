Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954F01C0B6E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 02:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgEAA7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 20:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgEAA7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 20:59:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8585B2074A;
        Fri,  1 May 2020 00:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588294791;
        bh=n0/M9rUAOy+vFDip2GBxWtLQ3WgrfFnJFz0zTnKR5ag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZNz/aSWrjZ9lqN42hmYmOfqasSWlEImqHXi2QO2TuySC+XHtzkVOKV6pfxdfEbkxX
         CXx2CgiSPEIj9AYrFZ47UnA/ey140cNALc6TwMueZkZceHcoWEkUJxF12JYCn9o338
         GynVSzFw/55kQXRzjsJSw/YpMk0mE0uJHtAP5XBA=
Date:   Thu, 30 Apr 2020 20:59:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 30/38] i2c: tegra: Better handle case where
 CPU0 is busy for a long time
Message-ID: <20200501005950.GE13035@sasha-vm>
References: <20200424122237.9831-1-sashal@kernel.org>
 <20200424122237.9831-30-sashal@kernel.org>
 <20200427072233.GB3451400@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200427072233.GB3451400@ulmo>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 27, 2020 at 09:22:33AM +0200, Thierry Reding wrote:
>On Fri, Apr 24, 2020 at 08:22:28AM -0400, Sasha Levin wrote:
>> From: Dmitry Osipenko <digetx@gmail.com>
>>
>> [ Upstream commit a900aeac253729411cf33c6cb598c152e9e4137f ]
>>
>> Boot CPU0 always handle I2C interrupt and under some rare circumstances
>> (like running KASAN + NFS root) it may stuck in uninterruptible state for
>> a significant time. In this case we will get timeout if I2C transfer is
>> running on a sibling CPU, despite of IRQ being raised. In order to handle
>> this rare condition, the IRQ status needs to be checked after completion
>> timeout.
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/i2c/busses/i2c-tegra.c | 27 +++++++++++++++------------
>>  1 file changed, 15 insertions(+), 12 deletions(-)
>
>Hi Sasha,
>
>can you drop this from the v5.6 stable queue please? Jon discovered that
>this patch introduces a regression in v5.7, and since we don't have a
>good understanding of why this is breaking things I think it'd be best
>if we reverted it for v5.7 until we come up with a good fix.
>
>I think the same applies for the other i2c/tegra patch that's 31/38 of
>this series.

I've dropped both of these, thanks!

-- 
Thanks,
Sasha
