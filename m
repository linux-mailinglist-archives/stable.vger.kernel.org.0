Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527ACDA842
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 11:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393436AbfJQJ1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 05:27:45 -0400
Received: from mail2.skidata.com ([91.230.2.91]:2716 "EHLO mail2.skidata.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392048AbfJQJ1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 05:27:45 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2019 05:27:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=skidata.com; i=@skidata.com; q=dns/txt; s=selector1;
  t=1571304464; x=1602840464;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=+j+Yjp8dnjM1nQr3RyLaL94Bw4QJ0SOznlwHGpyhZDE=;
  b=P28/9b/eGSIKvxrqT/J3K6Ej3bnL6syWkhXehvuGH+z1LA7GrMiLl4P3
   DfB1ENAcURaYO7WnPLabRmfshS+6oQhtzoK4AIx1+qJquKuSvI9UJybwq
   GWzvKLr0AGyx+/QqtG9Er+JF4pfG6VUMCkJcIDL6V4I+3f+JwXP0vk6bC
   hkQDQxEloesneJ4ogMbjSzm33kHi8cAcpz7+0bShWyFkvL3ZpyZOmG2Ip
   Q4nd7RBB6Q5xa8bOfdK62OkG2acDi1nJ563SFMlXrkxTCGL5dyYIY1tgW
   j5jX4YO1F8V1h6PfpB/BNTuXLV4DkuXgFQiRukg+mv8sVI2jRCKOC4y/r
   Q==;
IronPort-SDR: tD3ZTSbdZaCQ6ehfqXJxsB7/tK0f4C8+Wd3DkRP0hldWJcMQgtu5BiK9/3sOQzd4cpV/MzPh7C
 gwUUaaJdEP77JUrYIcCweplChEajj2CgOeFaUDcvW4OQCc87Dbuw0NaXwfnJwagDbiVMRhTbfJ
 X5aik8g4tYaQPppclIGjyGkrijcFSrZkf4FuPr+1ZJurPw6PLodiGS5L5uJ/SjfSVGjNKr3B2E
 uS4eYe5C4MzWZtgKm+I4n4XscfkTg1O9KXHz8SjyEXxDTvw0RB+HMKHyw0D+sIN2WCLucNdKbg
 KN4=
X-IronPort-AV: E=Sophos;i="5.67,307,1566856800"; 
   d="scan'208";a="2381611"
Subject: Re: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191016214907.599726506@linuxfoundation.org>
 <20191016220044.GB11473@sirena.co.uk> <20191016221025.GA990599@kroah.com>
 <20191016223518.GC11473@sirena.co.uk> <20191016232358.GA994597@kroah.com>
From:   Richard Leitner <richard.leitner@skidata.com>
Message-ID: <de9630e5-341f-b48d-029a-ef1a516bf820@skidata.com>
Date:   Thu, 17 Oct 2019 11:20:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191016232358.GA994597@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.111.252]
X-ClientProxiedBy: sdex4srv.skidata.net (192.168.111.82) To
 sdex5srv.skidata.net (192.168.111.83)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 17/10/2019 01:23, Greg Kroah-Hartman wrote:
> On Wed, Oct 16, 2019 at 11:35:18PM +0100, Mark Brown wrote:
>> On Wed, Oct 16, 2019 at 03:10:25PM -0700, Greg Kroah-Hartman wrote:
>>> On Wed, Oct 16, 2019 at 11:00:44PM +0100, Mark Brown wrote:
>>>> On Wed, Oct 16, 2019 at 02:51:44PM -0700, Greg Kroah-Hartman wrote:
>>>>> From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
>>
>>>>> commit 694b14554d75f2a1ae111202e71860d58b434a21 upstream.
>>
>>>>> This control mute/unmute the ADC input of SGTL5000
>>>>> using its CHIP_ANA_CTRL register.
>>
>>>> This seems like a new feature and not an obvious candidate for stable?
>>
>>> there was a long email from Richard that said:
>>> 	Upstream commit 631bc8f0134a ("ASoC: sgtl5000: Fix of unmute
>>> 	outputs on probe"), which is e9f621efaebd in v5.3 replaced
>>> 	snd_soc_component_write with snd_soc_component_update_bits and
>>> 	therefore no longer cleared the MUTE_ADC flag. This caused the
>>> 	ADC to stay muted and recording doesn't work any longer. This
>>> 	patch fixes this problem by adding a Switch control for
>>> 	MUTE_ADC.
>>
>>> That's why I took this.  If this isn't true, I'll be glad to drop this.
>>
>> That's probably not an appropriate fix for stable - it's going to add a
>> new control which users will need to manually set (or hope their
>> userspace automatically figures out that it should set for them, more
>> advanced userspaces like PulseAudio should) which isn't a drop in fix.
>> You could either drop the backport that was done for zero cross or take
>> a new patch that clears the MUTE_ADC flag (rather than punting to
>> userspace to do so), or just be OK with what you've got at the minute
>> which might be fine given the lack of user reports.
> 
> Ok, I'll gladly go drop it, thanks!

Mark, thanks for the clarification! I haven't thought of breaking 
anything with the backport as it worked fine for our application.

Greg, just to be sure:

Are you going to drop this patch and revert e9f621efaebd for v5.3?

Or should I send a patch which clears the MUTE_ADC flag like Mark
suggested?

thanks & regards;Richard.L
