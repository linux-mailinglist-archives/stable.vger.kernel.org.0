Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E14710FBC3
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 11:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbfLCKb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 05:31:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:41774 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfLCKb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 05:31:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 02:31:28 -0800
X-IronPort-AV: E=Sophos;i="5.69,272,1571727600"; 
   d="scan'208";a="213367267"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 02:31:26 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 7E18E20976; Tue,  3 Dec 2019 12:31:23 +0200 (EET)
Date:   Tue, 3 Dec 2019 12:31:23 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 211/306] media: ov13858: Check for possible null
 pointer
Message-ID: <20191203103123.GA32127@paasikivi.fi.intel.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203130.540872040@linuxfoundation.org>
 <20191203102250.GA27320@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203102250.GA27320@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Tue, Dec 03, 2019 at 11:22:50AM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> > 
> > [ Upstream commit 35629182eb8f931b0de6ed38c0efac58e922c801 ]
> > 
> > Check for possible null pointer to avoid crash.
> 
> > diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
> > index 0e7a85c4996c7..afd66d243403b 100644
> > --- a/drivers/media/i2c/ov13858.c
> > +++ b/drivers/media/i2c/ov13858.c
> > @@ -1612,7 +1612,8 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
> >  				OV13858_NUM_OF_LINK_FREQS - 1,
> >  				0,
> >  				link_freq_menu_items);
> > -	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> > +	if (ov13858->link_freq)
> > +		ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> >  
> >  	pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
> >  	pixel_rate_min =
> 
> I don't think this is right fix. If ov13858->link_freq initialization
> fails, we want to fail the initialization, not present
> half-initialized device to userland, no?

The patch fixes the problem. The rest could be debated, but LMML is the
right place for that debate.

-- 
Regard,s

Sakari Ailus
