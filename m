Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406605FC588
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 14:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiJLMmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 08:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJLMmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 08:42:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06957C895E;
        Wed, 12 Oct 2022 05:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A92A9B81A84;
        Wed, 12 Oct 2022 12:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C66C433D7;
        Wed, 12 Oct 2022 12:42:24 +0000 (UTC)
Date:   Wed, 12 Oct 2022 08:42:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] tracing: Add "(fault)" name injection to kernel
 probes
Message-ID: <20221012084224.114c9e12@rorschach.local.home>
In-Reply-To: <13544aa157fc4083a59127bbc5a2bb1e@AcuMS.aculab.com>
References: <20221012104055.421393330@goodmis.org>
        <20221012104534.644803645@goodmis.org>
        <13544aa157fc4083a59127bbc5a2bb1e@AcuMS.aculab.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Oct 2022 12:34:45 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> > @@ -13,8 +15,16 @@ static nokprobe_inline int
> >  kern_fetch_store_strlen_user(unsigned long addr)
> >  {
> >  	const void __user *uaddr =  (__force const void __user *)addr;
> > +	int ret;
> > 
> > -	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
> > +	ret = strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
> > +	/*
> > +	 * strnlen_user_nofault returns zero on fault, insert the
> > +	 * FAULT_STRING when that occurs.
> > +	 */
> > +	if (ret <= 0)
> > +		return strlen(FAULT_STRING) + 1;
> > +	return ret;
> >  }  
> 
> Isn't that going to do the wrong thing if the user
> string is valid memory but just zero length??

I thought so at first (and was in the process of changing things
because of that) until I saw the comment above this code:

/* Return the length of string -- including null terminal byte */

And looking the function of strnlen_user_nofault():

* Returns the size of the string INCLUDING the terminating NUL.

That is, it returns 1 on a zero length string and 0 on fault :-p

Yes, I think we should fix that API, but that's another story.

-- Steve
