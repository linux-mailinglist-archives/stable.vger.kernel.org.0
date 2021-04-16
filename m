Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F713623A5
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 17:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245504AbhDPPQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 11:16:47 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:48228 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244671AbhDPPOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 11:14:41 -0400
Received: from omf09.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 1E7E7182CED5B;
        Fri, 16 Apr 2021 15:12:05 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id 9F81C1E04DB;
        Fri, 16 Apr 2021 15:12:03 +0000 (UTC)
Message-ID: <9e5a552b8b1f65af3eb4d2371a19c33d97f642d0.camel@perches.com>
Subject: Re: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
From:   Joe Perches <joe@perches.com>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Fri, 16 Apr 2021 08:12:01 -0700
In-Reply-To: <alpine.DEB.2.21.2104161627130.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
          <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>
          <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com>
          <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
         <86c10671ff86f96004a6d6c3c08aed3e27d58d0a.camel@perches.com>
         <alpine.DEB.2.21.2104161627130.44318@angie.orcam.me.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F81C1E04DB
X-Spam-Status: No, score=0.10
X-Stat-Signature: s9mxuosraujha4i8xyc6wiu14nyngk5u
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18h5DhmD5kG2CH6aqwm9teq+oQ9Oz950oY=
X-HE-Tag: 1618585923-648852
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-04-16 at 16:28 +0200, Maciej W. Rozycki wrote:
> On Fri, 16 Apr 2021, Joe Perches wrote:
> 
> > > I'm not sure if that complex message 
> > > routing via `blogic_msg' is worth having even, rather than calling 
> > > `printk' or suitable variants directly.
> > 
> > It's to allow the message content to be added to the internal
> > 	&adapter->msgbuf[adapter->msgbuflen]
> > with strcpy for later use with blogic_show_info()/seq_write.
> 
>  I know, but it's not clear to me if it's worth it (a potential buffer 
> overrun there too, BTW).

It's seq_ output so it's nominally an ABI.
But then again, I don't use this at all so I don't care much either.

It's also odd/bad form that one output KERN_<level> does not match
its blogic_<level> (blogic_info is emitted at KERN_NOTICE)



