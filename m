Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D7457FB75
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 10:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiGYIhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 04:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiGYIhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 04:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661DF13F89;
        Mon, 25 Jul 2022 01:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 135DDB80DDC;
        Mon, 25 Jul 2022 08:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227FDC341C6;
        Mon, 25 Jul 2022 08:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658738232;
        bh=+KW+70dQ2sLM3hx9zErNZIYUe9CxAaQYy2AEgGMfL94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vChsJmDaTSw9+lR6RVvvv11sDaBwCReHrjR18LsSLhq+QccNOGqfVj4LmDme6v3XF
         s9EOs0tlm8AyGwkZOcdwuYttxNkYi4+vS4prDnDDUIVtgJ9GiC+rAWRHM8Tt5vDzr0
         AYRW1C1A76OALa02oVu/aG9S0k4OLsjcRf2esA8w=
Date:   Mon, 25 Jul 2022 10:37:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bpetkov@suse.de>
Subject: Re: [PATCH 5.18 13/70] objtool: skip non-text sections when adding
 return-thunk sites
Message-ID: <Yt5WM/0k36vV3wv0@kroah.com>
References: <20220722090650.665513668@linuxfoundation.org>
 <20220722090651.464856922@linuxfoundation.org>
 <8a4f10b1-70b3-25fe-9ffc-4f24a1531139@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a4f10b1-70b3-25fe-9ffc-4f24a1531139@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 25, 2022 at 07:44:08AM +0200, Jiri Slaby wrote:
> Hi,
> 
> I wonder, why this is needed in stable and not mainline?
> 
> Isn't this a different (non-upstream) dup of
> 951ddecf4356 objtool: Treat .text.__x86.* as noinstr
> ? (That is included in this release too.)
> 
> On 22. 07. 22, 11:07, Greg Kroah-Hartman wrote:
> > From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > 
> > The .discard.text section is added in order to reserve BRK, with a
> > temporary function just so it can give it a size. This adds a relocation to
> > the return thunk, which objtool will add to the .return_sites section.
> > Linking will then fail as there are references to the .discard.text
> > section.
> > 
> > Do not add instructions from non-text sections to the list of return thunk
> > calls, avoiding the reference to .discard.text.
> > 
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   tools/objtool/check.c |    4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > --- a/tools/objtool/check.c
> > +++ b/tools/objtool/check.c
> > @@ -1308,7 +1308,9 @@ static void add_return_call(struct objto
> >   	insn->type = INSN_RETURN;
> >   	insn->retpoline_safe = true;
> > -	list_add_tail(&insn->call_node, &file->return_thunk_list);
> > +	/* Skip the non-text sections, specially .discard ones */
> > +	if (insn->sec->text)
> > +		list_add_tail(&insn->call_node, &file->return_thunk_list);
> >   }
> >   static bool same_function(struct instruction *insn1, struct instruction *insn2)
> > 
> > 

I'll let Thadeu reply here, as he did this backport series.

thanks,

greg k-h
