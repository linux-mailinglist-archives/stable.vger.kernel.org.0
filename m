Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730CC5FC62B
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 15:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJLNPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 09:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJLNPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 09:15:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861B0CD5DC;
        Wed, 12 Oct 2022 06:15:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1724021A30;
        Wed, 12 Oct 2022 13:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665580547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1oLhj6c/cHN+hX9S+vzf627ctA/6Vm9/8MauwWpyRg=;
        b=mmL9zcXalwOhQpfR8VsAA7y9sDXjQYz0H8sQWQstD2/6ftEKy4o3qUIx/DcvobgjBo0T9g
        J1aY4nV5jxHPGkmlf4eeaqsIvEyPEQIiev1AW4ObQXS4z6vRglDWRfCCC1G401AZhlkPbE
        wmFZrVqPAVWMtWeDDZiFcMvhHPRalFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665580547;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1oLhj6c/cHN+hX9S+vzf627ctA/6Vm9/8MauwWpyRg=;
        b=Ie3PhAOJpxNWG0S+2Wn2GUMOAMW8Yd5YwynOjdc7u3kuXcqvlNJ06o8yIwYoTUFevZe4Z2
        o2Lo+psiW5fyBzCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A836D13ACD;
        Wed, 12 Oct 2022 13:15:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5lD6JQK+RmORdAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 12 Oct 2022 13:15:46 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d8e4b783;
        Wed, 12 Oct 2022 13:16:42 +0000 (UTC)
Date:   Wed, 12 Oct 2022 14:16:42 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix BUG_ON() when directory entry has invalid
 rec_len
Message-ID: <Y0a+Ommsgm4ogo7u@suse.de>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221012131330.32456-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221012131330.32456-1-lhenriques@suse.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Grr, looks like I accidentally reused a 'git send-email' from shell
history which had a '--in-reply-to' in it.  Please ignore and sorry about
that.  I've just resent a new email.

Cheers,
--
Luís

On Wed, Oct 12, 2022 at 02:13:30PM +0100, Luís Henriques wrote:
> The rec_len field in the directory entry has to be a multiple of 4.  A
> corrupted filesystem image can be used to hit a BUG() in
> ext4_rec_len_to_disk(), called from make_indexed_dir().
> 
>  ------------[ cut here ]------------
>  kernel BUG at fs/ext4/ext4.h:2413!
>  ...
>  RIP: 0010:make_indexed_dir+0x53f/0x5f0
>  ...
>  Call Trace:
>   <TASK>
>   ? add_dirent_to_buf+0x1b2/0x200
>   ext4_add_entry+0x36e/0x480
>   ext4_add_nondir+0x2b/0xc0
>   ext4_create+0x163/0x200
>   path_openat+0x635/0xe90
>   do_filp_open+0xb4/0x160
>   ? __create_object.isra.0+0x1de/0x3b0
>   ? _raw_spin_unlock+0x12/0x30
>   do_sys_openat2+0x91/0x150
>   __x64_sys_open+0x6c/0xa0
>   do_syscall_64+0x3c/0x80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> The fix simply adds a call to ext4_check_dir_entry() to validate the
> directory entry, returning -EFSCORRUPTED if the entry is invalid.
> 
> CC: stable@vger.kernel.org
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216540
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> * Changes since v1:
> 
> As suggested by Ted, I've removed the incorrect 'de->rec_len' check from
> previous version and replaced it with a call to ext4_check_dir_entry()
> instead, which is a much more complete verification.
> 
>  fs/ext4/namei.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3a31b662f661..ed76e89ffbe9 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2254,8 +2254,16 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
>  	memset(de, 0, len); /* wipe old data */
>  	de = (struct ext4_dir_entry_2 *) data2;
>  	top = data2 + len;
> -	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top)
> +	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top) {
> +		if (ext4_check_dir_entry(dir, NULL, de, bh2, data2, len,
> +					 (data2 + (blocksize - csum_size) -
> +					  (char *) de))) {
> +			brelse(bh2);
> +			brelse(bh);
> +			return -EFSCORRUPTED;
> +		}
>  		de = de2;
> +	}
>  	de->rec_len = ext4_rec_len_to_disk(data2 + (blocksize - csum_size) -
>  					   (char *) de, blocksize);
>  
