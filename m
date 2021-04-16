Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBFB361E3B
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbhDPKtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 06:49:14 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38984 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240598AbhDPKtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 06:49:08 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 478BF92009C; Fri, 16 Apr 2021 12:48:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4041792009B;
        Fri, 16 Apr 2021 12:48:42 +0200 (CEST)
Date:   Fri, 16 Apr 2021 12:48:42 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Joe Perches <joe@perches.com>
cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
In-Reply-To: <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com>
Message-ID: <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>  <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk> <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021, Joe Perches wrote:

> In patch 2, vscnprintf should probably be used to make sure it's
> 0 terminated.

 Why?  C99 has this[1]:

"The vsnprintf function is equivalent to snprintf, with the variable 
argument list replaced by arg, which shall have been initialized by the 
va_start macro (and possibly subsequent va_arg calls)."

and then[2]:

"The snprintf function is equivalent to fprintf, except that the output 
is written into an array (specified by argument s) rather than to a 
stream.  If n is zero, nothing is written, and s may be a null pointer. 
Otherwise, output characters beyond the n-1st are discarded rather than 
being written to the array, and a null character is written at the end 
of the characters actually written into the array."

therefore output from `vsnprintf' is always null-terminated.

> And while it's a lot more code, I'd prefer a solution that looks more
> like the other commonly used kernel logging extension mechanisms
> where adapter is placed before the format, ... in the argument list.

 I agree having `adapter' as the second argument seems weird, so that is 
fine with me as a follow-up cleanup.  However as a user-visible change I 
think the fix I propose here ought to be applied first (and backported 
as suitable).  Then any internal clean-ups can follow, applied to trunk 
only.

> And there's a simple addition of a blogic_cont macro and extension
> to blogic_msg to simplify the logic and obviousness of the logging
> extension lines too.

 I did this first actually, before I realised a simpler change suitable 
for backporting could be done.  I'm not sure if that complex message 
routing via `blogic_msg' is worth having even, rather than calling 
`printk' or suitable variants directly.

References:

[1] "Programming languages -- C", INTERNATIONAL STANDARD, ISO/IEC 9899, 
    Second edition, 1999-12-01, Section 7.19.6.12 "The vsnprintf 
    function", p.293

[2] same, 7.19.6.5 "The snprintf function", p.289

  Maciej
