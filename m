Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB1B12D5B2
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 03:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfLaCNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 21:13:36 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:44923 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbfLaCNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 21:13:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577758415; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Jhy+WJImFEcoO6HBDQ7TVinBKkDR7LQeAKpQxrPTrnQ=;
 b=glW2OhfeaFtYpOYWwDTc8sWAIEqLn8Pyp+D7faItv0Jzfo0VTz4g7xXlpLvTX3bGEXzzKoHY
 9b77Ixcb61uT4EctLeEeOXeVOaAXDMk2nlLpdA7Q9ydI7k6+f+9pC7uAl7OjfUzsCSngCTvv
 soSv/01FtI12AWnEJk9YYs7BksY=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e0aaeca.7f50ee727d88-smtp-out-n01;
 Tue, 31 Dec 2019 02:13:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 73510C447A6; Tue, 31 Dec 2019 02:13:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 900A1C43383;
        Tue, 31 Dec 2019 02:13:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Dec 2019 10:13:27 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, pedrom.sousa@synopsys.com,
        jejb@linux.ibm.com, matthias.bgg@gmail.com, bvanassche@acm.org,
        subhashj@codeaurora.org, beanhuo@micron.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        stable@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH v1 1/2] scsi: ufs: set device as default active power mode
 during initialization only
In-Reply-To: <1577754469.13164.5.camel@mtkswgap22>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
 <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
 <fd129b859c013852bd80f60a36425757@codeaurora.org>
 <1577754469.13164.5.camel@mtkswgap22>
Message-ID: <836772092daffd8283a97d633e59fc34@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-12-31 09:07, Stanley Chu wrote:
> Hi Asutosh,
> 
> 
>> I see that there's a get_sync done before.
>> So, how would the suspend be triggered in that case?
>> 
> 
> Would you mean pm_runtime_get_sync() in ufshcd_init()?
> If yes, it will only happen during initialization.
> 
> The runtime resume path may go through ufshcd_probe_hba() without
> ufshcd_init() invoked before, for example,
> 
> ufshcd_probe_hba+0xe10/0x1874
> ufshcd_host_reset_and_restore+0x114/0x1a4
> ufshcd_resume+0x1d0/0x480
> ufshcd_runtime_resume+0x40/0x188
> ufshcd_pltfrm_runtime_resume+0x10/0x18
> pm_generic_runtime_resume+0x24/0x44
> __rpm_callback+0x100/0x250
> rpm_resume+0x548/0x7c8
> rpm_resume+0x2b4/0x7c8
> rpm_resume+0x2b4/0x7c8
> rpm_resume+0x2b4/0x7c8
> pm_runtime_work+0x9c/0xa0
> process_one_work+0x210/0x4e0
> worker_thread+0x390/0x520
> kthread+0x154/0x18c
> ret_from_fork+0x10/0x18
> 
> This case happens if link is in "off" state while resume.
> 
> Thanks,
> Stanley

Hi Stanley,

I see skipping ufshcd_set_ufs_dev_active() in ufshcd_probe_hba()
if it is called from ufshcd_resume() path is the purpose here.

If so, then ufshcd_set_dev_pwr_mode() would be called, meaning
SSU command will be sent. Why is this SSU command needed to be
sent after a full host reset and restore? Is ufshcd_probe_hba()
not enough to make UFS device fully functional?

<snip>
         } else if (ufshcd_is_link_off(hba)) {
                 ret = ufshcd_host_reset_and_restore(hba);
                 /*
                  * ufshcd_host_reset_and_restore() should have already
                  * set the link state as active
                  */
                 if (ret || !ufshcd_is_link_active(hba))
                         goto vendor_suspend;
         }

         if (!ufshcd_is_ufs_dev_active(hba)) {
                 ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
                 if (ret)
                         goto set_old_link_state;
         }
<snip>

Thanks,

Can Guo.
