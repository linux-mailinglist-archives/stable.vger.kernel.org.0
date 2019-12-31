Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBE712D6EE
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 09:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbfLaIGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 03:06:06 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:55940 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbfLaIGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 03:06:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577779565; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BbUFBKLuGvpwFWTaBaOIbSVqQ9CkH2lY2UR83lDpcCo=;
 b=Nutiq/GWxnQlarQxxSsy3Rc4cLtx2QlVRNstNfAXXP6nimm80/e+SZ8FRtmb+tis4U90jXos
 rm34vKnVgzDQIDLJn0hVXGtY6zP5jHkaQDZZQIl5CoywnTSUerq2Fj1V7BmY07aEYjke4y02
 ZJoTQSQBQA15YKy7HMIfuOeABig=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e0b0168.7f6e35fae068-smtp-out-n01;
 Tue, 31 Dec 2019 08:06:00 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 44B27C447A3; Tue, 31 Dec 2019 08:06:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 25D52C43383;
        Tue, 31 Dec 2019 08:05:59 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Dec 2019 16:05:59 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi-owner@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, subhashj@codeaurora.org,
        jejb@linux.ibm.com, chun-hung.wu@mediatek.com,
        kuohong.wang@mediatek.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, avri.altman@wdc.com,
        linux-mediatek@lists.infradead.org, peter.wang@mediatek.com,
        alim.akhtar@samsung.com, andy.teng@mediatek.com,
        matthias.bgg@gmail.com, beanhuo@micron.com,
        pedrom.sousa@synopsys.com, bvanassche@acm.org,
        linux-arm-kernel@lists.infradead.org, asutoshd@codeaurora.org
Subject: Re: [PATCH v1 1/2] scsi: ufs: set device as default active power mode
 during initialization only
In-Reply-To: <1577766179.13164.24.camel@mtkswgap22>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
 <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
 <fd129b859c013852bd80f60a36425757@codeaurora.org>
 <1577754469.13164.5.camel@mtkswgap22>
 <836772092daffd8283a97d633e59fc34@codeaurora.org>
 <1577766179.13164.24.camel@mtkswgap22>
Message-ID: <cf94a0e8f8e0746ae5f8434631207ea4@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-12-31 12:22, Stanley Chu wrote:
> Hi Can,
> 
> 
>> Hi Stanley,
>> 
>> I see skipping ufshcd_set_ufs_dev_active() in ufshcd_probe_hba()
>> if it is called from ufshcd_resume() path is the purpose here.
>> 
>> If so, then ufshcd_set_dev_pwr_mode() would be called, meaning
>> SSU command will be sent. Why is this SSU command needed to be
>> sent after a full host reset and restore? Is ufshcd_probe_hba()
>> not enough to make UFS device fully functional?
> 
> After resume (for both runtime resume and system resume), device power
> mode shall be back to "Active" to service incoming requests.
> 
> I see two cases need device power mode transition during resume flow
> 1. Device Power Mode = Sleep
> 2. Device Power Mode = PowerDown
> 
> For 1, ufshcd_probe_hba() is not invoked during resume flow,
> hba->curr_dev_pwr_mode = SLEEP, thus ufshcd_resume() can invoke
> ufshcd_set_dev_pwr_mode() to change device power mode.
> 
> For 2, ufshcd_probe_hba() is invoked during resume flow, before this
> fix, hba->curr_dev_pwr_mode will be set to ACTIVE (note that only this
> flag is set as ACTIVE, but device may be still in PowerDown state if
> device power is not fully shutdown or device HW reset is not executed
> before resume), in the end, ufshcd_resume() will not invoke
> ufshcd_set_dev_pwr_mode() to send SSU command to make device change 
> back
> to Active power mode.

Hi Stanley,

Isn't below change fixing the problem you are saying above?
With it, after ufshcd_link_startup(), UFS device's power mode will
become Active anyways. Do you mean below change is not working properly
and you are removing it?

commit 7caf489b99a42a9017ef3d733912aea8794677e7
Author: subhashj@codeaurora.org <subhashj@codeaurora.org>
Date:   Wed Nov 23 16:32:20 2016 -0800

     scsi: ufs: issue link starup 2 times if device isn't active

     If we issue the link startup to the device while its UniPro state is
     LinkDown (and device state is sleep/power-down) then link startup
     will not move the device state to Active. Device will only move to
     active state if the link starup is issued when its UniPro state is
     LinkUp. So in this case, we would have to issue the link startup 2
     times to make sure that device moves to active state.

Thanks,

Can Guo

> 
> But if device is fully reset before resume (not by current mainstream
> driver), device can be already in "Active" power mode after power on
> again during resume flow. In this case, it is OK to set
> hba->curr_dev_pwr_mode as ACTIVE in ufshcd_probe_hba() and SSU command
> is not necessary.
> 
> Thanks,
> Stanley
> 
>> _______________________________________________
>> Linux-mediatek mailing list
>> Linux-mediatek@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-mediatek
