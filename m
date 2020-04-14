Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1211A708E
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 03:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgDNBaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 21:30:18 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38349 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728719AbgDNBaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 21:30:18 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03E1U9DQ024756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 21:30:09 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CDAEE42013D; Mon, 13 Apr 2020 21:30:08 -0400 (EDT)
Date:   Mon, 13 Apr 2020 21:30:08 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Do not zeroout extents beyond i_disksize
Message-ID: <20200414013008.GA90651@mit.edu>
References: <20200331105016.8674-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331105016.8674-1-jack@suse.cz>
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
> 
> CC: stable@vger.kernel.org
> Fixes: 21ca087a3891 ("ext4: Do not zero out uninitialized extents beyond i_size")
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
