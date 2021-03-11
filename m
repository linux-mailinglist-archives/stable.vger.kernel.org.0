Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69A23377F6
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 16:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhCKPhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 10:37:38 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46920 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233999AbhCKPh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 10:37:28 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12BFaNsx028530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:36:24 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D0C9815C3AA0; Thu, 11 Mar 2021 10:36:23 -0500 (EST)
Date:   Thu, 11 Mar 2021 10:36:23 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, Yunlei He <heyunlei@hihonor.com>,
        bintian.wang@hihonor.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: fix error handling in ext4_end_enable_verity()
Message-ID: <YEo4958DZYm/21b+@mit.edu>
References: <20210302200420.137977-1-ebiggers@kernel.org>
 <20210302200420.137977-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302200420.137977-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 12:04:19PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ext4 didn't properly clean up if verity failed to be enabled on a file:
> 
> - It left verity metadata (pages past EOF) in the page cache, which
>   would be exposed to userspace if the file was later extended.
> 
> - It didn't truncate the verity metadata at all (either from cache or
>   from disk) if an error occurred while setting the verity bit.
> 
> Fix these bugs by adding a call to truncate_inode_pages() and ensuring
> that we truncate the verity metadata (both from cache and from disk) in
> all error paths.  Also rework the code to cleanly separate the success
> path from the error paths, which makes it much easier to understand.
> 
> Reported-by: Yunlei He <heyunlei@hihonor.com>
> Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, LGTM.

I've applied this to the ext4 with minor adjustment; I eliminated the
double blank line here:

> +	ext4_clear_inode_state(inode, EXT4_STATE_VERITY_IN_PROGRESS);
> +	return 0;
> +
> +
> +stop_and_cleanup:
> +	ext4_journal_stop(handle);
     ...

						- Ted
