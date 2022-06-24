Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE297559607
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiFXJIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiFXJIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:08:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37C54EDE5;
        Fri, 24 Jun 2022 02:08:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A8EE61F8BD;
        Fri, 24 Jun 2022 09:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1656061730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5prPDPC8v4mNhBzFP1CfowAl0viEFJUJ5FoXsjM9BA=;
        b=yTl/KsvEIdiCfPa5MlcbvyamImobSrJXHFeYtXM6SloqHe1WatHKcELimNody9rd/1KegL
        4mNxE/TLV7SaJmmKTCzzHYutq8j61VUIxzYbpKLcfoub447+QNKyLkKwDGvDsXY2K/pVqZ
        7mqXFmLAWQ1ffl0FTgwGfkZaQHQhznA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1656061730;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5prPDPC8v4mNhBzFP1CfowAl0viEFJUJ5FoXsjM9BA=;
        b=iP7wo0m0m496x+PhW0gpMvQc98uRKgYSu92Ai1GteOO/7gjJCevmBprXHgMKR5kFoKE8wF
        ZS3ORVE7q/44ShCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 718DF13480;
        Fri, 24 Jun 2022 09:08:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hvoIGyJ/tWJGfgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 24 Jun 2022 09:08:50 +0000
Message-ID: <73c277f2-7189-81ee-8d6c-624cbd145d4c@suse.cz>
Date:   Fri, 24 Jun 2022 11:08:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RESEND] tools/vm/slabinfo: Handle files in debugfs
Content-Language: en-US
To:     =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        stable@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>
References: <YrTfEHvpysJAVWWr@castiana>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <YrTfEHvpysJAVWWr@castiana>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/22 23:45, Stéphane Graber wrote:
> Commit 64dd68497be76 relocated and renamed the alloc_calls and
> free_calls files from /sys/kernel/slab/NAME/*_calls over to
> /sys/kernel/debug/slab/NAME/*_calls but didn't update the slabinfo tool
> with the new location.
> 
> This change will now have slabinfo look at the new location (and filenames)
> with a fallback to the prior files.
> 
> Fixes: 64dd68497be76 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
> Tested-by: Stéphane Graber <stgraber@ubuntu.com>

Thanks, added to slab/for-5.20/debug

> ---
>  tools/vm/slabinfo.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/vm/slabinfo.c b/tools/vm/slabinfo.c
> index 9b68658b6bb8..5b98f3ee58a5 100644
> --- a/tools/vm/slabinfo.c
> +++ b/tools/vm/slabinfo.c
> @@ -233,6 +233,24 @@ static unsigned long read_slab_obj(struct slabinfo *s, const char *name)
>  	return l;
>  }
>  
> +static unsigned long read_debug_slab_obj(struct slabinfo *s, const char *name)
> +{
> +	char x[128];
> +	FILE *f;
> +	size_t l;
> +
> +	snprintf(x, 128, "/sys/kernel/debug/slab/%s/%s", s->name, name);
> +	f = fopen(x, "r");
> +	if (!f) {
> +		buffer[0] = 0;
> +		l = 0;
> +	} else {
> +		l = fread(buffer, 1, sizeof(buffer), f);
> +		buffer[l] = 0;
> +		fclose(f);
> +	}
> +	return l;
> +}
>  
>  /*
>   * Put a size string together
> @@ -409,14 +427,18 @@ static void show_tracking(struct slabinfo *s)
>  {
>  	printf("\n%s: Kernel object allocation\n", s->name);
>  	printf("-----------------------------------------------------------------------\n");
> -	if (read_slab_obj(s, "alloc_calls"))
> +	if (read_debug_slab_obj(s, "alloc_traces"))
> +		printf("%s", buffer);
> +	else if (read_slab_obj(s, "alloc_calls"))
>  		printf("%s", buffer);
>  	else
>  		printf("No Data\n");
>  
>  	printf("\n%s: Kernel object freeing\n", s->name);
>  	printf("------------------------------------------------------------------------\n");
> -	if (read_slab_obj(s, "free_calls"))
> +	if (read_debug_slab_obj(s, "free_traces"))
> +		printf("%s", buffer);
> +	else if (read_slab_obj(s, "free_calls"))
>  		printf("%s", buffer);
>  	else
>  		printf("No Data\n");

