Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F533F3026
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhHTPvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 11:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241195AbhHTPvb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 11:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22846610FF;
        Fri, 20 Aug 2021 15:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629474653;
        bh=sIZQJdeQo+NqJE2KGZmLQeNMkwh4uu//4yYwZFjD3y0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s09SvCLj1uqQUR0Q5tbmN47Tw8m3PlRFK5qq3kSZrfBVGIMEr+BE0NMWEMv8T3zw3
         QOCUJjIVPNRSYvWeS3+W5A9lnkBBBze0wcOYnRayZEfK5L+fAd5NPiE34iT76qjhWD
         rVXPOHQdVKvj7Kfqw9qu4uSNMjkY+6TzWBXg2a5dgz+G6q3DDrbm6X0HWqL8pi6hT0
         Vo5nAgWfNzZrRK9otPZV0FaLalhhxjWyHJ/M6jA0R9FbctN7cEX3XjfwpD7iq71ZJN
         wg0nYiJw3K8hy/0P5lcC/ZMjeepEHoWOnV6RboA3vgkwhqo7e1uogwGwI8RDzLlshM
         21E/WCrTBZhDA==
Message-ID: <7efb04fe6e0c867e7c87d75cf3349221b08b4210.camel@kernel.org>
Subject: Re: [PATCH v2 1/2] fs: warn about impending deprecation of
 mandatory locks
From:   Jeff Layton <jlayton@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "david@redhat.com" <david@redhat.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "w@1wt.eu" <w@1wt.eu>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Fri, 20 Aug 2021 11:50:51 -0400
In-Reply-To: <c1318459eaab436aacb225982c49c4b4@AcuMS.aculab.com>
References: <20210820135707.171001-1-jlayton@kernel.org>
         <20210820135707.171001-2-jlayton@kernel.org>
         <c1318459eaab436aacb225982c49c4b4@AcuMS.aculab.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-08-20 at 15:49 +0000, David Laight wrote:
> From: Jeff Layton
> > Sent: 20 August 2021 14:57
> > 
> > We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
> > have disabled it. Warn the stragglers that still use "-o mand" that
> > we'll be dropping support for that mount option.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/namespace.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index ab4174a3c802..ffab0bb1e649 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -1716,8 +1716,16 @@ static inline bool may_mount(void)
> >  }
> > 
> >  #ifdef	CONFIG_MANDATORY_FILE_LOCKING
> > +static bool warned_mand;
> >  static inline bool may_mandlock(void)
> >  {
> > +	if (!warned_mand) {
> > +		warned_mand = true;
> > +		pr_warn("======================================================\n");
> > +		pr_warn("WARNING: the mand mount option is being deprecated and\n");
> > +		pr_warn("         will be removed in v5.15!\n");
> > +		pr_warn("======================================================\n");
> > +	}
> >  	return capable(CAP_SYS_ADMIN);
> >  }
> 
> If that is called more than once you don't want the 'inline'.
> I doubt it matters is not inlined - hardly a hot path.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

ACK. Of course. That really needs to not be inline. I'll fix that up in
my tree.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

