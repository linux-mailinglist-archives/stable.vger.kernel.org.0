Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89805FBEC5
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 02:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJLA5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 20:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJLA5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 20:57:15 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A5776554;
        Tue, 11 Oct 2022 17:57:14 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 29C0v7uB018230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 20:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1665536229; bh=SJ07M6yWasK9iiukuBymLIFLZ79Thg5ed7O8f39WZrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Ug7qUNgYjI4okdf7skzS7qOcEr0wFx1ngm9zBQqLkFxgOlFFK0eU8Zy/xeUjvF71n
         faZCktFmQ9bE/y3gyiYNBsec+ihxyygklUprfVyxNoaa6/Yuz1BokK3VVNDlzRhvE6
         EBaUCK6FFQyv+SLTSbc4wEAGb6XoHFe1TwjWFiXlhe/dlid/O/gpP06GckatNAT8bI
         t+3JhmOAb3h5/K7nBo16RGEWN6KKVzDiLDZZeLC7/0RZcXRSieXKPNey/auVQmWJ8x
         VzQiVo8R1xSkGkH1Mgz0lXiiw1/cCN6bwSzA51wHLG/HWATOfSDGryaUoi0Pm2z9wm
         CzVU28suFpoWA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 171F915C3AC9; Tue, 11 Oct 2022 20:57:07 -0400 (EDT)
Date:   Tue, 11 Oct 2022 20:57:07 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix BUG_ON() when a directory entry has an invalid
 rec_len
Message-ID: <Y0YQ42Z/XPuHZRS8@mit.edu>
References: <20221011155745.15264-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221011155745.15264-1-lhenriques@suse.de>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 04:57:45PM +0100, Luís Henriques wrote:
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3a31b662f661..06803292e394 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2254,8 +2254,18 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
>  	memset(de, 0, len); /* wipe old data */
>  	de = (struct ext4_dir_entry_2 *) data2;
>  	top = data2 + len;
> -	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top)
> +	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top) {
> +		if (de->rec_len & 3) {

As the kernel test bot as flaged, de->rec_len needs to be byte swapped
on big endian machines.  Also, for block sizes larger than 64k the low
2 bits are used to encode rec_len sizes 256k-4.  All of this is
encoded in ext4_rec_len_from_disk().

However, I think a better thing to do is instead of doing this one
check on rec len, that instead we call ext4_check_dir_entry(), which
will do this check, and many more besides.  It will also avoid some
code duplication, since it will take care of calling EXT4_ERROR_INODE
with the appropriate explanatory message.

					- Ted
