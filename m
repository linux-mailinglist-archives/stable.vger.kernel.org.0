Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EEDD0442
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfJHXkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:40:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:27588 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfJHXkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:40:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 16:40:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="199961259"
Received: from jhogan1-mobl.ger.corp.intel.com (HELO localhost) ([10.252.2.221])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Oct 2019 16:40:17 -0700
Date:   Wed, 9 Oct 2019 02:40:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 002/106] tpm: Fix TPM 1.2 Shutdown sequence to
 prevent future TPM operations
Message-ID: <20191008234017.GA13437@linux.intel.com>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171126.123065744@linuxfoundation.org>
 <20191008094121.GA608@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008094121.GA608@amd>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -187,12 +187,13 @@ static int tpm_class_shutdown(struct device *dev)
> >  {
> >  	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> >  
> > +	down_write(&chip->ops_sem);
> >  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> > -		down_write(&chip->ops_sem);
> >  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> >  		chip->ops = NULL;
> > -		up_write(&chip->ops_sem);
> >  	}
> > +	chip->ops = NULL;
> > +	up_write(&chip->ops_sem);
> >  
> >  	return 0;
> >  }
> 
> Still can be improved -- chip->ops = NULL; is done twice, copy inside
> the if {} is redundant...

Thanks. I can update this.

/Jarkko
