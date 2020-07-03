Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A47B213B15
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 15:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgGCNgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 09:36:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43894 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgGCNgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 09:36:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id j12so13997842pfn.10;
        Fri, 03 Jul 2020 06:36:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T5rcVRIkgD/btpU3eP+kPgBcl/ql3dV8wsHC9ym85fc=;
        b=dpoBSKt9u7PzGcULVVkb3BVVTC2SRONI/mFO7qKPCcsTKF4bMSB5wwEDanojpsXGUm
         kwK2J5sW/qcLuKkg7HXJxYyiPTFgMIxbMBQ+qwzZzAGZiC64jo6gJKE9hkQjrT2ecJ8S
         5RRKQHCIYvdyFK6p8pLC2sC1H6ozGDeuAu3brBCsqouH3ULIFK/O+oX+/om3n+zQjJdT
         i4BI8TyxD1kr2/OzeliwlkLweUtmbWBKe/mTeTKXuzLWANMOcwJ90W02jjPdIV88+vZ1
         rvusjmydEGS3A9de9HSIXr5ID45xehpaqNyh7fFMxO40qh2iTESR9gJnLQA82lYLFVNn
         Gdzw==
X-Gm-Message-State: AOAM533w9VkVaasqHDJDD2CoI2ePDu2dMzKUglzB3MmTWtQmnrjBmNQW
        BA3i4NaqP2LGNvo4+SkpaYk=
X-Google-Smtp-Source: ABdhPJzpEuquvHuz9dy6BTpylDSjUJQBr0XwgRqlpSIxXVt6avNzJ3DHhTKXkfB0Cil4QhB/QzoeTw==
X-Received: by 2002:a65:640c:: with SMTP id a12mr28887324pgv.88.1593783360171;
        Fri, 03 Jul 2020 06:36:00 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id m16sm12805082pfd.101.2020.07.03.06.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 06:35:58 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 1885F40945; Fri,  3 Jul 2020 13:35:58 +0000 (UTC)
Date:   Fri, 3 Jul 2020 13:35:58 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        lkft-triage@lists.linaro.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>, chrubis <chrubis@suse.cz>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: af_alg - Fix regression on empty requests
Message-ID: <20200703133558.GX4332@42.do-not-panic.com>
References: <CA+G9fYvHFs5Yx8TnT6VavtfjMN8QLPuXg6us-dXVJqUUt68adA@mail.gmail.com>
 <20200622224920.GA4332@42.do-not-panic.com>
 <CA+G9fYsXDZUspc5OyfqrGZn=k=2uRiGzWY_aPePK2C_kZ+dYGQ@mail.gmail.com>
 <20200623064056.GA8121@gondor.apana.org.au>
 <20200623170217.GB150582@gmail.com>
 <20200626062948.GA25285@gondor.apana.org.au>
 <CA+G9fYutuU55iL_6Qrk3oG3iq-37PaxvtA4KnEQHuLH9YpH-QA@mail.gmail.com>
 <20200702033221.GA19367@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702033221.GA19367@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 01:32:21PM +1000, Herbert Xu wrote:
> On Tue, Jun 30, 2020 at 02:18:11PM +0530, Naresh Kamboju wrote:
> > 
> > Since we are on this subject,
> > LTP af_alg02  test case fails on stable 4.9 and stable 4.4
> > This is not a regression because the test case has been failing from
> > the beginning.
> > 
> > Is this test case expected to fail on stable 4.9 and 4.4 ?
> > or any chance to fix this on these older branches ?
> > 
> > Test output:
> > af_alg02.c:52: BROK: Timed out while reading from request socket.
> > 
> > ref:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.228-191-g082e807235d7/testrun/2884917/suite/ltp-crypto-tests/test/af_alg02/history/
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.228-191-g082e807235d7/testrun/2884606/suite/ltp-crypto-tests/test/af_alg02/log
> 
> Actually this test really is broken.

FWIW the patch "umh: fix processed error when UMH_WAIT_PROC is used" was
dropped from linux-next for now as it was missing checking for signals.
I'll be open coding iall checks for each UMH_WAIT_PROC callers next. Its
not clear if this was the issue with this test case, but figured I'd let
you know.

  Luis
