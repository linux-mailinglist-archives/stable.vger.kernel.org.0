Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDA7261A2
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 12:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfEVKWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 06:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfEVKWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 06:22:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32F6220868;
        Wed, 22 May 2019 10:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558520520;
        bh=zvNJXlde6vJrju/6950RKpxcXEfG+fB++d7z7grzFag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P7WBX1KNk5ZPcye971Igpz9KNRW0hUPTKC2es54jfcQp4y4wE3GVnKWGd2dZZAofo
         oG6/J1R9fSNMWYg0vdbULKxqQCL2qZDAk0CpbLjTuwEitPQJdzUsg4rH6NHH1DbSzg
         JAYpLv+ue/Y+y9aXygNq6xNKQ0ZHOs2G4yDEiQqI=
Date:   Wed, 22 May 2019 12:21:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH 4.19 067/105] ext4: protect journal inodes blocks using
 block_validity
Message-ID: <20190522102158.GA6721@kroah.com>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520115251.802050920@linuxfoundation.org>
 <20190522091859.GD8174@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522091859.GD8174@amd>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 11:18:59AM +0200, Pavel Machek wrote:
> On Mon 2019-05-20 14:14:13, Greg Kroah-Hartman wrote:
> > From: Theodore Ts'o <tytso@mit.edu>
> > 
> > commit 345c0dbf3a30872d9b204db96b5857cd00808cae upstream.
> > 
> > Add the blocks which belong to the journal inode to block_validity's
> > system zone so attempts to deallocate or overwrite the journal due a
> > corrupted file system where the journal blocks are also claimed by
> > another inode.
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202879
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Cc: stable@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> > +static int ext4_protect_reserved_inode(struct super_block *sb, u32 ino)
> > +{
> > +	struct inode *inode;
> > +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > +	struct ext4_map_blocks map;
> > +	u32 i = 0, err = 0, num, n;
> > +
> > +	if ((ino < EXT4_ROOT_INO) ||
> > +	    (ino > le32_to_cpu(sbi->s_es->s_inodes_count)))
> > +		return -EINVAL;
> > +	inode = ext4_iget(sb, ino, EXT4_IGET_SPECIAL);
> > +	if (IS_ERR(inode))
> > +		return PTR_ERR(inode);
> > +	num = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> > +	while (i < num) {
> > +		map.m_lblk = i;
> > +		map.m_len = num - i;
> > +		n = ext4_map_blocks(NULL, inode, &map, 0);
> > +		if (n < 0) {
> > +			err = n;
> > +			break;
> > +		}
> 
> n is unsigned, so this can not happen. Commit 102/ actually fixes this
> up. Should they be merged together?

No, we keep things identical to how they are upstream, otherwise it is
impossible to keep track of what happened here.

This patch, and 2 others were dropped anyway, so you don't have to worry
about it :)

greg k-h
