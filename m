Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C731B5952
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgDWKgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgDWKgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 06:36:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DED82076C;
        Thu, 23 Apr 2020 10:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587638167;
        bh=dcQzLmS0nIrgvvTOLWWVEt9Wyrt0M+sXg/izf9Lphoc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DpRfZQg93kPq+NB5kRXK+0gi7vTUWZJEcMkPL4bLUT8Mn06YFbIHNqSgumKytRheK
         egyhylx8ahLXwnFSITwAU0fGKp3PmVrKVmaXmZAPfNixpMJSbWPkRKul84rseZt071
         yivGiCmpOZFGyHNj+kw6iEpBW3+1JY/2U+HlpHpg=
Date:   Thu, 23 Apr 2020 12:36:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/125] 4.9.220-rc1 review
Message-ID: <20200423103604.GA3730645@kroah.com>
References: <20200422095032.909124119@linuxfoundation.org>
 <20200422203430.GA52250@roeck-us.net>
 <20200422205402.GA135017@roeck-us.net>
 <20200423080258.GA3496846@kroah.com>
 <a4c8ab22-6e93-9b94-f29e-2d8c1ae1d1f2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4c8ab22-6e93-9b94-f29e-2d8c1ae1d1f2@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 03:26:23AM -0700, Guenter Roeck wrote:
> On 4/23/20 1:02 AM, Greg Kroah-Hartman wrote:
> > On Wed, Apr 22, 2020 at 01:54:02PM -0700, Guenter Roeck wrote:
> >> On Wed, Apr 22, 2020 at 01:34:30PM -0700, Guenter Roeck wrote:
> >>> On Wed, Apr 22, 2020 at 11:55:17AM +0200, Greg Kroah-Hartman wrote:
> >>>> This is the start of the stable review cycle for the 4.9.220 release.
> >>>> There are 125 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>
> >>> I see a number of unit test crashes in ppc images. Looks like UAF.
> >>> This affects 4.4.y, 4.9.y, and 4.14.y. I'll bisect.
> >>>
> >>
> >> Bisect log attached. I suspect the real culprit is commit a4f91f0de905
> >> ("of: unittest: clean up changeset test"), or at least it changes the
> >> code enough for the offending patch not to work in v4.14.y and older.
> >> Either case, reverting upstream commit b3fb36ed694b ("of: unittest:
> >> kmemleak on changeset destroy") fixes the problem and thus needs to
> >> be dropped from v4.4.y, v4.9.y, and v4.14.y.
> > 
> > Thanks for letting me know, I've now dropped it from all of those trees.
> > 
> 
> Did you (or do you plan to) push the updated branches ? My builders
> didn't pick it up yet.

Sorry about that, have now pushed out a -rc2 for all of those 3
branches.

greg k-h
