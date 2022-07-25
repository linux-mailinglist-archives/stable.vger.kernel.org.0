Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A6657F918
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 07:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiGYFoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 01:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiGYFoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 01:44:12 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8597658;
        Sun, 24 Jul 2022 22:44:11 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id b6so6102780wmq.5;
        Sun, 24 Jul 2022 22:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j+TMKKTWkt93wyAShA8GcS53wvc9Ih1A4htlfT9K7Ho=;
        b=T1T3RCRB8Vx9gQ7AY60KabJX4o1QLZMuP5BHO/3jX0yP9BGyal48GaaVf9woBoP6Yo
         9AKx/1tbR3dOYXoiLyxAlvLsqDmpkve/m/DH7HAj7xyS6PCWBC0e9mNDtH4o+aQmpfwN
         gEIpCMSjgvOvwRjcjbjWJLl+baoab86UwJLAJuAgRcAcl93LmaRNcUpAXEg9R2/wixnj
         +LEAw3zku6EQI7aUe931lps4nDfOQwjjSjRhq8+0k50O6YDtMjWD8dvFWVDFeDxvc3I3
         zwQ8YOvUWy8ojKN/MAGz8/bNZXaOR6qHF6PHc1qylll4eYLbtYSuKyZFr+6VWeKkPhp2
         UBDw==
X-Gm-Message-State: AJIora9eScE6B818S86mCwQxVgIycPjewVWoFFkUPx2XfCwTMIVr0USR
        V23+0VJfGVO2HSfIBV1bINk=
X-Google-Smtp-Source: AGRyM1tz29eyW8eFBsIukZelOZJBNJP+xtrRGyJ5rpmY5s1vLLoXX/JRWg29hpOVLhxGJKYUmPJDFQ==
X-Received: by 2002:a05:600c:2651:b0:3a3:1b8d:d9c8 with SMTP id 17-20020a05600c265100b003a31b8dd9c8mr20308470wmy.160.1658727849689;
        Sun, 24 Jul 2022 22:44:09 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id t11-20020a5d460b000000b0021b970a68f9sm10736171wrq.26.2022.07.24.22.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jul 2022 22:44:09 -0700 (PDT)
Message-ID: <8a4f10b1-70b3-25fe-9ffc-4f24a1531139@kernel.org>
Date:   Mon, 25 Jul 2022 07:44:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 13/70] objtool: skip non-text sections when adding
 return-thunk sites
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bpetkov@suse.de>
References: <20220722090650.665513668@linuxfoundation.org>
 <20220722090651.464856922@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220722090651.464856922@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I wonder, why this is needed in stable and not mainline?

Isn't this a different (non-upstream) dup of
951ddecf4356 objtool: Treat .text.__x86.* as noinstr
? (That is included in this release too.)

On 22. 07. 22, 11:07, Greg Kroah-Hartman wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> 
> The .discard.text section is added in order to reserve BRK, with a
> temporary function just so it can give it a size. This adds a relocation to
> the return thunk, which objtool will add to the .return_sites section.
> Linking will then fail as there are references to the .discard.text
> section.
> 
> Do not add instructions from non-text sections to the list of return thunk
> calls, avoiding the reference to .discard.text.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   tools/objtool/check.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -1308,7 +1308,9 @@ static void add_return_call(struct objto
>   	insn->type = INSN_RETURN;
>   	insn->retpoline_safe = true;
>   
> -	list_add_tail(&insn->call_node, &file->return_thunk_list);
> +	/* Skip the non-text sections, specially .discard ones */
> +	if (insn->sec->text)
> +		list_add_tail(&insn->call_node, &file->return_thunk_list);
>   }
>   
>   static bool same_function(struct instruction *insn1, struct instruction *insn2)
> 
> 

thanks,
-- 
js
suse labs
