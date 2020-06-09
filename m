Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBAF1F480A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 22:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbgFIU20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 16:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733222AbgFIU2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 16:28:23 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB8A206C3;
        Tue,  9 Jun 2020 20:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591734502;
        bh=H/1jyA2ENEl76fko3i9AUC1qpu0Coz7F0CswtYS3WFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P4T3MvRrVMmtF3DbaNR6Vf9oaL5Jydxxzs2uKXV09TAGaRgb3FsE2ef7SwvZALph5
         oLzKqq/yk82ZVm20+xmwMUS0IlcojUDB+UExygverfwT7n9SSgELPQgUAZuSMTp3+/
         zSn333TkeHIJXbPbfcPqt0I9lUR/Dp6eiEyNsjFA=
Date:   Tue, 9 Jun 2020 13:28:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH v2] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200609202821.GB1105@sol.localdomain>
References: <20200601200543.59417-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601200543.59417-1-ebiggers@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 01:05:43PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If the dentry name passed to ->d_compare() fits in dentry::d_iname, then
> it may be concurrently modified by a rename.  This can cause undefined
> behavior (possibly out-of-bounds memory accesses or crashes) in
> utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
> that may be concurrently modified.
> 
> Fix this by first copying the filename to a stack buffer if needed.
> This way we get a stable snapshot of the filename.
> 
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Cc: <stable@vger.kernel.org> # v5.2+
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Daniel Rosenberg <drosen@google.com>
> Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: use memcpy() + barrier() instead of a byte-by-byte copy.
> 
>  fs/ext4/dir.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Ted, could you take this through the ext4 tree as a fix for 5.8?
The f2fs patch has been merged already.

- Eric
