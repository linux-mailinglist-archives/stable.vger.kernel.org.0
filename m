Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67A638CCB1
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhEURwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 13:52:24 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:52553 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbhEURwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 13:52:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621619458; h=Message-ID: References: In-Reply-To: Reply-To:
 Subject: Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=kQaQKFs6n4n0HHe6bOtHoF4nMeAkLmDV9FsNtdNYbos=;
 b=CANqLwcD+RmYhkBN66TGP+Mll4QHRzbFoR9C9cTX2S7RJ1yO3t8bwILu0vjWG5St5BJ07ylP
 a5+GQERx2OuutJglPkXaBzo83uej+x8oiA574WTh+zYeZgoQ0smaK+acB2FNdyoNpBvye56V
 YpCDBGWbaCRk1v9YI4MIAlNEvNg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60a7f2ee0d60c09896f3136e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 21 May 2021 17:50:38
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3AA29C43147; Fri, 21 May 2021 17:50:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6C85FC4338A;
        Fri, 21 May 2021 17:50:34 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 21 May 2021 10:50:33 -0700
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>, quic_jhugo@quicinc.com
Subject: Re: [PATCH 5.10 002/299] bus: mhi: core: Clear configuration from
 channel context during reset
Organization: Qualcomm Innovation Center, Inc.
Reply-To: bbhatt@codeaurora.org
Mail-Reply-To: bbhatt@codeaurora.org
In-Reply-To: <20210511061623.GA8651@thinkpad>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102004.900838842@linuxfoundation.org> <20210510205650.GA17966@amd>
 <20210511061623.GA8651@thinkpad>
Message-ID: <64a8ebbdc9fc7de48b25b9e2bc896d47@codeaurora.org>
X-Sender: bbhatt@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-10 11:17 PM, Manivannan Sadhasivam wrote:
> Hi Pavel,
> 
> On Mon, May 10, 2021 at 10:56:50PM +0200, Pavel Machek wrote:
>> Hi!
>> 
>> > From: Bhaumik Bhatt <bbhatt@codeaurora.org>
>> >
>> > commit 47705c08465931923e2f2b506986ca0bdf80380d upstream.
>> >
>> > When clearing up the channel context after client drivers are
>> > done using channels, the configuration is currently not being
>> > reset entirely. Ensure this is done to appropriately handle
>> > issues where clients unaware of the context state end up calling
>> > functions which expect a context.
>> 
>> > +++ b/drivers/bus/mhi/core/init.c
>> > @@ -544,6 +544,7 @@ void mhi_deinit_chan_ctxt(struct mhi_con
>> > +	u32 tmp;
>> > @@ -554,7 +555,19 @@ void mhi_deinit_chan_ctxt(struct mhi_con
>> ...
>> > +	tmp = chan_ctxt->chcfg;
>> > +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
>> > +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
>> > +	chan_ctxt->chcfg = tmp;
>> > +
>> > +	/* Update to all cores */
>> > +	smp_wmb();
>> >  }
>> 
>> This is really interesting code; author was careful to make sure chcfg
>> is updated atomically, but C compiler is free to undo that. Plus, this
>> will make all kinds of checkers angry.
>> 
>> Does the file need to use READ_ONCE and WRITE_ONCE?
>> 
> 
> Thanks for looking into this.
> 
> I agree that the order could be mangled between chcfg read & write and
> using READ_ONCE & WRITE_ONCE seems to be a good option.
> 
> Bhaumik, can you please submit a patch and tag stable?
> 
> Thanks,
> Mani
> 
>> Best regards,
>> 								Pavel
>> --
>> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
>> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

Hi Pavel/Mani,

Hemant and I went over this patch and we noticed this particular 
function is
already being called with the channel mutex lock held. This would take 
care of
the atomicity and we also probably don't need the smp_wmb() barrier as 
the mutex
unlock will implicitly take care of it.

To the point of compiler re-ordering, we would need some help to 
understand the
purpose of READ_ONCE()/WRITE_ONCE() for these dependent statements:

> +	tmp = chan_ctxt->chcfg;
> +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
> +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> +	chan_ctxt->chcfg = tmp;

Since RMW operation means that the chan_ctxt->chcfg is copied to a local
variable (tmp) and the _same_ is being written back to chan_ctxt->chcfg, 
can
compiler reorder these dependent statements and cause a different 
result?

Thanks,
Bhaumik
---
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
