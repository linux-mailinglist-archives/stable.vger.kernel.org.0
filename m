Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07D420DD45
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgF2SkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbgF2SkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:15 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99E9323D6B;
        Mon, 29 Jun 2020 13:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593436951;
        bh=yOH9Px7xVSmNfzSVpvbBpqmuiCQSgKoq+a38kHqIvgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=znzomeGJ/GfbNcF+5ZnhUcAlMqeiqwSoc52iW5wJAeb7DKq+GOyZpg2qyev2E7u44
         RdgDFJCSrbrHQ+WZCx+taVcl48kB+PlVjTZyDIYT8mKgWzGaNv0Uv90TABDpKqVo4c
         6LUnn+d/BIvGXS65lWnk+uNTvsH/zH34K9oxR5GI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jptjx-007KON-RM; Mon, 29 Jun 2020 14:22:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Jun 2020 14:22:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Chanwoo Choi <cw00.choi@samsung.com>
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        =?UTF-8?Q?Heik?= =?UTF-8?Q?o_St=C3=BCbner?= <heiko@sntech.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] PM / devfreq: rk3399_dmc: Fix kernel oops when
 rockchip,pmu is absent
In-Reply-To: <154fe5b6-6a05-c2b7-3014-2f7b9c2049f9@samsung.com>
References: <CGME20200622152844epcas1p2309f34247eb9653acdfd3818b7e6a569@epcas1p2.samsung.com>
 <20200622152824.1054946-1-maz@kernel.org>
 <784808d7-8943-44ab-f15a-34821e6d4d5f@samsung.com>
 <87tuyue142.wl-maz@kernel.org>
 <c1a5b730-0554-bb90-9d8d-b50390482e96@samsung.com>
 <3de68490-d788-e416-dd5f-d4d6e7eca61a@collabora.com>
 <154fe5b6-6a05-c2b7-3014-2f7b9c2049f9@samsung.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <636bcc73fa658747626e36d71bfcc4f9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: cw00.choi@samsung.com, enric.balletbo@collabora.com, heiko@sntech.de, myungjoo.ham@samsung.com, kyungmin.park@samsung.com, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-29 12:29, Chanwoo Choi wrote:
> Hi Enric and Mark,
> 
> On 6/29/20 8:05 PM, Enric Balletbo i Serra wrote:
>> Hi Chanwoo and Marc,
>> 
>> On 29/6/20 13:09, Chanwoo Choi wrote:
>>> Hi Enric,
>>> 
>>> Could you check this issue? Your patch[1] causes this issue.
>>> As Marc mentioned, although rk3399-dmc.c handled 'rockchip,pmu'
>>> as the mandatory property, your patch[1] didn't add the 
>>> 'rockchip,pmu'
>>> property to the documentation.
>>> 
>> 
>> I think the problem is that the DT binding patch, for some reason, was 
>> missed
>> and didn't land. The patch seems to have all the required reviews and 
>> acks.
>> 
>>   https://patchwork.kernel.org/patch/10901593/
>> 
>> Sorry because I didn't notice this issue when 9173c5ceb035 landed. And 
>> thanks
>> for fixing the issue.
> 
> If the 'rockchip,pmu' propery is mandatory, instead of Mark's patch,
> we better to require the merge of patch[1] to DT maintainer.

It is way too late. Firmware exists (mainline u-boot, for one) that
do not expose the new property, and you can't demand that people
upgrade. This is an ABI bug, and we now have to live with it.

So, yes to fixing the DT, and no to *only* fixing the DT.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
