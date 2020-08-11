Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D961241E8A
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 18:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgHKQpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 12:45:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:10736 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbgHKQpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 12:45:06 -0400
IronPort-SDR: LEm0IEe3ItJ7CmA1O2Z4PSpoWx2wtpnq8jntfJqd/Uw0cczla5zelcACOSBeVTOU2Mg+iSsP6F
 ovi7lLzTYcaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="171818111"
X-IronPort-AV: E=Sophos;i="5.76,301,1592895600"; 
   d="scan'208";a="171818111"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 09:45:06 -0700
IronPort-SDR: Xyr4BmkhoH5allwCx1J2v5ZZj/pn9A6anrpHZfhvC5mWpsgUNVQEa2eTLRmFdndIgK62uHknbN
 xhXdPQQG9BOA==
X-IronPort-AV: E=Sophos;i="5.76,301,1592895600"; 
   d="scan'208";a="332550145"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.73.16])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 09:45:05 -0700
Date:   Tue, 11 Aug 2020 09:45:04 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Martyna Szapar <martyna.szapar@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH 4.19 47/48] i40e: Memory leak in
 i40e_config_iwarp_qvlist
Message-ID: <20200811094504.000068bb@intel.com>
In-Reply-To: <20200811124614.2myealhkhnla6v3a@duo.ucw.cz>
References: <20200810151804.199494191@linuxfoundation.org>
        <20200810151806.541597863@linuxfoundation.org>
        <20200811124614.2myealhkhnla6v3a@duo.ucw.cz>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Aug 2020 14:46:14 +0200
Pavel Machek <pavel@denx.de> wrote:

> > --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> > @@ -449,16 +450,19 @@ static int i40e_config_iwarp_qvlist(stru
> >  			 "Incorrect number of iwarp vectors %u.
> > Maximum %u allowed.\n", qvlist_info->num_vectors,
> >  			 msix_vf);
> > -		goto err;
> > +		ret = -EINVAL;
> > +		goto err_out;
> >  	}
> 
> And it is no longer freeing data qvlist_info() in this path. Is that
> correct? Should it goto err_free instead? 

Hi Pavel, thanks for the review.

I believe it is still correct, the logic is a bit convoluted, but
tracing back, I see that the caller in i40e_main.c allocates a buffer,
calls this function (eventually) with that memory cast to the *input*
variable qvlist_info, and then the top caller frees the original buffer.

One thing that I'll admit is confusing here is that the *input* struct
qvlist_info is different than the vf->qvlist_info struct managed by
this function. Maybe that they have the same name was confusing to you?
It confused me for a moment while I investigated, but I believe there
is no actual problem.

The reason for the function working this way is that the input data is
from the VF message, and the driver data structures in the PF (i40e)
driver representing state of the VF are managed separately. 

Jesse
