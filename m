Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B74F1630
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 15:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbiDDNmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbiDDNml (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 09:42:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA37655F;
        Mon,  4 Apr 2022 06:40:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 63E27210DE;
        Mon,  4 Apr 2022 13:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649079644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FEe5HKY/xcgBfsPpkp8pzVyfKeVfmAA+0jcQ6LELag=;
        b=SQOtCIojzc13oOxKzr6vw0G3ccw+icjQdLW2rBRkFCf1gBWsZdEVKOEs3soqeYzEujbabx
        3x6+fEgm8yfXvSWacu806AqWTXpXGXJ8UB5cfquM36YJpAnv60C3+VBEiAiUNnAMmpX6/w
        ZhN4FT1olpjo38+eu1JqSQiCrugeLRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649079644;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FEe5HKY/xcgBfsPpkp8pzVyfKeVfmAA+0jcQ6LELag=;
        b=6eRqB+Z/NnPRxDVWXKa1slGQtIWUVaDNZw28WhWoEeSIBz6uR2XGRqVOcLLv7FpdTNVD5u
        myY1Dgukb1Qk6aBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 48B0E13216;
        Mon,  4 Apr 2022 13:40:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 08MQEVz1SmJ9JgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 04 Apr 2022 13:40:44 +0000
Message-ID: <29914f07-6ee5-a562-2b8e-ed15c861f3eb@suse.cz>
Date:   Mon, 4 Apr 2022 15:40:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] tools/vm/slabinfo: Handle files in debugfs
Content-Language: en-US
To:     =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        stable@vger.kernel.org
References: <20220331140339.1362390-1-stgraber@ubuntu.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20220331140339.1362390-1-stgraber@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/22 16:03, Stéphane Graber wrote:
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

slabinfo is not the nicest code already, but still this basically duplicates
read_slab_obj() just to add a prefix to the path, so it could be done in a
unified way?

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

