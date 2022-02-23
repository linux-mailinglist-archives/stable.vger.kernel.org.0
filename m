Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EB34C1966
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243178AbiBWRGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236561AbiBWRGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:06:10 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0446B5372C;
        Wed, 23 Feb 2022 09:05:40 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9E91C1F43D;
        Wed, 23 Feb 2022 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645635939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GJrbL5GtZBvRuSJ9SW+6RjiwuvjkEo2u5aLhU0R+R4=;
        b=q/VB8Brw02rDOO+atLW8Cv3HziC+gcHX7RMqdtFFLAToVBJslZdrKkzmEJsfsj39468iSy
        REhTEPK5jkiPfzo1CInnMbD3bv0fhFlJQdSDQlu1b390kGemVBpQohzHxwvviJpOSInPw7
        SFzv2Yn54+xFrwVESma49x+c8RKFTlo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645635939;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GJrbL5GtZBvRuSJ9SW+6RjiwuvjkEo2u5aLhU0R+R4=;
        b=ooHQ4jwNnLyDlWUM+RRrdvtNGohWztZR/KFhUJWfe3D41UBdhvj4ogq0eLgPpFQbWoTfx5
        wltTiTmCW/jzaYBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 35D5E13C94;
        Wed, 23 Feb 2022 17:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ta9jDGNpFmIjGQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 23 Feb 2022 17:05:39 +0000
Message-ID: <7ec07580-8430-c4ba-69e1-004de161584e@suse.cz>
Date:   Wed, 23 Feb 2022 18:05:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] mm/filemap: Fix handling of THPs in
 generic_file_buffered_read()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com,
        Song Liu <songliubraving@fb.com>
Cc:     Adam Majer <amajer@suse.com>, Dirk Mueller <dmueller@suse.com>,
        Takashi Iwai <tiwai@suse.de>
References: <20220223155918.927140-1-willy@infradead.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20220223155918.927140-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/22 16:59, Matthew Wilcox (Oracle) wrote:
> When a THP is present in the page cache, we can return it several times,
> leading to userspace seeing the same data repeatedly if doing a read()
> that crosses a 64-page boundary.  This is probably not a security issue
> (since the data all comes from the same file), but it can be interpreted
> as a transient data corruption issue.  Fortunately, it is very rare as
> it can only occur when CONFIG_READ_ONLY_THP_FOR_FS is enabled, and it can
> only happen to executables.  We don't often call read() on executables.
> 
> This bug is fixed differently in v5.17 by commit 6b24ca4a1a8d
> ("mm: Use multi-index entries in the page cache").  That commit is
> unsuitable for backporting, so fix this in the clearest way.  It
> sacrifices a little performance for clarity, but this should never
> be a performance path in these kernel versions.
> 
> Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
> Cc: stable@vger.kernel.org # v5.15, v5.16
> Link: https://lore.kernel.org/r/df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz/
> Analyzed-by: Adam Majer <amajer@suse.com>
> Analyzed-by: Dirk Mueller <dmueller@suse.com>
> Bisected-by: Takashi Iwai <tiwai@suse.de>
> Reported-by: Vlastimil Babka <vbabka@suse.cz>

Replace with:

Reported-and-tested-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/filemap.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 82a17c35eb96..1293c3409e42 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2354,8 +2354,12 @@ static void filemap_get_read_batch(struct address_space *mapping,
>  			break;
>  		if (PageReadahead(head))
>  			break;
> -		xas.xa_index = head->index + thp_nr_pages(head) - 1;
> -		xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
> +		if (PageHead(head)) {
> +			xas_set(&xas, head->index + thp_nr_pages(head));
> +			/* Handle wrap correctly */
> +			if (xas.xa_index - 1 >= max)
> +				break;
> +		}
>  		continue;
>  put_page:
>  		put_page(head);

