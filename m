Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DAB274429
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 16:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgIVOZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 10:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgIVOZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 10:25:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4659220C09;
        Tue, 22 Sep 2020 14:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600784716;
        bh=BjcEs/cyjGNFH4+Iv6NV3gAcUsMvzMLKmIq/2ekfuaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b+zh2DI3qvzE0CrDPaxWv1J4MDNlht5urMzZMCMsvYshQYFJf+FQXsNH27lu4xRcB
         f3cuz90yMYI+GgorDpgyxeX5rvT478Fr5iw2La3MMmh253JrUav8jT6zDe5gU1jQMV
         aU3Ffy4uZW/7goLBmKO7llVuQZEKM9l17TLr9pJY=
Date:   Tue, 22 Sep 2020 10:25:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.8 03/20] ASoC: wm8994: Skip setting of the
 WM8994_MICBIAS register for WM1811
Message-ID: <20200922142515.GN2431@sasha-vm>
References: <20200921144027.2135390-1-sashal@kernel.org>
 <20200921144027.2135390-3-sashal@kernel.org>
 <20200921150701.GA12231@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200921150701.GA12231@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 04:07:01PM +0100, Mark Brown wrote:
>On Mon, Sep 21, 2020 at 10:40:10AM -0400, Sasha Levin wrote:
>
>> The WM8994_MICBIAS register is not available in the WM1811 CODEC so skip
>> initialization of that register for that device.
>> This suppresses an error during boot:
>> "wm8994-codec: ASoC: error at snd_soc_component_update_bits on wm8994-codec"
>
>This is pretty much a cosmetic change - previously we were silently not
>reading the register, this just removes the attempt to read it since we
>added an error message in the core.

Right, the only reason I took it is that error message - I find that
bogus error messages have almost the same (bad) impact as real kernel
bugs.

I can drop it if you'd prefer.

-- 
Thanks,
Sasha
