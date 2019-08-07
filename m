Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0DA84270
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 04:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfHGC0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 22:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728906AbfHGC0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 22:26:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3D5E20684;
        Wed,  7 Aug 2019 02:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565144796;
        bh=CBH+xUzbXogYkiFsg46LTMoraNeKA9rUJywxKWIdaUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=17smmYDTo3extC/QXcN5m4jCjcbDxdQyRPQ0rnCLgizvOBkZol7/15EEk3BfiRE0F
         gelMoEG698uc3qhabc3bxePl5oLYCd8shf47Pt21eaZyLM2lmAakogGU+rZ+YAOxgn
         mrb0A9V/yyEL76VMZG6CHqFHk/jw7a64RaQ8u46Q=
Date:   Tue, 6 Aug 2019 22:26:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 4.19 02/74] ARM: dts: rockchip: Make rk3288-veyron-minnie
 run at hs200
Message-ID: <20190807022635.GR17747@sasha-vm>
References: <20190805124935.819068648@linuxfoundation.org>
 <20190805124936.029458352@linuxfoundation.org>
 <20190805144112.GA24265@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190805144112.GA24265@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 04:41:12PM +0200, Pavel Machek wrote:
>Hi!
>
>> [ Upstream commit 1c0479023412ab7834f2e98b796eb0d8c627cd62 ]
>>
>> As some point hs200 was failing on rk3288-veyron-minnie.  See commit
>> 984926781122 ("ARM: dts: rockchip: temporarily remove emmc hs200 speed
>> from rk3288 minnie").  Although I didn't track down exactly when it
>> started working, it seems to work OK now, so let's turn it back on.
>>
>> To test this, I booted from SD card and then used this script to
>> stress the enumeration process after fixing a memory leak [1]:
>>   cd /sys/bus/platform/drivers/dwmmc_rockchip
>>   for i in $(seq 1 3000); do
>>     echo "========================" $i
>>     echo ff0f0000.dwmmc > unbind
>>     sleep .5
>>     echo ff0f0000.dwmmc > bind
>>     while true; do
>>       if [ -e /dev/mmcblk2 ]; then
>>         break;
>>       fi
>>       sleep .1
>>     done
>>   done
>>
>> It worked fine.
>
>This may not be suitable for stable. So... hs200 started working in
>mainline sometime. That does not mean it was fixed in all the various
>stable trees, too.
>
>How was this tested in respective -stable releases?

If you know of any other patches required on older stable kernels to
make this work I'll be more than happy to take them...

--
Thanks,
Sasha
