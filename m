Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B276AFF90
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 08:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCHHRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 02:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCHHRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 02:17:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A2BA8817;
        Tue,  7 Mar 2023 23:17:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51C58B8169A;
        Wed,  8 Mar 2023 07:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6F8C433EF;
        Wed,  8 Mar 2023 07:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678259842;
        bh=CZselh7PmGt1Cjg2uKRyDoGl1nckGX+iIhB7iqEUQvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qjaf7ZyL6bh96TbYo2TPOtm4E0TM6BHai0mkfFMcEFlnqOeKyHQfjvBSB/5JDzhfZ
         oOQIesprZ22dV7gpMbMjLHdIcYTa+gBfpa6+ZdjKI34JjKKpQwKCMgpwvzdzcU8V1r
         NC9kLVXnUamkqPTSKEBcybZ/2Dt33sklri9slZwI=
Date:   Wed, 8 Mar 2023 08:17:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6.1 788/885] ext4: Fix possible corruption when moving a
 directory
Message-ID: <ZAg2gAJSYJDAMYMi@kroah.com>
References: <20230307170001.594919529@linuxfoundation.org>
 <20230307170036.133148515@linuxfoundation.org>
 <ZAePHuuAGo7I1VOc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAePHuuAGo7I1VOc@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 07:23:10PM +0000, Eric Biggers wrote:
> On Tue, Mar 07, 2023 at 06:02:02PM +0100, Greg Kroah-Hartman wrote:
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit 0813299c586b175d7edb25f56412c54b812d0379 upstream.
> > 
> > When we are renaming a directory to a different directory, we need to
> > update '..' entry in the moved directory. However nothing prevents moved
> > directory from being modified and even converted from the inline format
> > to the normal format. When such race happens the rename code gets
> > confused and we crash. Fix the problem by locking the moved directory.
> > 
> > CC: stable@vger.kernel.org
> > Fixes: 32f7f22c0b52 ("ext4: let ext4_rename handle inline dir")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Link: https://lore.kernel.org/r/20230126112221.11866-1-jack@suse.cz
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This commit has a reported regression
> (https://lore.kernel.org/linux-ext4/5efbe1b9-ad8b-4a4f-b422-24824d2b775c@kili.mountain),
> so probably it should not be backported quite yet.

Thanks, I've dropped it from everywhere now.  Please let us know when
it's safe to add back to the tree.

greg k-h
