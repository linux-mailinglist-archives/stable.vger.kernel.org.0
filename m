Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DC960AD15
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiJXORo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbiJXOQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:16:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0808CBFFB;
        Mon, 24 Oct 2022 05:55:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B495921CA5;
        Mon, 24 Oct 2022 12:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666614374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OYm3JNBPLIG7FhjiMAka/JpluIH9z/kEqZ0pIlPgYlI=;
        b=jxzWprjDUUKAk9keVNNy2jFGSdSqeqyuNd009xVi1/jr/acc7r3yJ1+ria0uQPXkT1wWKp
        DzV+x45SzXYfgROo0MNa2HOnSFXvL5YY+QwuGPEBWCAFbBa4ClUGv39w4VqaMJfTv1bn/A
        w767PWrY7DekL1WATPlLQ46R23tUwVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666614374;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OYm3JNBPLIG7FhjiMAka/JpluIH9z/kEqZ0pIlPgYlI=;
        b=mdlCD5hNg+7mFUa/h3lrk0BIQg4QI19HWgyAHvf6/HtOjja+90kDd/rP5rBOYAl9jxY3Yd
        tIN53t5XsqJP/xDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A20BA13A79;
        Mon, 24 Oct 2022 12:26:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7ByJJ2aEVmODWQAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 24 Oct 2022 12:26:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 10164A06F6; Mon, 24 Oct 2022 14:26:14 +0200 (CEST)
Date:   Mon, 24 Oct 2022 14:26:14 +0200
From:   Jan Kara <jack@suse.cz>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Thomas Schmitt <scdbackup@gmx.net>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: prevent file time rollover after year 2038
Message-ID: <20221024122614.bkcehqr7gi3f23ca@quack3>
References: <20221020160037.4002270-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020160037.4002270-1-arnd@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 20-10-22 18:00:29, Arnd Bergmann wrote:
> From: Thomas Schmitt <scdbackup@gmx.net>
> 
> Change the return type of function iso_date() from int to time64_t,
> to avoid truncating to the 1902..2038 date range.
> 
> After this patch, the reported timestamps should fall into the
> range reported in the s_time_min/s_time_max fields.
> 
> Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
> Cc: stable@vger.kernel.org
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=800627
> Fixes: 34be4dbf87fc ("isofs: fix timestamps beyond 2027")
> Fixes: 5ad32b3acded ("isofs: Initialize filesystem timestamp ranges")
> [arnd: expand changelog text slightly]
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks! I've added the patch to my tree and will push it to Linus.

								Honza

> ---
>  fs/isofs/isofs.h | 2 +-
>  fs/isofs/util.c  | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
> index dcdc191ed183..c3473ca3f686 100644
> --- a/fs/isofs/isofs.h
> +++ b/fs/isofs/isofs.h
> @@ -106,7 +106,7 @@ static inline unsigned int isonum_733(u8 *p)
>  	/* Ignore bigendian datum due to broken mastering programs */
>  	return get_unaligned_le32(p);
>  }
> -extern int iso_date(u8 *, int);
> +extern time64_t iso_date(u8 *, int);
>  
>  struct inode;		/* To make gcc happy */
>  
> diff --git a/fs/isofs/util.c b/fs/isofs/util.c
> index e88dba721661..348af786a8a4 100644
> --- a/fs/isofs/util.c
> +++ b/fs/isofs/util.c
> @@ -16,10 +16,10 @@
>   * to GMT.  Thus  we should always be correct.
>   */
>  
> -int iso_date(u8 *p, int flag)
> +time64_t iso_date(u8 *p, int flag)
>  {
>  	int year, month, day, hour, minute, second, tz;
> -	int crtime;
> +	time64_t crtime;
>  
>  	year = p[0];
>  	month = p[1];
> -- 
> 2.29.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
