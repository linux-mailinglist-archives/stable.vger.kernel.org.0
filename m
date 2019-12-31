Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B312D71B
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 09:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfLaIfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 03:35:15 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:19458 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbfLaIfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 03:35:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577781312; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=/MyzgTAoW84poPoGQNDvx4+/Q3RCJgT0vSrB6UE39Ec=;
 b=EaskGOhhGl9zE+i3m4via1P21uHkBLczEZnKZgfHlsUfwz5z1AZB9vQTAd7nZORmhI4GiTqh
 HiAI1NWY9NXPSxWT62gJ4Fj5eAceWUi9oor0oNz78NBT1F/SUTjvAcoD+EuQaaqJ5tLhr6DK
 CiRp6o6MAa3DYhBGfbsx3DT0tyk=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e0b083d.7fe0130850a0-smtp-out-n03;
 Tue, 31 Dec 2019 08:35:09 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id ADB6CC447A4; Tue, 31 Dec 2019 08:35:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A3C10C433CB;
        Tue, 31 Dec 2019 08:35:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Dec 2019 16:35:06 +0800
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
In-Reply-To: <1577778290.13164.45.camel@mtkswgap22>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
 <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
 <fd129b859c013852bd80f60a36425757@codeaurora.org>
 <1577754469.13164.5.camel@mtkswgap22>
 <836772092daffd8283a97d633e59fc34@codeaurora.org>
 <1577766179.13164.24.camel@mtkswgap22>
 <1577778290.13164.45.camel@mtkswgap22>
Message-ID: <44393ed9ff3ba9878bae838307e7eec0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-12-31 15:44, Stanley Chu wrote:
> Hi Can,
> 
> On Tue, 2019-12-31 at 12:22 +0800, Stanley Chu wrote:
>> Hi Can,
>> 
>> 
>> > Hi Stanley,
>> >
>> > I see skipping ufshcd_set_ufs_dev_active() in ufshcd_probe_hba()
>> > if it is called from ufshcd_resume() path is the purpose here.
>> >
>> > If so, then ufshcd_set_dev_pwr_mode() would be called, meaning
>> > SSU command will be sent. Why is this SSU command needed to be
>> > sent after a full host reset and restore? Is ufshcd_probe_hba()
>> > not enough to make UFS device fully functional?
>> 
>> After resume (for both runtime resume and system resume), device power
>> mode shall be back to "Active" to service incoming requests.
>> 
>> I see two cases need device power mode transition during resume flow
>> 1. Device Power Mode = Sleep
>> 2. Device Power Mode = PowerDown
>> 
>> For 1, ufshcd_probe_hba() is not invoked during resume flow,
>> hba->curr_dev_pwr_mode = SLEEP, thus ufshcd_resume() can invoke
>> ufshcd_set_dev_pwr_mode() to change device power mode.
>> 
>> For 2, ufshcd_probe_hba() is invoked during resume flow, before this
>> fix, hba->curr_dev_pwr_mode will be set to ACTIVE (note that only this
>> flag is set as ACTIVE, but device may be still in PowerDown state if
>> device power is not fully shutdown or device HW reset is not executed
>> before resume), in the end, ufshcd_resume() will not invoke
>> ufshcd_set_dev_pwr_mode() to send SSU command to make device change 
>> back
>> to Active power mode.
>> 
>> But if device is fully reset before resume (not by current mainstream
>> driver), device can be already in "Active" power mode after power on
>> again during resume flow. In this case, it is OK to set
>> hba->curr_dev_pwr_mode as ACTIVE in ufshcd_probe_hba() and SSU command
>> is not necessary.
>> 
>> Thanks,
>> Stanley
> 
> I think currently the assumption in ufshcd_probe_hba() that "device
> shall be already in Active power mode" makes sense because many device
> commands will be sent to device in ufshcd_probe_hba() but device is not
> promised to handle those commands in PowerDown power mode according to
> UFS spec.
> 
> So, maybe always ensuring device being Active power mode before leaving
> ufshcd_probe_hba() is more reasonable. If so, I will drop this patch
> first.
> 
> Thanks so much for your reviews.
> 
> Happy new year!
> 
> Thanks,
> Stanley

Hi Stanley,

I missed this mail before I hit send. In current code, as per my 
understanding,
UFS device's power state should be Active after ufshcd_link_startup() 
returns.
If I am wrong, please feel free to correct me.

Due to you are almost trying to revert commit 7caf489b99a42a, I am just 
wondering
if you encounter failure/error caused by it.

Happy new year to you too!

Thanks,

Can Guo
