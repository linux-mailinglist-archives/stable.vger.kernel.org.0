Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BEA1F6A7F
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgFKPCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:02:10 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47766 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728059AbgFKPCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:02:10 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 05BF1oeZ025687
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 11:01:51 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8C5C84200DD; Thu, 11 Jun 2020 11:01:50 -0400 (EDT)
Date:   Thu, 11 Jun 2020 11:01:50 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH v2] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200611150150.GO1347934@mit.edu>
References: <20200601200543.59417-1-ebiggers@kernel.org>
 <E876FECB-300E-471B-A790-D44F2F1A3F9A@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E876FECB-300E-471B-A790-D44F2F1A3F9A@dilger.ca>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 02:49:51PM -0600, Andreas Dilger wrote:
> On Jun 1, 2020, at 2:05 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > If the dentry name passed to ->d_compare() fits in dentry::d_iname, then
> > it may be concurrently modified by a rename.  This can cause undefined
> > behavior (possibly out-of-bounds memory accesses or crashes) in
> > utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
> > that may be concurrently modified.
> > 
> > Fix this by first copying the filename to a stack buffer if needed.
> > This way we get a stable snapshot of the filename.
> > 
> > Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> > Cc: <stable@vger.kernel.org> # v5.2+
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Daniel Rosenberg <drosen@google.com>
> > Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> LGTM.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
