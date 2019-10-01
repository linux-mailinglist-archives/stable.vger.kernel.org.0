Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074E8C421F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 22:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfJAU5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 16:57:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:4377 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbfJAU5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 16:57:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 13:57:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,572,1559545200"; 
   d="scan'208";a="275120559"
Received: from nbaca1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.37.57])
  by orsmga001.jf.intel.com with ESMTP; 01 Oct 2019 13:57:00 -0700
Date:   Tue, 1 Oct 2019 23:56:58 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH 4.19 33/63] tpm: Fix TPM 1.2 Shutdown sequence to prevent
 future TPM operations
Message-ID: <20191001205658.GE26709@linux.intel.com>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135038.128262622@linuxfoundation.org>
 <20190930061346.GA22914@atrey.karlin.mff.cuni.cz>
 <20190930125712.GS8171@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930125712.GS8171@sasha-vm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 08:57:12AM -0400, Sasha Levin wrote:
> On Mon, Sep 30, 2019 at 08:13:46AM +0200, Pavel Machek wrote:
> > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > 
> > > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
> > > 
> > > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > > future TPM operations. TPM 1.2 behavior was different, future TPM
> > > operations weren't disabled, causing rare issues. This patch ensures
> > > that future TPM operations are disabled.
> > 
> > > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > > index 46caadca916a0..dccc61af9ffab 100644
> > > --- a/drivers/char/tpm/tpm-chip.c
> > > +++ b/drivers/char/tpm/tpm-chip.c
> > > @@ -187,12 +187,15 @@ static int tpm_class_shutdown(struct device *dev)
> > >  {
> > >  	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> > > 
> > > +	down_write(&chip->ops_sem);
> > >  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> > >  		down_write(&chip->ops_sem);
> > >  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> > >  		chip->ops = NULL;
> > >  		up_write(&chip->ops_sem);
> > >  	}
> > > +	chip->ops = NULL;
> > > +	up_write(&chip->ops_sem);
> > 
> > This is wrong, it takes &chip->ops_sem twice, that can't be
> > good. db4d8cb9c9f2af71c4d087817160d866ed572cc9 does not have that
> > problem.
> 
> I agree. I've dropped it from 4.19 and 4.14.
> 
> Jarkko, can you take a look at this again please?

Pavel, thank you for spotting that one, phew!

I'll do an update.

/Jarkko
