Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF79411D326
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 18:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbfLLRGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 12:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730005AbfLLRGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 12:06:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0FE82073B;
        Thu, 12 Dec 2019 17:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576170412;
        bh=/2TfefZUZ/PBYTWkQMOOD3hivOW0+Y3jr1avQv7wJ/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I+g81QuFI0YabbMJbHX4SJZCVcBxULZ4RPT/LY8+aPYk+kMvGGxgilAluqKLGIYko
         pGRpB0AoV1ww4+MMY4jYNdNqHfBMG0KkWvUd0ePiZKCNPviG0WWuX1uryp8P9GYYcY
         1ztOd8gAlOK+5lQKddhjIzBaOC0JmUDTM4b4yXQ8=
Date:   Thu, 12 Dec 2019 18:06:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Jann Horn <jannh@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4.9 45/47] Smack: Dont ignore other bprm->unsafe flags if
 LSM_UNSAFE_PTRACE is set
Message-ID: <20191212170649.GA1681017@kroah.com>
References: <20191006172016.873463083@linuxfoundation.org>
 <20191006172019.260683324@linuxfoundation.org>
 <64c5b8b423774029c3030ae778bf214d36499d2a.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64c5b8b423774029c3030ae778bf214d36499d2a.camel@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 03:50:07PM +0000, Ben Hutchings wrote:
> On Sun, 2019-10-06 at 19:21 +0200, Greg Kroah-Hartman wrote:
> > From: Jann Horn <jannh@google.com>
> > 
> > commit 3675f052b43ba51b99b85b073c7070e083f3e6fb upstream.
> [...]
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -949,7 +949,8 @@ static int smack_bprm_set_creds(struct l
> >  
> >  		if (rc != 0)
> >  			return rc;
> > -	} else if (bprm->unsafe)
> > +	}
> > +	if (bprm->unsafe & ~LSM_UNSAFE_PTRACE)
> 
> I think this needs to be ~(LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)
> for 4.9 and older branches.

Why?  Where did the LSM_UNSAFE_PTRACE_CAP requirement come from (or
really, go away?)

thanks,

greg k-h
