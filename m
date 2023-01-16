Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4869866C559
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjAPQFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbjAPQEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:04:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC61C26864;
        Mon, 16 Jan 2023 08:03:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671956101F;
        Mon, 16 Jan 2023 16:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72BFC433F0;
        Mon, 16 Jan 2023 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673884989;
        bh=FrbGjzIWFaVbNv42ogpLWc8HChDfFW9KqzLTwLqXtoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q9sPxw9psZ4jDIaXyMK9zTVd0Sbq8Ca+SGAcAVC3EYL2abuhMFbPj8yd7TsSp0Sos
         ecPKZlTsmNDcv6cdIGNJTSevZAfv5YtGdppCc8acJsVOoGh5cRO5Cj4MrT4N0yax7q
         w1O9vNoU11uwXL1RaA3vytv9Wkg4/D1cVZ0Zj5tUPFb/3n1OwwY8bOKPdNkx25T3xd
         VDi62/LKeC+IniXiSNhMQeIbEkt6Lv8IEER9GhdZrNsKbfi/eG63W0TweYV8P0wvTZ
         D69XYiMonjM2bJSeScJaMu8UB+KLXVYzWkWsDuzWCH49KSi/vb2i+j7+sl9/KjZzss
         jS548WyWws2pA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pHRxI-0004EJ-W8; Mon, 16 Jan 2023 17:03:29 +0100
Date:   Mon, 16 Jan 2023 17:03:28 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Can Guo <quic_cang@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Message-ID: <Y8V1UGzXqqc0CGdq@hovoldconsulting.com>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
 <349e3564-10d4-9429-93d2-7bb639253fc2@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <349e3564-10d4-9429-93d2-7bb639253fc2@acm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 10:38:58AM -0800, Bart Van Assche wrote:
> On 12/22/22 02:21, Johan Hovold wrote:
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index bda61be5f035..5c3821b2fcf8 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -1234,12 +1234,14 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
> >   	 * clock scaling is in progress
> >   	 */
> >   	ufshcd_scsi_block_requests(hba);
> > +	mutex_lock(&hba->wb_mutex);
> >   	down_write(&hba->clk_scaling_lock);
> >   
> >   	if (!hba->clk_scaling.is_allowed ||
> >   	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> >   		ret = -EBUSY;
> >   		up_write(&hba->clk_scaling_lock);
> > +		mutex_unlock(&hba->wb_mutex);
> >   		ufshcd_scsi_unblock_requests(hba);
> >   		goto out;
> >   	}
> > @@ -1251,12 +1253,16 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
> >   	return ret;
> >   }
> 
> Please add an __acquires(&hba->wb_mutex) annotation for sparse.
> 
> > -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
> > +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool scale_up)
> >   {
> > -	if (writelock)
> > -		up_write(&hba->clk_scaling_lock);
> > -	else
> > -		up_read(&hba->clk_scaling_lock);
> > +	up_write(&hba->clk_scaling_lock);
> > +
> > +	/* Enable Write Booster if we have scaled up else disable it */
> > +	if (ufshcd_enable_wb_if_scaling_up(hba))
> > +		ufshcd_wb_toggle(hba, scale_up);
> > +
> > +	mutex_unlock(&hba->wb_mutex);
> > +
> >   	ufshcd_scsi_unblock_requests(hba);
> >   	ufshcd_release(hba);
> >   }
> 
> Please add a __releases(&hba->wb_mutex) annotation for sparse.

This would actually introduce new sparse warnings as mutex_lock/unlock()
are not sparse annotated:

drivers/ufs/core/ufshcd.c:1254:9: warning: context imbalance in 'ufshcd_clock_scaling_prepare' - wrong count at exit
drivers/ufs/core/ufshcd.c:1266:9: warning: context imbalance in 'ufshcd_clock_scaling_unprepare' - wrong count at exit
drivers/ufs/core/ufshcd.c:1281:12: warning: context imbalance in 'ufshcd_devfreq_scale' - wrong count at exit

I guess it's not worth adding explicit __acquire()/__release() to these
helpers either (e.g. as they are only used in one function).

> > @@ -1273,7 +1279,6 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
> >   static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
> >   {
> >   	int ret = 0;
> > -	bool is_writelock = true;
> >   
> >   	ret = ufshcd_clock_scaling_prepare(hba);
> >   	if (ret)
> > @@ -1302,15 +1307,8 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
> >   		}
> >   	}
> >   
> > -	/* Enable Write Booster if we have scaled up else disable it */
> > -	if (ufshcd_enable_wb_if_scaling_up(hba)) {
> > -		downgrade_write(&hba->clk_scaling_lock);
> > -		is_writelock = false;
> > -		ufshcd_wb_toggle(hba, scale_up);
> > -	}
> > -
> >   out_unprepare:
> > -	ufshcd_clock_scaling_unprepare(hba, is_writelock);
> > +	ufshcd_clock_scaling_unprepare(hba, scale_up);
> >   	return ret;
> >   }
> 
> This patch moves the ufshcd_wb_toggle() from before the out_unprepare 
> label to after the out_unprepare label (into 
> ufshcd_clock_scaling_unprepare()). Does this change perhaps introduce a 
> new call to ufshcd_wb_toggle() in error paths?

Thanks for spotting that. I'll leave the setting unchanged on errors in
v2.

Johan
