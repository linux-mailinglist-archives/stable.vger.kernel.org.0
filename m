Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE2F23F388
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGUHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:07:31 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59258 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725893AbgHGUHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 16:07:30 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 077K7OUf018999
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Aug 2020 16:07:24 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 14F28420263; Fri,  7 Aug 2020 16:07:24 -0400 (EDT)
Date:   Fri, 7 Aug 2020 16:07:24 -0400
From:   tytso@mit.edu
To:     Jan Kara <jack@suse.cz>
Cc:     <linux-ext4@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix checking of entry validity
Message-ID: <20200807200724.GZ7657@mit.edu>
References: <20200731162135.8080-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731162135.8080-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, applied, although I changed the commit summary to be:

    ext4: fix checking of directory entry validity for inline directories

    	      	       	  	    	  	   - Ted


On Fri, Jul 31, 2020 at 06:21:35PM +0200, Jan Kara wrote:
> ext4_search_dir() and ext4_generic_delete_entry() can be called both for
> standard director blocks and for inline directories stored inside inode
> or inline xattr space. For the second case we didn't call
> ext4_check_dir_entry() with proper constraints that could result in
> accepting corrupted directory entry as well as false positive filesystem
> errors like:
> 
> EXT4-fs error (device dm-0): ext4_search_dir:1395: inode #28320400:
> block 113246792: comm dockerd: bad entry in directory: directory entry too
> close to block end - offset=0, inode=28320403, rec_len=32, name_len=8,
> size=4096
> 
> Fix the arguments passed to ext4_check_dir_entry().
> 
> Fixes: 109ba779d6cc ("ext4: check for directory entries too close to block end")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/namei.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
