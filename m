Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA190AC7C7
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 18:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406770AbfIGQ4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 12:56:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:55496 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404220AbfIGQ4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Sep 2019 12:56:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Sep 2019 09:56:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,478,1559545200"; 
   d="scan'208";a="195743666"
Received: from perezfra-mobl.ger.corp.intel.com ([10.249.34.186])
  by orsmga002.jf.intel.com with ESMTP; 07 Sep 2019 09:55:56 -0700
Message-ID: <c41c38aa288d92502edf72f8c8f34f58c251db00.camel@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 4.19 126/167] tpm: Fix TPM 1.2 Shutdown sequence
 to prevent future TPM operations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Doug Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        linux-integrity@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Date:   Sat, 07 Sep 2019 19:55:53 +0300
In-Reply-To: <CAD=FV=W0YodeoOCiCv9zmv+-gswuU8U_XgrBnesE=wynTbDBiA@mail.gmail.com>
References: <20190903162519.7136-1-sashal@kernel.org>
         <20190903162519.7136-126-sashal@kernel.org>
         <CAD=FV=W0YodeoOCiCv9zmv+-gswuU8U_XgrBnesE=wynTbDBiA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-09-03 at 09:39 -0700, Doug Anderson wrote:
> Hi,
> 
> On Tue, Sep 3, 2019 at 9:28 AM Sasha Levin <sashal@kernel.org> wrote:
> > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > 
> > [ Upstream commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 ]
> > 
> > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > future TPM operations. TPM 1.2 behavior was different, future TPM
> > operations weren't disabled, causing rare issues. This patch ensures
> > that future TPM operations are disabled.
> > 
> > Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> > [dianders: resolved merge conflicts with mainline]
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/char/tpm/tpm-chip.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Jarkko: did you deal with the issues that came up in response to my
> post?  Are you happy with this going into 4.19 stable at this point?
> I notice this has your Signed-off-by so maybe?

No I have not dealt with the issues yet. The last thing I've said about
this is:

https://lore.kernel.org/stable/20190805210501.vjtmwgxjg334vtnc@linux.intel.com/

I was actually going to look into this during the plane trip to Lissabon
tomorrow morning. I have in mind that this needs to be backported first:

db4d8cb9c9f2 ("tpm: use tpm_try_get_ops() in tpm-sysfs.c.")

/Jarkko

