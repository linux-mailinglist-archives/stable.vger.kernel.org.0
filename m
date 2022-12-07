Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E9B645E38
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 16:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiLGP7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 10:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLGP7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 10:59:30 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A1223BF1;
        Wed,  7 Dec 2022 07:59:29 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 601791FFCE;
        Wed,  7 Dec 2022 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1670428768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p0aSEvHISruuzZjqWWn22P3im5JpJKTcXGdCgqL9wuw=;
        b=1zKXe1Qo9B6atEkE/L5w5iyaXuwH0HhnMMco1Hr9Z8UYZEBsybMX8CjCb+DbYbZj6CoVjU
        566QvxrpAiAOhLdTL+wY1wqPPQImPFHIojk26X9O5CdYa/CfgrGaLMdU3y8r/zvqyjWpS7
        jiSBwFgwmQVhKE8l03YY+PBrbaN3YnQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1670428768;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p0aSEvHISruuzZjqWWn22P3im5JpJKTcXGdCgqL9wuw=;
        b=dAtZVoold3ZIR/nXrY0RvEbRkjpvcMO0Y4cocApzlSsfeFG3v9Hu8HsXftHUjYcteYVYpU
        B3BbZCybHnBfv1Cg==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 01A0F2C141;
        Wed,  7 Dec 2022 15:59:25 +0000 (UTC)
Date:   Wed, 7 Dec 2022 16:59:24 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Michael Jeanson <mjeanson@efficios.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Steven Rostedt <rostedt@goodmis.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Message-ID: <20221207155924.GG28810@kitsune.suse.cz>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
 <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
 <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
 <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
 <dfe0b9ba-828d-e1a5-f9a3-416c6b5b1cf3@efficios.com>
 <87mt81sbxb.fsf@mpe.ellerman.id.au>
 <484763aa-e77b-b599-4786-ef4cdf16d7bd@efficios.com>
 <87cz8wrmm6.fsf@mpe.ellerman.id.au>
 <6db50470-ac37-0328-37a2-760665668b5f@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6db50470-ac37-0328-37a2-760665668b5f@efficios.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Wed, Dec 07, 2022 at 10:18:13AM -0500, Mathieu Desnoyers wrote:
> On 2022-12-06 21:09, Michael Ellerman wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> > > On 2022-12-05 17:50, Michael Ellerman wrote:

> > 
> > Relatedly we have a patch in next to optionally use ABIv2 for 64-bit big
> > endian builds.
> 
> Interesting. Does it require a matching user-space ? (built with PPC64 ABIv2

No, the kernel and userspace ABI is separate.

> ?) Does it handle legacy PPC32 executables ?

Theoretically it should. No idea if anybody has tested it.

Thanks

Michal
