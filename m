Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F7BB30AA
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 17:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbfIOPTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 11:19:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:64042 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbfIOPTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Sep 2019 11:19:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 08:19:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,509,1559545200"; 
   d="scan'208";a="193230922"
Received: from uiqbal-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.54.112])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Sep 2019 08:19:30 -0700
Date:   Sun, 15 Sep 2019 16:19:24 +0100
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Doug Anderson <dianders@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        linux-integrity@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH AUTOSEL 4.19 126/167] tpm: Fix TPM 1.2 Shutdown sequence
 to prevent future TPM operations
Message-ID: <20190915151924.GA30709@linux.intel.com>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-126-sashal@kernel.org>
 <CAD=FV=W0YodeoOCiCv9zmv+-gswuU8U_XgrBnesE=wynTbDBiA@mail.gmail.com>
 <20190903165346.hwqlrin77cmzjiti@cantor>
 <20190903194335.GG5281@sasha-vm>
 <f2224c094836a4b8989c1cd6243a0b7ad1261a87.camel@linux.intel.com>
 <20190907220448.GB2012@sasha-vm>
 <20190909162808.ggcnrtvbvor7deqy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909162808.ggcnrtvbvor7deqy@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 09, 2019 at 05:28:08PM +0100, Jarkko Sakkinen wrote:
> On Sat, Sep 07, 2019 at 06:04:48PM -0400, Sasha Levin wrote:
> > On Sat, Sep 07, 2019 at 09:55:18PM +0300, Jarkko Sakkinen wrote:
> > > On Tue, 2019-09-03 at 15:43 -0400, Sasha Levin wrote:
> > > > Right. I gave a go at backporting a few patches and this happens to be
> > > > one of them. It will be a while before it goes in a stable tree
> > > > (probably way after after LPC).
> > > 
> > > It *semantically* depends on
> > > 
> > > db4d8cb9c9f2 ("tpm: use tpm_try_get_ops() in tpm-sysfs.c.")
> > > 
> > > I.e. can cause crashes without the above patch. As a code change your
> > > patch is fine but it needs the above patch backported to work in stable
> > > manner.
> > > 
> > > So... either I can backport that one (because ultimately I have
> > > responsibility to do that as the maintainer) but if you want to finish
> > > this one that is what you need to backport in addition and then it
> > > should be fine.
> > 
> > If you're ok with the backport of this commit, I can just add
> > db4d8cb9c9f2 on top.
> 
> Sure, I've already gave my promise to do that :-)

I ended up with:

db4d8cb9c9f2 tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations
2677ca98ae37 tpm: use tpm_try_get_ops() in tpm-sysfs.c.
da379f3c1db0 tpm: migrate pubek_show to struct tpm_buf

Since some time has passed I'l just restate that the reason for
backporting 2677ca98ae37 was that tpm_class_shutdown() could pull carpet
under the TPM 1.2 code. tpm_try_get_ops() makes sure that read lock is
taken and chip->ops is not NULL if it successfully returns.

Still need to test the patches with TPM 1.2 hardware before I can send
them.

/Jarkko
