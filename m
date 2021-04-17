Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12A8362C48
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 02:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbhDQAJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 20:09:51 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:34400 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234999AbhDQAJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 20:09:51 -0400
Received: from omf09.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id CC906182CED34;
        Sat, 17 Apr 2021 00:09:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id 66D9C1E04D4;
        Sat, 17 Apr 2021 00:09:23 +0000 (UTC)
Message-ID: <8cf34ba1ecc98fd16eb29d298e7a924db810923d.camel@perches.com>
Subject: Re: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
From:   Joe Perches <joe@perches.com>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Fri, 16 Apr 2021 17:09:21 -0700
In-Reply-To: <a5a70c48-d980-b0e0-6bbd-34dae9c59c59@gonehiking.org>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
         <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>
         <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com>
         <a5a70c48-d980-b0e0-6bbd-34dae9c59c59@gonehiking.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 66D9C1E04D4
X-Spam-Status: No, score=0.10
X-Stat-Signature: fhwd9n9k5g43ak3wfbp58uw5n17m7nwr
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19ybrwbqstP3pzcDcR7uo67LPUjBpaEE1c=
X-HE-Tag: 1618618163-710678
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-04-16 at 14:41 -0600, Khalid Aziz wrote:
> On 4/15/21 8:08 PM, Joe Perches wrote:
> > And while it's a lot more code, I'd prefer a solution that looks more
> > like the other commonly used kernel logging extension mechanisms
> > where adapter is placed before the format, ... in the argument list.
> 
> Hi Joe,
> 
> I don't mind making these changes. It is quite a bit of code but
> consistency with other kernel code is useful. Would you like to finalize
> this patch, or would you prefer that I take this patch as starting point
> and finalize it?

Probably better to apply Maciej's patches first and then something
like this.

btw: the coccinelle script was

@@
expression a, b;
@@

	\(blogic_announce\|blogic_info\|blogic_notice\|blogic_warn\|blogic_err\)(
-		a, b
+		b, a
		, ...)


