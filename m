Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0926752C9A1
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 04:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiESCLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 22:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiESCLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 22:11:01 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D0D186EF;
        Wed, 18 May 2022 19:10:59 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24J2Absr020685
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 22:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652926239; bh=tR13JwUbXXXeiykjLNhK4pqKKdnGUOdKfC+6Atr7Qec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=KY3MZRCTmd2jkp++r3S74yh8ujOH46dVzROEXMoxhUYCq6YqEsVLiNa9z56gC2bJX
         12fgbb9hMeavEFfQmzO9FZEqge1/QMMZ4KLrBJQHwtF0qY6SLff4ZctdYz4q1G8WiI
         WUPRss6ao9UlJIXxLBVxjKqHTO3rYM8bmP6r4gfuXXhblBUHbZ2m+WscMUjoH03biB
         4HHxTjXPUR0xA1wBvEZmZkuxuMsjc7FI4HwBMcMnzW54ONA3RZn/YTLQjIxT6ZWNKG
         HjvYP7WCH7HrcY5Z7YAEAiify4VsKjVBlw+bIXSahQiubRkTsxq2sXNvxkdQA2iXYk
         AOyQNsCLz86TQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 86D8015C3EC0; Wed, 18 May 2022 22:10:37 -0400 (EDT)
Date:   Wed, 18 May 2022 22:10:37 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/5] ext4: fix memory leak in
 parse_apply_sb_mount_options()
Message-ID: <YoWnHXZSQZA4CL6+@mit.edu>
References: <20220513231605.175121-1-ebiggers@kernel.org>
 <20220513231605.175121-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513231605.175121-2-ebiggers@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 13, 2022 at 04:16:01PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If processing the on-disk mount options fails after any memory was
> allocated in the ext4_fs_context, e.g. s_qf_names, then this memory is
> leaked.  Fix this by calling ext4_fc_free() instead of kfree() directly.
> 
> Reproducer:
> 
>     mkfs.ext4 -F /dev/vdc
>     tune2fs /dev/vdc -E mount_opts=usrjquota=file
>     echo clear > /sys/kernel/debug/kmemleak
>     mount /dev/vdc /vdc
>     echo scan > /sys/kernel/debug/kmemleak
>     sleep 5
>     echo scan > /sys/kernel/debug/kmemleak
>     cat /sys/kernel/debug/kmemleak
> 
> Fixes: 7edfd85b1ffd ("ext4: Completely separate options parsing and sb setup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
