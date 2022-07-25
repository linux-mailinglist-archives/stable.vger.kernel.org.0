Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9149E57FE9B
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 13:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiGYLuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 07:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiGYLuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 07:50:05 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FF3DF4A;
        Mon, 25 Jul 2022 04:50:04 -0700 (PDT)
Received: from quatroqueijos (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 0C31D3F11C;
        Mon, 25 Jul 2022 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1658749802;
        bh=azjCJStYinlUJkGMIRNeZrFjUm/sCt/hfpBDbAEn+tQ=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=eKDHv04jEAYFHhgugB5OGbPXzYU8hXVTUZzwQUZMuKH6Ik4JJPlj6pBYSCu3CcZGC
         NKTSpjgl+g8qKa9ir3t0/lG7GikRSRYc/F9arW61g6ZCSBRhFPEOg9c6BtrzlGx+pV
         W5xzFEPouViUrJNdd5eyjovPVb9e/jUr4LxtsKMeTS37P1bzO73OUlNtX9wznzKVDf
         G+pR9HJ9uQIBUU4YC23NPGBpqEExLezNTPiss4PqRMiRQmJVV9nG5ndSCoSsf3rz7n
         ae8Ohbpj8yyFcbXeh1JfO2yBb33u3Q8vDThsa0755EIwtv2nWYRrU+1Z2LqkOSs3xo
         DDp+8ARn5CehQ==
Date:   Mon, 25 Jul 2022 08:49:56 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bpetkov@suse.de>
Subject: Re: [PATCH 5.18 13/70] objtool: skip non-text sections when adding
 return-thunk sites
Message-ID: <Yt6DZB7Cmp6xYU/H@quatroqueijos>
References: <20220722090650.665513668@linuxfoundation.org>
 <20220722090651.464856922@linuxfoundation.org>
 <8a4f10b1-70b3-25fe-9ffc-4f24a1531139@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a4f10b1-70b3-25fe-9ffc-4f24a1531139@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

That's because RESERVE_BRK adds a function to .discard.text before upstream
commit a1e2c031ec3949b8c039b739c0b5bf9c30007b00 ("x86/mm: Simplify
RESERVE_BRK()").

Picking up that commit alone was frowned upon because it caused some
problems that were still under investigation.

Cascardo.

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
> 
> thanks,
> -- 
> js
> suse labs
