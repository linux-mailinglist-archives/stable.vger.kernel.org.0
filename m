Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C476B1EEA87
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgFDSuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 14:50:23 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:42524 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728809AbgFDSuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 14:50:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591296622; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=l6wlzfSYbJzkeSugvF6FSEks0oM2Zf6QKufmIi2dOJ8=;
 b=MglHwX8mPoTVrR6AByjV49hXMHl1S9n0yBcrEIZ7Qd7FyO2w3HvH1KvK3y+iN8d8FGYJl5Hj
 IRskhnqA11l9lWzHESp/OK2imh84FhPc9zXaZBHON5aKOqItxCsuZos/tMfeWQWP48Kl2QO6
 QfauAy2+n8Ksl+PdyJsf19rYSQ0=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5ed9426076fccbb4c8f7e006 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 04 Jun 2020 18:50:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3532FC43395; Thu,  4 Jun 2020 18:50:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E782C433CB;
        Thu,  4 Jun 2020 18:50:02 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 05 Jun 2020 00:20:02 +0530
From:   Sibi Sankar <sibis@codeaurora.org>
To:     Evan Green <evgreen@chromium.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ohad Ben Cohen <ohad@wizery.com>, rohitkr@codeaurora.org,
        stable@vger.kernel.org, linux-kernel-owner@vger.kernel.org
Subject: Re: [PATCH 1/2] remoteproc: qcom: q6v5: Update running state before
 requesting stop
In-Reply-To: <CAE=gft4v1iHAPJS13fLBXgjt8ZRhD7q894zF_7JvK9QbiTbwhA@mail.gmail.com>
References: <20200602163257.26978-1-sibis@codeaurora.org>
 <CAE=gft7sbh_S_GiRohtMmdMN9JzQhG0m3bUerwrmzhjmXucGKw@mail.gmail.com>
 <6392c800b0be1cbabb8a241cf518ab4b@codeaurora.org>
 <CAE=gft4v1iHAPJS13fLBXgjt8ZRhD7q894zF_7JvK9QbiTbwhA@mail.gmail.com>
Message-ID: <ebc56ab0bd61f5b33be976a6643880db@codeaurora.org>
X-Sender: sibis@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-04 04:03, Evan Green wrote:
> On Tue, Jun 2, 2020 at 10:29 PM Sibi Sankar <sibis@codeaurora.org> 
> wrote:
>> 
>> Evan,
>> Thanks for taking time to review
>> the series.
>> 
>> On 2020-06-02 23:14, Evan Green wrote:
>> > On Tue, Jun 2, 2020 at 9:33 AM Sibi Sankar <sibis@codeaurora.org>
>> > wrote:
>> >>
>> >> Sometimes the stop triggers a watchdog rather than a stop-ack. Update
>> >> the running state to false on requesting stop to skip the watchdog
>> >> instead.
>> >>
>> >> Error Logs:
>> >> $ echo stop > /sys/class/remoteproc/remoteproc0/state
>> >> ipa 1e40000.ipa: received modem stopping event
>> >> remoteproc-modem: watchdog received: sys_m_smsm_mpss.c:291:APPS force
>> >> stop
>> >> qcom-q6v5-mss 4080000.remoteproc-modem: port failed halt
>> >> ipa 1e40000.ipa: received modem offline event
>> >> remoteproc0: stopped remote processor 4080000.remoteproc-modem
>> >>
>> >> Fixes: 3b415c8fb263 ("remoteproc: q6v5: Extract common resource
>> >> handling")
>> >> Cc: stable@vger.kernel.org
>> >> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
>> >> ---
>> >
>> > Are you sure you want to tolerate this behavior from MSS? This is a
>> > graceful shutdown, modem shouldn't have a problem completing the
>> > proper handshake. If they do, isn't that a bug on the modem side?
>> 
>> The graceful shutdown is achieved
>> though sysmon (enabled using
>> CONFIG_QCOM_SYSMON). When sysmon is
>> enabled we get a shutdown-ack when we
>> try to stop the modem, post which
>> request stop is a basically a nop.
>> Request stop is done to force stop
>> the modem during failure cases (like
>> rmtfs is not running and so on) and
>> we do want to mask the wdog that we get
>> during this scenario ( The locking
>> already prevents the servicing of the
>> wdog during shutdown, the check just
>> prevents the scheduling of crash handler
>> and err messages associated with it).
>> Also this check was always present and
>> was missed during common q6v5 resource
>> helper migration, hence the unused
>> running state in mss driver.
> 
> So you're saying that the intention of the ->running check already in
> q6v5_wdog_interrupt() was to allow either the stop-ack or wdog
> interrupt to complete the stop. This patch just fixes a regression
> introduced during the refactor.
> This patch seems ok to me then. It still sort of seems like a bug that
> the modem responds arbitrarily in one of two ways, even to a "harsh"
> shutdown request.
> 
> I wasn't aware of QCOM_SYSMON. Reading it now, It seems like kind of a

TL;DR
Sysmon when enabled adds a lookup
for qmi service 43 (Subsystem
control service). When we shutdown
the modem, we send a SSCTL_SHUTDOWN_REQ
to the service and the modem responds
with a shutdown-ack interrupt. If you
have rmtfs running with -v turned on
you can notice pending efs transactions
being completed followed by a bye I guess.

> lot... do I really need all this? Can I get by with just remoteproc
> stops?
> Anyway, for this patch:
> 
> Reviewed-by: Evan Green <evgreen@chromium.org>

Thanks for the review!

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project.
