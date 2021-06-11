Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF6D3A3F92
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 11:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhFKJzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 05:55:38 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:64539 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhFKJzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 05:55:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623405221; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=666YK8gINgc1UHCiC58S85Bukn28o750jo/NOXjdXL4=; b=DjwXU1O+Xu3T8GaQ1IZGQjC/SXB+n60g9BiCMP2p6kX12c2UuC9IcgdksKZ2isx6oQcIp9bx
 i/UUJ2V9684R+iTMkn8vtDYoaE2NG5BsLeFkBT1344Bk2c+xNVtqyT0Fi2NjeH+BA/tRAAIN
 W2olQDjOOEFaq/2p15fIrN7l7nQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60c332a2ed59bf69ccbc3cfb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Jun 2021 09:53:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A08AC4338A; Fri, 11 Jun 2021 09:53:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D407EC433F1;
        Fri, 11 Jun 2021 09:53:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D407EC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        stable <stable@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>, dave@bewaar.me,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5.13] mwifiex: bring down link before deleting interface
References: <20210515024227.2159311-1-briannorris@chromium.org>
        <CA+ASDXMDtWpZ-xrymmq51j4TjPT-NXs61-7q=sn090BoJu9qDg@mail.gmail.com>
Date:   Fri, 11 Jun 2021 12:53:30 +0300
In-Reply-To: <CA+ASDXMDtWpZ-xrymmq51j4TjPT-NXs61-7q=sn090BoJu9qDg@mail.gmail.com>
        (Brian Norris's message of "Thu, 10 Jun 2021 17:18:31 -0700")
Message-ID: <87eed8zq05.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Fri, May 14, 2021 at 7:45 PM Brian Norris <briannorris@chromium.org> wrote:
>>
>> We can deadlock when rmmod'ing the driver or going through firmware
>> reset, because the cfg80211_unregister_wdev() has to bring down the link
>> for us, ... which then grab the same wiphy lock.
> ...
>> Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
>> Cc: stable@vger.kernel.org
>> Link:
>> https://lore.kernel.org/linux-wireless/98392296-40ee-6300-369c-32e16cff3725@gmail.com/
>> Link:
>> https://lore.kernel.org/linux-wireless/ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me/
>> Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
>> Reported-by: dave@bewaar.me
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Brian Norris <briannorris@chromium.org>
>
> Ping - is this going to get merged? It's a 5.12 regression, and we
> have multiple people complaining about it (and they tested the fix
> too!).

Thanks for the ping, this got piled up under all the -next patches and I
missed it. I'll look at it now.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
