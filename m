Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5851F2C7B65
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 22:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgK2VdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 16:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgK2VdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 16:33:07 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61946C0613CF
        for <stable@vger.kernel.org>; Sun, 29 Nov 2020 13:32:27 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id p6so5342155plr.7
        for <stable@vger.kernel.org>; Sun, 29 Nov 2020 13:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=PZUV6Pl5obp90HIlVRrYFs5F5irEqrrKQ+rhwdUxs/U=;
        b=xBjm4c7iPr4vbzlpeOHtIqq8cC1yej31p8l5cgqeEdA0kx7ZuQaJKh3Heo9n9f/Grr
         efVfK/yCh+1p5aEYflUSK/ee9vUU8XeDI8dCh49Ibs/xVSTjMqHs0JUAm7HMD4RAbbLq
         7GLZPgUwQq8BIIfrqM9So+TdharW4AF2pxGrP8sgguvVdPSmnYmmoizL95m5WF4Lru76
         S0z/rrvvhj5YxT30BAkP6BXwfhx1tjxXKLukQyzGSlRDkQfqG6S3DHdnkn+LdG+QoC1Z
         oMcsZoRNi0oNItE+DzPfU7tvhkGkWEoW3mWRVKyIbBKDLRTDpPm1jWZmTpsMh2qw6oVM
         gP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=PZUV6Pl5obp90HIlVRrYFs5F5irEqrrKQ+rhwdUxs/U=;
        b=ivBXuli8LfWfoazH/2AdjWQfLTQcKZRyWVagnPq4FQTAdz3+MRdNTw8qNnNeZrKhlC
         ESP3fLYlrWTkrA8ox1f1U1BLNsq3jsdNsdkTYMZuhdtSQdQova4ugoy95618OIdPfqMx
         MhyIWrQt8XCIM6kFrAfCJi5prVhrpSic2C82IGu6svszHGVRgyO2kNkpvzcOVD68NCVG
         XQ0CopLQV2MbsnCUO5rXG4DThjtBj96np8P3QHjAyfgh8D86yZF9MLbKyV6CYIKkRvzK
         S6TSTYe6RFb9w9/bH5n3tk5M33/jwT0/bKL1hLmqvW4Mgj1og2FODuqAZH1DiNG4HevH
         ilxQ==
X-Gm-Message-State: AOAM531R3nq3b/Ag5TXBLpQZlvW7BQHvXDhs7QMsGZeNAE6P8nRe240t
        ADitApuOMCgiPfEIumqv6svnkA==
X-Google-Smtp-Source: ABdhPJxzBmW5X59YPxZTilHTFucJFvlhzlTBKIqtJyGc9mvaPzXRFQBorz+AOE4QeqFHTU72bL791g==
X-Received: by 2002:a17:902:bd05:b029:d6:f041:f5b with SMTP id p5-20020a170902bd05b02900d6f0410f5bmr16040166pls.9.1606685546647;
        Sun, 29 Nov 2020 13:32:26 -0800 (PST)
Received: from [192.168.10.160] (S01061cabc081bf83.cg.shawcable.net. [70.77.221.9])
        by smtp.gmail.com with ESMTPSA id 21sm14156174pfw.105.2020.11.29.13.32.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Nov 2020 13:32:25 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <13C51452-1690-4F47-8B72-873D2511193D@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_4745588D-386F-4484-8893-14E4BF1C3289";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: Fix deadlock with fs freezing and EA inodes
Date:   Sun, 29 Nov 2020 14:32:23 -0700
In-Reply-To: <20201127110649.24730-1-jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To:     Jan Kara <jack@suse.cz>
References: <20201127110649.24730-1-jack@suse.cz>
X-Mailer: Apple Mail (2.3273)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_4745588D-386F-4484-8893-14E4BF1C3289
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Nov 27, 2020, at 4:06 AM, Jan Kara <jack@suse.cz> wrote:
> 
> Xattr code using inodes with large xattr data can end up dropping last
> inode reference (and thus deleting the inode) from places like
> ext4_xattr_set_entry(). That function is called with transaction started
> and so ext4_evict_inode() can deadlock against fs freezing like:
> 
> CPU1					CPU2
> 
> removexattr()				freeze_super()
>  vfs_removexattr()
>    ext4_xattr_set()
>      handle = ext4_journal_start()
>      ...
>      ext4_xattr_set_entry()
>        iput(old_ea_inode)
>          ext4_evict_inode(old_ea_inode)
> 					  sb->s_writers.frozen = SB_FREEZE_FS;
> 					  sb_wait_write(sb, SB_FREEZE_FS);
> 					  ext4_freeze()
> 					    jbd2_journal_lock_updates()
> 					      -> blocks waiting for all
> 					         handles to stop
>            sb_start_intwrite()
> 	      -> blocks as sb is already in SB_FREEZE_FS state
> 
> Generally it is advisable to delete inodes from a separate transaction
> as it can consume quite some credits however in this case it would be
> quite clumsy and furthermore the credits for inode deletion are quite
> limited and already accounted for. So just tweak ext4_evict_inode() to
> avoid freeze protection if we have transaction already started and thus
> it is not really needed anyway.
> 
> CC: stable@vger.kernel.org
> Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
> CC: Tahsin Erdogan <tahsin@google.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/inode.c | 19 ++++++++++++++-----
> 1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 72534319fae5..777eb08b29cd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -175,6 +175,7 @@ void ext4_evict_inode(struct inode *inode)
> 	 */
> 	int extra_credits = 6;
> 	struct ext4_xattr_inode_array *ea_inode_array = NULL;
> +	bool freeze_protected = false;
> 
> 	trace_ext4_evict_inode(inode);
> 
> @@ -232,9 +233,14 @@ void ext4_evict_inode(struct inode *inode)
> 
> 	/*
> 	 * Protect us against freezing - iput() caller didn't have to have any
> -	 * protection against it
> +	 * protection against it. When we are in a running transaction though,
> +	 * we are already protected against freezing and we cannot grab further
> +	 * protection due to lock ordering constraints.
> 	 */
> -	sb_start_intwrite(inode->i_sb);
> +	if (!ext4_journal_current_handle()) {
> +		sb_start_intwrite(inode->i_sb);
> +		freeze_protected = true;
> +	}
> 
> 	if (!IS_NOQUOTA(inode))
> 		extra_credits += EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb);
> @@ -253,7 +259,8 @@ void ext4_evict_inode(struct inode *inode)
> 		 * cleaned up.
> 		 */
> 		ext4_orphan_del(NULL, inode);
> -		sb_end_intwrite(inode->i_sb);
> +		if (freeze_protected)
> +			sb_end_intwrite(inode->i_sb);
> 		goto no_delete;
> 	}
> 
> @@ -294,7 +301,8 @@ void ext4_evict_inode(struct inode *inode)
> stop_handle:
> 		ext4_journal_stop(handle);
> 		ext4_orphan_del(NULL, inode);
> -		sb_end_intwrite(inode->i_sb);
> +		if (freeze_protected)
> +			sb_end_intwrite(inode->i_sb);
> 		ext4_xattr_inode_array_free(ea_inode_array);
> 		goto no_delete;
> 	}
> @@ -323,7 +331,8 @@ void ext4_evict_inode(struct inode *inode)
> 	else
> 		ext4_free_inode(handle, inode);
> 	ext4_journal_stop(handle);
> -	sb_end_intwrite(inode->i_sb);
> +	if (freeze_protected)
> +		sb_end_intwrite(inode->i_sb);
> 	ext4_xattr_inode_array_free(ea_inode_array);
> 	return;
> no_delete:
> --
> 2.16.4
> 


Cheers, Andreas






--Apple-Mail=_4745588D-386F-4484-8893-14E4BF1C3289
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl/EE2cACgkQcqXauRfM
H+AiAA/+MfU2q0LlzWdtvXtjKWnx0YI2oRrdAYPYpXw/QQJWdLEivIUbOOjjuBGL
ug1YTGMwB4YHC2CqR8zJxlEQhejzXeS1v6cc2SYsvGpASdCJfqtczzxj8w6401m9
8T36NOjDP95sgNRvRnQx42Xv3pUYHtAJjfI5NlnjZsaBQEleDZK84374Y4Mao9S3
xa7JZmRFBt+hMCjkRL6buY/ErfSIP17KTjdTGz2xrW2tL8KKVHW1OAJkUWRXZYC6
Z+aX3FwdlS99gQqzEcH5YWPCsxKvnWqgHHANXh1LGqFe+xvzVfzQjd6ICtsRJRnY
EN7zKn1YqJ91W15kI3gRnT0z7GZDj17B6ii3YSIpoCzTt72IYviUHOU3B1pUfNGh
Afbztp797K0X6XO+X+jSyIWW9ijTeUXAPD+KOMuAkPPNC4WfmRgsh2COTWixM/Ol
tKApWo2LgsG9uMU8JoWOzzZgT5RCOqfTYCViK2y6hw5WbbIQSS6JYVUuxqIUmpD4
n8tpxuwcaIOTY62Ws2K3nvfUGRlgXDwt/dcNrHTj49NTiOTvnF+AbSG/HuKTRfV3
XeBaZurPyh/+1hsTKJ5bbfMuffYvap/DHSds4Jex/0dMNZCnzB+WsNMvO3O7hqJq
IMhXcEG1dTsa6z9s39AC4JUzHgD6X8h/28WAM/dPjI99KiVcQCc=
=P2LX
-----END PGP SIGNATURE-----

--Apple-Mail=_4745588D-386F-4484-8893-14E4BF1C3289--
