Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF974F9599
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 14:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbiDHMZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 08:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbiDHMZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 08:25:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027A25FD7;
        Fri,  8 Apr 2022 05:23:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4C02221602;
        Fri,  8 Apr 2022 12:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649420631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uVUpaREMsqSl4vlaMoOMUHcCZsb/nYkNS050tsr5h/M=;
        b=hRLmEUUKwmqeHOAJ7sPrZZE0DAA7RuiXmolBN1YA4t3HjT+nYOsFndqB3ZqKLUXsBO0XUI
        RjbY2u1/yXMjxR4ZYLTynH/hKns1eAY0K31hlFJmfgmHS60qmQKbU+P/zUviosXfa7ILQz
        7QH42GdiJwQYtp0uGYm1V0oQBnaI5eA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649420631;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uVUpaREMsqSl4vlaMoOMUHcCZsb/nYkNS050tsr5h/M=;
        b=+teq62O8z1TBTVIYmFBH64RzHuCUsF41fVoS4jFt4GR+qXMQC66FxWwj18gZsbu1Ithokj
        /+KBbhv3ImoCzgAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EFB6A132B9;
        Fri,  8 Apr 2022 12:23:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5kxvLVYpUGLuEAAAMHmgww
        (envelope-from <rgoldwyn@suse.de>); Fri, 08 Apr 2022 12:23:50 +0000
Date:   Fri, 8 Apr 2022 07:23:48 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     song@kernel.org, guoqing.jiang@linux.dev,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] md: fix an incorrect NULL check in
 does_sb_need_changing
Message-ID: <20220408122348.bt7lkaumwhv36a2q@fiona>
References: <20220408083728.25701-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408083728.25701-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16:37 08/04, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!rdev)
> 
> The list iterator value 'rdev' will *always* be set and non-NULL
> by rdev_for_each(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element found.
> Otherwise it will bypass the NULL check and lead to invalid memory
> access passing the check.
> 
> To fix the bug, use a new variable 'iter' as the list iterator,
> while using the original variable 'rdev' as a dedicated pointer to
> point to the found element.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2aa82191ac36 ("md-cluster: Perform a lazy update")
> Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

Also safeguards from reading sb from a faulty device if all devices are
faulty.

Acked-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> v2:https://lore.kernel.org/lkml/20220328081127.26148-1-xiam0nd.tong@gmail.com/
> v1:https://lore.kernel.org/lkml/20220327080002.11923-1-xiam0nd.tong@gmail.com/
> 
> ---
>  drivers/md/md.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4d38bd7dadd6..7476fc204172 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2629,14 +2629,16 @@ static void sync_sbs(struct mddev *mddev, int nospares)
>  
>  static bool does_sb_need_changing(struct mddev *mddev)
>  {
> -	struct md_rdev *rdev;
> +	struct md_rdev *rdev = NULL, *iter;
>  	struct mdp_superblock_1 *sb;
>  	int role;
>  
>  	/* Find a good rdev */
> -	rdev_for_each(rdev, mddev)
> -		if ((rdev->raid_disk >= 0) && !test_bit(Faulty, &rdev->flags))
> +	rdev_for_each(iter, mddev)
> +		if ((iter->raid_disk >= 0) && !test_bit(Faulty, &iter->flags)) {
> +			rdev = iter;
>  			break;
> +		}
>  
>  	/* No good device found. */
>  	if (!rdev)
> -- 
> 2.17.1
> 

-- 
Goldwyn
