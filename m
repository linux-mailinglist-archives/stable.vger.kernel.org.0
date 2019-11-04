Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAD0EE004
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 13:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfKDMf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 07:35:28 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58445 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726100AbfKDMf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 07:35:28 -0500
Received: from callcc.thunk.org (ip-12-2-52-196.nyc.us.northamericancoax.com [196.52.2.12])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xA4CZMAd025913
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 4 Nov 2019 07:35:23 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 968B4420311; Mon,  4 Nov 2019 07:35:19 -0500 (EST)
Date:   Mon, 4 Nov 2019 07:35:19 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 03/22] ext4: Do not iput inode under running transaction
 in ext4_mkdir()
Message-ID: <20191104123519.GA28764@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-3-jack@suse.cz>
 <20191021012105.GE6799@mit.edu>
 <20191024101906.GM31271@quack2.suse.cz>
 <20191024120958.GC1124@mit.edu>
 <20191024133701.GP31271@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024133701.GP31271@quack2.suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 03:37:01PM +0200, Jan Kara wrote:
> > We can certainly add it to the orphan list if it's necessary, but it's
> > extra overhead and adds a global contention point.  So if it's not
> > necessary, I'd rather avoid it if possible, and I think it's safe to
> > do so in this case.
> 
> As this is error cleanup path (only EIO and ENOSPC are realistic failure
> cases AFAICT) I don't think performance really matters here. I certainly
> don't want to add inode to orphan list in the fast path. I agree that would
> be non-starter. I'll try to write a patch and we'll see how bad it will be.
> If you still hate it, I can have a look into how bad it would be to fix
> ext4_symlink() and somehow deal with revoke reservation issues.

That seems fair; I agree, adding inodes to the list in the error path
shouldn't be an issue.

					- Ted
