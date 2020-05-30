Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8701E8E3A
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 08:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgE3Gox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 02:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgE3Gow (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 May 2020 02:44:52 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EBD12074B;
        Sat, 30 May 2020 06:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590821092;
        bh=Vfljkewu5yJyeYteJw8SGwaWsoTPtwkSKdk4FvA1jTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ci/MEcvwk27WjIwHUyNQ7oCgaVEplLP2VEwBZAr5lkXgqQAS+SvzonxWlpup5n43U
         EsFbxD/pfZrmwbTuEXG1NaWPiOkUevOVpctUFaGlnazdhEtaVNAn+9C2MSp2DtzCnM
         RL1MUP0n6M572M3b8U2UNMpZwi6kiDxDU+V/oEaA=
Date:   Fri, 29 May 2020 23:44:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200530064450.GA317593@sol.localdomain>
References: <20200530060216.221456-1-ebiggers@kernel.org>
 <85d06mkkv5.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85d06mkkv5.fsf@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 30, 2020 at 02:17:02AM -0400, Gabriel Krisman Bertazi wrote:
> >  > > +	/*
> > +	 * If the dentry name is stored in-line, then it may be concurrently
> > +	 * modified by a rename.  If this happens, the VFS will eventually retry
> > +	 * the lookup, so it doesn't matter what ->d_compare() returns.
> > +	 * However, it's unsafe to call utf8_strncasecmp() with an unstable
> > +	 * string.  Therefore, we have to copy the name into a temporary buffer.
> > +	 */
> > +	if (len <= DNAME_INLINE_LEN - 1) {
> > +		unsigned int i;
> > +
> > +		for (i = 0; i < len; i++)
> > +			strbuf[i] = READ_ONCE(str[i]);
> > +		strbuf[len] = 0;
> > +		qstr.name = strbuf;
> > +	}
> > +
> 
> Could we avoid this if the casefolded version were cached in the dentry?
> Then we could use utf8_strncasecmp_folded which would be safe.  Would
> this be acceptable for vfs?

The VFS assumes that each dentry has one name, the one in d_name.  That's what
it passes to ->d_compare(), and that's what it updates in __d_move().

So while ext4 and f2fs could put the casefolded name in ->d_fsdata,
->d_compare() wouldn't actually have access to it (unless we added d_fsdata as a
parameter to ->d_compare()).  Also, the casefolded name would get outdated when
__d_move() changes d_name.

We could instead make d_name always be the casefolded name.  I'm not sure that
would be possible, though.  For one, I don't think ->lookup() is allowed to just
change the dentry name.  It would also make getcwd(), /proc/*/fd/, etc. always
show casefolded names, which could be problematic.  And probably other issues I
can't think of off the top of my head.

- Eric
