Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6AB7A2CE
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 10:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbfG3IIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 04:08:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730839AbfG3IIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 04:08:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D6EDC6037C; Tue, 30 Jul 2019 08:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564474122;
        bh=+sMHcpS1ulUUbOmL1Z9dNBUBD3g23n1MFcbcZj3a+ko=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bXFfgyHSjL0PRBtecGd20UWGA4l8n1uGluyo/dEkV1t2J75intbKIxtYx1SF4SqDl
         udg1tD2b/zKAVaV3kS58KSkDQCeE8h/onM3dpTe8s8b4G8W5NJqcC2MUg0s8QLId3Q
         HX5yKOmj71IafmJ2HitJYY84tT3i96fLV3SFnia4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 92C256037C;
        Tue, 30 Jul 2019 08:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564474122;
        bh=+sMHcpS1ulUUbOmL1Z9dNBUBD3g23n1MFcbcZj3a+ko=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bXFfgyHSjL0PRBtecGd20UWGA4l8n1uGluyo/dEkV1t2J75intbKIxtYx1SF4SqDl
         udg1tD2b/zKAVaV3kS58KSkDQCeE8h/onM3dpTe8s8b4G8W5NJqcC2MUg0s8QLId3Q
         HX5yKOmj71IafmJ2HitJYY84tT3i96fLV3SFnia4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 92C256037C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Takashi Iwai <tiwai@suse.de>, Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5.3] mwifiex: fix 802.11n/WPA detection
References: <20190724194634.205718-1-briannorris@chromium.org>
        <s5hv9vkx21i.wl-tiwai@suse.de>
        <CA+ASDXMEFew2Sg5G1ofKq-0gfOTFEOhZNjfyNJMRzRjv7ZFgXw@mail.gmail.com>
Date:   Tue, 30 Jul 2019 11:08:37 +0300
In-Reply-To: <CA+ASDXMEFew2Sg5G1ofKq-0gfOTFEOhZNjfyNJMRzRjv7ZFgXw@mail.gmail.com>
        (Brian Norris's message of "Mon, 29 Jul 2019 12:45:26 -0700")
Message-ID: <87y30glzay.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Mon, Jul 29, 2019 at 9:01 AM Takashi Iwai <tiwai@suse.de> wrote:
>> This isn't seen in linux-next yet.
>
> Apparently not.
>
>> Still pending review?
>
> I guess? Probably mostly pending maintainer attention.

Correct, I was offline for few days.

> Also, Johannes already had noticed (and privately messaged me): this
> patch took a while to show up on the linux-wireless Patchwork
> instance. So the first review (from Guenter Roeck) and my extra reply
> noting the -stable regression didn't make it to Patchwork:
>
> https://patchwork.kernel.org/patch/11057585/
>
>> In anyway,
>>   Reviewed-by: Takashi Iwai <tiwai@suse.de>
>
> Thanks. Hopefully Kalle can pick it up.

I expect to apply this today.

-- 
Kalle Valo
