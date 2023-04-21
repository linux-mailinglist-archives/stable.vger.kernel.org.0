Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204EF6EB372
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 23:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjDUVNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 17:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjDUVNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 17:13:35 -0400
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30751A8;
        Fri, 21 Apr 2023 14:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=52NtA3JB/XmoHgtERqN2dcuDYE9sR3LLAJHMFpHloW4=; b=apKr8PI52BfBTwztDmazT2CW97
        gnezCFkSqJc48UfEN5PNWSEtVt4aXq8B1e0VeJiW1OQocrmGXjXJ1B+y57xKQa9ZXrfbge+syt8I6
        alCAcMLRq3zZjoN+Zxt8TdZIskGN8XtdwxQZQj4DohcJMFj2UHBSBatDt0CjiMLpifraWJLN1bOyg
        vHnd0oLaIdGmTj3wc9KZeZ3UY2Hmt2hiCghxNxGksbmgdgEO9f3N005y4GkYMt+KMwOm3WRJcLFOl
        AdHnXmdLrGsRBW4vx6px68gFQU6IXhRfbwzkq+SGxPxUtFYIbtpaMo4Ob2QOw5nJYSmeIJS0gDNib
        wRuryeEA==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <carnil@debian.org>)
        id 1ppy4A-007mch-Bd; Fri, 21 Apr 2023 21:13:14 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
        id 1E489BE2DE0; Fri, 21 Apr 2023 23:13:13 +0200 (CEST)
Date:   Fri, 21 Apr 2023 23:13:13 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] docs: futex: Fix kernel-doc references after code
 split-up preparation
Message-ID: <ZEL8aRt2GMTP9IhE@eldamar.lan>
References: <20230421210531.1816665-1-carnil@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421210531.1816665-1-carnil@debian.org>
X-Debian-User: carnil
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Apr 21, 2023 at 11:05:31PM +0200, Salvatore Bonaccorso wrote:
> In upstream commit 77e52ae35463 ("futex: Move to kernel/futex/") the
> futex code from kernel/futex.c was moved into kernel/futex/core in
> preparation of the split-up of the implementation in various files.
> 
> Point kernel-doc references to the new files as otherwise the
> documentation shows errors on build:
> 
> [...]
> Error: Cannot open file ./kernel/futex.c
> Error: Cannot open file ./kernel/futex.c
> [...]
> WARNING: kernel-doc './scripts/kernel-doc -rst -enable-lineno -sphinx-version 3.4.3 -internal ./kernel/futex.c' failed with return code 2
> 
> There is no direct upstream commit for this change. It is made in
> analogy to commit bc67f1c454fb ("docs: futex: Fix kernel-doc
> references") applied as consequence of the restructuring of the futex
> code.
> 
> Fixes: 77e52ae35463 ("futex: Move to kernel/futex/")
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> ---
>  Documentation/kernel-hacking/locking.rst                    | 2 +-
>  Documentation/translations/it_IT/kernel-hacking/locking.rst | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kernel-hacking/locking.rst b/Documentation/kernel-hacking/locking.rst
> index 6ed806e6061b..a6d89efede79 100644
> --- a/Documentation/kernel-hacking/locking.rst
> +++ b/Documentation/kernel-hacking/locking.rst
> @@ -1358,7 +1358,7 @@ Mutex API reference
>  Futex API reference
>  ===================
>  
> -.. kernel-doc:: kernel/futex.c
> +.. kernel-doc:: kernel/futex/core.c
>     :internal:
>  
>  Further reading
> diff --git a/Documentation/translations/it_IT/kernel-hacking/locking.rst b/Documentation/translations/it_IT/kernel-hacking/locking.rst
> index bf1acd6204ef..192ab8e28125 100644
> --- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
> +++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
> @@ -1400,7 +1400,7 @@ Riferimento per l'API dei Mutex
>  Riferimento per l'API dei Futex
>  ===============================
>  
> -.. kernel-doc:: kernel/futex.c
> +.. kernel-doc:: kernel/futex/core.c
>     :internal:
>  
>  Approfondimenti
> -- 
> 2.40.0

I had this information in my original subject passed to git
send-email, but got lost: As 77e52ae35463 ("futex: Move to
kernel/futex/") was backported to the stable-5.10.y series in
5.10.163, and to stable-5.15.y in 5.15.86, this is only needed for
those two stable series.

Regards,
Salvatore
