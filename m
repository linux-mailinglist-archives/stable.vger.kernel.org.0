Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7179013923A
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 14:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgAMNbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 08:31:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50722 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMNbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 08:31:05 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iqznr-007J3N-Qf; Mon, 13 Jan 2020 13:30:47 +0000
Date:   Mon, 13 Jan 2020 13:30:47 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Ian Kent <raven@themaw.net>
Cc:     Aleksa Sarai <cyphar@cyphar.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200113133047.GR8904@ZenIV.linux.org.uk>
References: <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200110231945.GL8904@ZenIV.linux.org.uk>
 <aea0bc800b6a1e547ca1944738ff9db4379098ba.camel@themaw.net>
 <20200113035407.GQ8904@ZenIV.linux.org.uk>
 <41c535d689530f3715f21cd25074eb61e825a5f6.camel@themaw.net>
 <58f9894e51a00ad2a4ac3d4122bf29e7cb6c0d54.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58f9894e51a00ad2a4ac3d4122bf29e7cb6c0d54.camel@themaw.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 02:03:00PM +0800, Ian Kent wrote:

> Oh wait, for systemd I was actually looking at:
> https://github.com/systemd/systemd/blob/master/src/shared/switch-root.c
> 
> > 
> > Mind you, that's not the actual systemd repo. either I probably
> > need to look a lot deeper (and at the actual systemd repo) to
> > work out what's actually being called.
> > 
> > > Sigh...  Guess I'll have to dig that Fedora KVM image out and
> > > try to see what it's about... ;-/  Here comes a couple of hours
> > > of build...

D'oh...  And yes, that would've been a bisect hazard - switch to
path_lookupat() later in the series gets rid of that.  Incremental
(to be foldede, of course):

diff --git a/fs/namei.c b/fs/namei.c
index 1793661c3342..204677c37751 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2634,7 +2634,7 @@ path_mountpoint(struct nameidata *nd, unsigned flags, struct path *path)
 		(err = lookup_last(nd)) > 0) {
 		s = trailing_symlink(nd);
 	}
-	if (!err)
+	if (!err && (nd->flags & LOOKUP_RCU))
 		err = unlazy_walk(nd);
 	if (!err)
 		err = handle_lookup_down(nd);
