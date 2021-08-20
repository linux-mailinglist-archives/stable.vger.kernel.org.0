Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786453F3119
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhHTQI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 12:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236566AbhHTQHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 12:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A85A6120F;
        Fri, 20 Aug 2021 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629475601;
        bh=1QCYUd2guY39hOw2llzjvrTtJB7CGjys+kLQwo6Btmk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mZ/2JBAHhQl+eLZehCg7K2AqdaLVrvNPVWtiwJpj9/WxH2/4paCHgwGuF4KuYVMem
         kV1J/Y7kvOvoSfG978r2jnfAZZvcoX/Eecq1N6ZgxSbOc7zxyOZB9WyYFNcXahUSLi
         n/rDVzyVbUfQ5An4kAvT3elU/aXGLU38xGCvg6BDc10/SzoehmUYy7V1F4G8k5AnRW
         rMbeyULqvkLRh6f0IhSkIIRRezMofzLEVqwfTQE35yxvF3SPBXcjNl7ykQUgaJJhvO
         wSioQS7ATqTAvZqIeMwP2/wQhQH5Ir3ppq6qag08FDJlnDHFisROCFg/QDGUZaO/ER
         VkLpu8WxV43Yg==
Message-ID: <5c533ef663b9447206754c46afcab65d107dd207.camel@kernel.org>
Subject: Re: [PATCH v2 1/2] fs: warn about impending deprecation of
 mandatory locks
From:   Jeff Layton <jlayton@kernel.org>
To:     David Hildenbrand <david@redhat.com>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ebiederm@xmission.com, willy@infradead.org,
        linux-nfs@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-doc@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org,
        akpm@linux-foundation.org, luto@kernel.org, bfields@fieldses.org,
        w@1wt.eu, rostedt@goodmis.org, stable@vger.kernel.org
Date:   Fri, 20 Aug 2021 12:06:38 -0400
In-Reply-To: <0f4f3e65-1d2d-e512-2a6f-d7d63effc479@redhat.com>
References: <20210820135707.171001-1-jlayton@kernel.org>
         <20210820135707.171001-2-jlayton@kernel.org>
         <0f4f3e65-1d2d-e512-2a6f-d7d63effc479@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-08-20 at 17:52 +0200, David Hildenbrand wrote:
> On 20.08.21 15:57, Jeff Layton wrote:
> > We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
> > have disabled it. Warn the stragglers that still use "-o mand" that
> > we'll be dropping support for that mount option.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/namespace.c | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index ab4174a3c802..ffab0bb1e649 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -1716,8 +1716,16 @@ static inline bool may_mount(void)
> >   }
> >   
> >   #ifdef	CONFIG_MANDATORY_FILE_LOCKING
> > +static bool warned_mand;
> >   static inline bool may_mandlock(void)
> >   {
> > +	if (!warned_mand) {
> > +		warned_mand = true;
> > +		pr_warn("======================================================\n");
> > +		pr_warn("WARNING: the mand mount option is being deprecated and\n");
> > +		pr_warn("         will be removed in v5.15!\n");
> > +		pr_warn("======================================================\n");
> > +	}
> 
> Is there a reason not to use pr_warn_once() ?
> 
> 

No reason at all. I'll send out a v3 set in a bit with that change.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

