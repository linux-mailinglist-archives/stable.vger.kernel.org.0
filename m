Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBE76EB613
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 02:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjDVADf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 20:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbjDVADV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 20:03:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6265726B5;
        Fri, 21 Apr 2023 17:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=38uIKrEkm/KHYjQ9Ld2WXvwa9CxwZa7VCqEcFp/aR3U=; b=B9ID0WJg5NwnBuxfJ/ItrM5eb0
        wDirm9AZhAj6AcqEcFoinxIjZX1dnypg6RBnfcNTOldLtDU+Tbb2Y6xUC3dOOmEEtSyta56OTCX4P
        L/JK+aaSRsEwS2giC6+bUg3wVxrfv94OG3K/XwlIZpsgB+K2mpbuUghA1Hd/4RnCGWgefxoy8CGka
        j+rQyfPUpUZho0VRFLR7qnKy/O1RCq19JaNu+3X1n6ny1BfMYuUyWCcGTzI7pDGKxIn7/rnJSHooU
        5YLkUBRwP095/yvt8k0diIj2e6mUQMhzLfbeIoqllvXm1yWitz4Ox8UCxsPY0qNQZmizIyVOBnl1g
        0g/SHlmQ==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pq0ii-00C7Mx-2a;
        Sat, 22 Apr 2023 00:03:16 +0000
Message-ID: <bc5a2d13-4829-0c5a-837d-8842e16cd997@infradead.org>
Date:   Fri, 21 Apr 2023 17:03:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 stable-5.10.y stable-5.15.y] docs: futex: Fix
 kernel-doc references after code split-up preparation
Content-Language: en-US
To:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
References: <20230421221741.1827866-1-carnil@debian.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230421221741.1827866-1-carnil@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please see https://lore.kernel.org/all/20211012135549.14451-1-andrealmeid@collabora.com/

Don't know what has happened to it though.  :(


On 4/21/23 15:17, Salvatore Bonaccorso wrote:
> In upstream commit 77e52ae35463 ("futex: Move to kernel/futex/") the
> futex code from kernel/futex.c was moved into kernel/futex/core.c in
> preparation of the split-up of the implementation in various files.
> 
> Point kernel-doc references to the new files as otherwise the
> documentation shows errors on build:
> 
>     [...]
>     Error: Cannot open file ./kernel/futex.c
>     Error: Cannot open file ./kernel/futex.c
>     [...]
>     WARNING: kernel-doc './scripts/kernel-doc -rst -enable-lineno -sphinx-version 3.4.3 -internal ./kernel/futex.c' failed with return code 2
> 
> There is no direct upstream commit for this change. It is made in
> analogy to commit bc67f1c454fb ("docs: futex: Fix kernel-doc
> references") applied as consequence of the restructuring of the futex
> code.
> 
> Fixes: 77e52ae35463 ("futex: Move to kernel/futex/")
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> ---
> v1->v2:
>  - Fix typo in description about new target file for futex.c code
>  - Indent block with build log output
> 
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

-- 
~Randy
