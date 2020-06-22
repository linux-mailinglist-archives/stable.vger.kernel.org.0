Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C736202DD3
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 02:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbgFVAHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 20:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbgFVAHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jun 2020 20:07:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DD9E252A2;
        Mon, 22 Jun 2020 00:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592784441;
        bh=JLrHQHbaxR/ifwMoCSus6Uygootyff549B3fo1vMEqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qHhJJsS7lK5nlTZMVDBjgri0A4rh1Pr2OPTsJC/f73PpHfKHvu/vZYkBaZ2553t+J
         rOszx+Kr61RPMRNNEPZrpQCrfAy7NJJbHRsmYnskGzWHmJQ4UtfkjVT6DFsDRpJfjw
         vtlIWhhzT7GvOeHVXSznlSUIseUL0W9+s8Zl+Cuc=
Date:   Sun, 21 Jun 2020 20:07:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 23/60] iio: buffer: Don't allow buffers
 without any channels enabled to be activated
Message-ID: <20200622000720.GE1931@sasha-vm>
References: <20200618013004.610532-1-sashal@kernel.org>
 <20200618013004.610532-23-sashal@kernel.org>
 <20200619172733.00005d9d@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200619172733.00005d9d@Huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 05:27:33PM +0100, Jonathan Cameron wrote:
>On Wed, 17 Jun 2020 21:29:27 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Lars-Peter Clausen <lars@metafoo.de>
>>
>> [ Upstream commit b7329249ea5b08b2a1c2c3f24a2f4c495c4f14b8 ]
>>
>> Before activating a buffer make sure that at least one channel is enabled.
>> Activating a buffer with 0 channels enabled doesn't make too much sense and
>> disallowing this case makes sure that individual driver don't have to add
>> special case code to handle it.
>>
>> Currently, without this patch enabling a buffer is possible and no error is
>> produced. With this patch -EINVAL is returned.
>>
>> An example of execution with this patch and some instrumented print-code:
>>    root@analog:~# cd /sys/bus/iio/devices/iio\:device3/buffer
>>    root@analog:/sys/bus/iio/devices/iio:device3/buffer# echo 1 > enable
>>    0: iio_verify_update 748 indio_dev->masklength 2 *insert_buffer->scan_mask 00000000
>>    1: iio_verify_update 753
>>    2:__iio_update_buffers 1115 ret -22
>>    3: iio_buffer_store_enable 1241 ret -22
>>    -bash: echo: write error: Invalid argument
>> 1, 2 & 3 are exit-error paths. 0 the first print in iio_verify_update()
>> rergardless of error path.
>>
>> Without this patch (and same instrumented print-code):
>>    root@analog:~# cd /sys/bus/iio/devices/iio\:device3/buffer
>>    root@analog:/sys/bus/iio/devices/iio:device3/buffer# echo 1 > enable
>>    0: iio_verify_update 748 indio_dev->masklength 2 *insert_buffer->scan_mask 00000000
>>    root@analog:/sys/bus/iio/devices/iio:device3/buffer#
>> Buffer is enabled with no error.
>>
>> Note from Jonathan: Probably not suitable for automatic application to stable.
>> This has been there from the very start.  It tidies up an odd corner
>> case but won't effect any 'real' users.
>>
>
>As noted. I don't think it matters if we do apply this to stable.
>It closes an interface oddity rather than an actual known bug.

I'll drop it, thanks!

-- 
Thanks,
Sasha
