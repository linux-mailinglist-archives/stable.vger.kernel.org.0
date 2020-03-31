Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61369199792
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgCaNeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:34:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730755AbgCaNeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 09:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585661662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+w4u402SGEnP8z667DvtdhnveqoMF1wPgR2SOZdmQmg=;
        b=fsQLvWPDmQ0Ajq83APmjLzetplM01iwlJW6/nb37UTx2DETcEkQDVG6BaCXt0OXu4XFCuC
        mvm2cPlXmtIo/hP64IQzdBBzahRC+8DDDdl+r7YNGT4aLZnLT9ZlHp0Y4W7hCF/Y9veUa2
        DxWtDVUl8tsX7otFUquHsmUlRP/WaxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-L-qIL5t2NE-uFDMLGpC3SA-1; Tue, 31 Mar 2020 09:34:17 -0400
X-MC-Unique: L-qIL5t2NE-uFDMLGpC3SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77087800D5C;
        Tue, 31 Mar 2020 13:34:16 +0000 (UTC)
Received: from work (unknown [10.40.192.188])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 073C15D9CA;
        Tue, 31 Mar 2020 13:34:14 +0000 (UTC)
Date:   Tue, 31 Mar 2020 15:34:10 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Do not zeroout extents beyond i_disksize
Message-ID: <20200331133410.c7axn324ifsovkg5@work>
References: <20200331105016.8674-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331105016.8674-1-jack@suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 12:50:16PM +0200, Jan Kara wrote:
> We do not want to create initialized extents beyond end of file because
> for e2fsck it is impossible to distinguish them from a case of corrupted
> file size / extent tree and so it complains like:
> 
> Inode 12, i_size is 147456, should be 163840.  Fix? no
> 
> Code in ext4_ext_convert_to_initialized() and
> ext4_split_convert_extents() try to make sure it does not create
> initialized extents beyond inode size however they check against
> inode->i_size which is wrong. They should instead check against
> EXT4_I(inode)->i_disksize which is the current inode size on disk.
> That's what e2fsck is going to see in case of crash before all dirty
> data is written. This bug manifests as generic/456 test failure (with
> recent enough fstests where fsx got fixed to properly pass
> FALLOC_KEEP_SIZE_FL flags to the kernel) when run with dioread_lock
> mount option.

Makes sense, thanks.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

-Lukas

> 
> CC: stable@vger.kernel.org
> Fixes: 21ca087a3891 ("ext4: Do not zero out uninitialized extents beyond i_size")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/extents.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 954013d6076b..c5e190fd4589 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3532,8 +3532,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		(unsigned long long)map->m_lblk, map_len);
>  
>  	sbi = EXT4_SB(inode->i_sb);
> -	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
> -		inode->i_sb->s_blocksize_bits;
> +	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
> +			>> inode->i_sb->s_blocksize_bits;
>  	if (eof_block < map->m_lblk + map_len)
>  		eof_block = map->m_lblk + map_len;
>  
> @@ -3785,8 +3785,8 @@ static int ext4_split_convert_extents(handle_t *handle,
>  		  __func__, inode->i_ino,
>  		  (unsigned long long)map->m_lblk, map->m_len);
>  
> -	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
> -		inode->i_sb->s_blocksize_bits;
> +	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
> +			>> inode->i_sb->s_blocksize_bits;
>  	if (eof_block < map->m_lblk + map->m_len)
>  		eof_block = map->m_lblk + map->m_len;
>  	/*
> -- 
> 2.16.4
> 

