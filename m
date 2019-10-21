Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED550DE1BD
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 03:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfJUBVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Oct 2019 21:21:11 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40256 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726610AbfJUBVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Oct 2019 21:21:10 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9L1L5ad001321
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Oct 2019 21:21:06 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 7F7DC420458; Sun, 20 Oct 2019 21:21:05 -0400 (EDT)
Date:   Sun, 20 Oct 2019 21:21:05 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 03/22] ext4: Do not iput inode under running transaction
 in ext4_mkdir()
Message-ID: <20191021012105.GE6799@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003220613.10791-3-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 12:05:49AM +0200, Jan Kara wrote:
> When ext4_mkdir() fails to add entry into directory, it ends up dropping
> freshly created inode under the running transaction and thus inode
> truncation happens under that transaction. That breaks assumptions that
> ext4_evict_inode() does not get called from a transaction context
> (although I'm not aware of any real issue) and is completely
> unnecessary. Just stop the transaction before dropping inode reference.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

If we call ext4_journal_stop(handle) before calling iput(inode),
there's a chance that we could crash with the inode with i_link_counts
== 0, but we won't have yet call ext4_evict_inode() to mark the inode
as free in the inode bitmap.  This would result in a inode leak.

Also, this isn't the only place where we can enter ext4_evict_inode()
with an active handle; the same situation arise in ext4_add_nondir(),
and for the same reason.

So I think the code is right as is.  Do you agree?

	     	       	       	     	- Ted
