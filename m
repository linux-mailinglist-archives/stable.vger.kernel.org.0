Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD7910B6F5
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 20:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfK0ToX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 14:44:23 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45242 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726593AbfK0ToX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 14:44:23 -0500
Received: from callcc.thunk.org (97-71-153.205.biz.bhn.net [97.71.153.205] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xARJiFu6029787
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 14:44:16 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 1B71C4202FD; Wed, 27 Nov 2019 14:44:15 -0500 (EST)
Date:   Wed, 27 Nov 2019 14:44:15 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix ext4_empty_dir() for directories with holes
Message-ID: <20191127194415.GA22921@mit.edu>
References: <20191127131258.1163-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127131258.1163-1-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 02:12:58PM +0100, Jan Kara wrote:
> Function ext4_empty_dir() doesn't correctly handle directories with
> holes and crashes on bh->b_data dereference when bh is NULL....

Hi Jan,

Thanks for the patch.

However, it looks like we're still vulnerable to the first block of
the directory being NULL?

> @@ -2833,19 +2833,25 @@ bool ext4_empty_dir(struct inode *inode)
>  		return true;
>  
>  	de = (struct ext4_dir_entry_2 *) bh->b_data;
                                         ^^^^^^^^^^^

						- Ted
							
