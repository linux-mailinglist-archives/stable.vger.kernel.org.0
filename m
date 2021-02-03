Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A940430D01B
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 01:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhBCABv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 19:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhBCABt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 19:01:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA6DE64F69;
        Wed,  3 Feb 2021 00:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612310468;
        bh=bFjw/UazIAR/k4e6VZAcTJndp7aivrLk7pcFoZTEAaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sqoyVuDHO3p4bC2lMIoE7448FQmhnQQz9x0fE1WKcQV4ZsWTDpDHXhVw//NSlBf0b
         1921KP/EuGBWB83jacTfn1+ZaR7K6JxmnmC7TW84bL/XTviZOC3R6cBfC18L3n6A3X
         K/Ef/USmR51xtp3FztbfG1f+1BdyHeP6mxydYZTy7QolOY6iAcQiwngkQRFpi/B+RD
         8+7m70Ygv8ZjPaeqYKdxRhhv6YZNhY3U8qRW39R9ZiTrIIiD+UJ/nS3KmifdkIQsZh
         rHP2KwJo1xs0uGHHfzGYj5BmKr2kOScdIBjVT1P5zlBxj4813Ng4UFtfGysZv0qPi0
         W00310b+oBR7g==
Date:   Wed, 3 Feb 2021 02:01:00 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        linux-integrity@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Wang Hai <wanghai38@huawei.com>
Subject: Re: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
Message-ID: <YBnnvMc+afg63NPQ@kernel.org>
References: <20210202153317.57749-1-jarkko@kernel.org>
 <20210202172651.GA2821@mail.hallyn.com>
 <1d661a6bdf2d7a9a31b3357ef4170a1309cf2aa4.camel@HansenPartnership.com>
 <YBnR2YLitNJzvNBk@kernel.org>
 <957c4efbfa22cb590ea8227718d1bbdcd690410a.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <957c4efbfa22cb590ea8227718d1bbdcd690410a.camel@HansenPartnership.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 03:00:34PM -0800, James Bottomley wrote:
> On Wed, 2021-02-03 at 00:27 +0200, Jarkko Sakkinen wrote:
> > On Tue, Feb 02, 2021 at 09:58:24AM -0800, James Bottomley wrote:
> > > On Tue, 2021-02-02 at 11:26 -0600, Serge E. Hallyn wrote:
> [...]
> > > > 
> > > > Actually in this case I don't understand why _once, especially
> > > > based on the comment.  Would ratelimited not be better?  So we
> > > > can see if it happens repeatedly?  Even better would be if we
> > > > could see when it next gave a valid status after an invalid one.
> > > 
> > > The reason was that we're trying to catch and kill paths to the
> > > status where the locality is incorrect.  If you do some operation
> > > that finds an incorrect path the likelihood is you'll exercise it
> > > more than once, but all we need to identify it is the call trace
> > > from a single access.  The symptom the user space process sees is a
> > > TPM timeout, but we still have the in-kernel trace to tell us why.
> > 
> > I don't agree with this reasoning. This warn could spun off also from
> > chip not following TCG spec.
> 
> If it doesn't follow this basic part of the spec, the chip is unusable
> by us anyway because we need the status to proceed with command
> handling.
> 
> >  The patch does provide the status code, which is always useful
> > information.
> 
> In the wrong locality that will be bus not connected, so likely 0xff. 
> The most useful thing to know is what path triggered the condition
> because the most likely cause is coding error.
> 
> James

I tend to agree for now. Let's focus on collecting the fixes. Thanks.

/Jarkko
