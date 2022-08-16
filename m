Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E551059590B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiHPK4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiHPKzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:55:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA939240AA
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 03:24:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11ED561314
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 10:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BA1C433D6;
        Tue, 16 Aug 2022 10:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660645441;
        bh=OGnyQznwhkmE0Q7EHLDZmctSjbtj808bOFOKnuZOwi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WahpJZECpAyMYMcXF4qwRGqr9IGicSzyy/uA5UVDr/8unlGoepk1vWHNtOJ1SwpOo
         AXdOCqSgQa4FALk5sNQiquWPMo7AelV+aMAeSj3AFqwZkIQAtfheoGXqUaSnRJ3xeQ
         oIhQKO+OSk7lWAK+km4nkeUqI/Wzc4fHHgZ+KEw4=
Date:   Tue, 16 Aug 2022 12:23:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, paul.gortmaker@windriver.com,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org
Subject: Re: [PATCH 1/3] Revert "x86/ftrace: Use alternative RET encoding"
Message-ID: <YvtwPpKJ5nqfmTFf@kroah.com>
References: <20220816041224.GE73154@windriver.com>
 <20220816082658.172387-1-cascardo@canonical.com>
 <Yvtg/BOAKHQdU0V6@kroah.com>
 <YvtueWo2F3ZR/Y3r@quatroqueijos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvtueWo2F3ZR/Y3r@quatroqueijos>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 07:16:25AM -0300, Thadeu Lima de Souza Cascardo wrote:
> On Tue, Aug 16, 2022 at 11:18:52AM +0200, Greg KH wrote:
> > On Tue, Aug 16, 2022 at 05:26:56AM -0300, Thadeu Lima de Souza Cascardo wrote:
> > > This reverts commit 3af2ebf798c52b20de827b9dfec13472ab4a7964.
> > > 
> > > This temporarily reverts the backport of upstream commit
> > > 1f001e9da6bbf482311e45e48f53c2bd2179e59c. It was not correct to copy the
> > > ftrace stub as it would contain a relative jump to the return thunk which
> > > would not apply to the context where it was being copied to, leading to
> > > ftrace support to be broken.
> > > 
> > > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > > ---
> > >  arch/x86/kernel/ftrace.c | 7 ++-----
> > >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > What stable tree(s) is this to be for?
> > 
> > Context is everything :)
> > 
> > thanks,
> > 
> > greg k-h
> 
> Yeah, I was just thinking that I missed it, and whether I would be able to
> respond to my own message before you did.  :-)
> 
> This series is targed at 5.15. I will look at 5.10 next.

Thanks, I'll queue this up after the current 5.15-rc is released later
this week.

greg k-h
