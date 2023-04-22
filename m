Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3471D6EBA26
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjDVQEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 12:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjDVQET (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 12:04:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908AF211D;
        Sat, 22 Apr 2023 09:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BFD761782;
        Sat, 22 Apr 2023 16:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F56C433D2;
        Sat, 22 Apr 2023 16:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682179453;
        bh=3lpZa77u6qXSX/ihv3QPoUb6S4YY/7uMBFO6YK865vs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mWPWY7nbvEJCdq26KkPrYgjoftyEn9JeZYX2b0qCQgJXH2rNcPXa6rEdDajpKOdjW
         MjJpkxifvq9rV1KzXsorkBNtmlqTUPt2eIXyZ0dz8Kkdul+aciDZLU3t1infqyy+B4
         3KUwjAR5dvtW8It5pwh3YaqVLztcviHCVGenOmr0=
Date:   Sat, 22 Apr 2023 18:04:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     fdmanana@kernel.org
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH for stable 6.1.x] btrfs: get the next extent map during
 fiemap/lseek more efficiently
Message-ID: <2023042202-sake-sturdily-8baa@gregkh>
References: <904648448355ca9fe6938f7bce11e412c8dc8cd0.1681855724.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <904648448355ca9fe6938f7bce11e412c8dc8cd0.1681855724.git.fdmanana@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 11:02:19AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> commit d47704bd1c78c85831561bcf701b90dd66f811b2 upstream.
> 
> At find_delalloc_subrange(), when we need to get the next extent map, we
> do a full search on the extent map tree (a red black tree). This is fine
> but it's a lot more efficient to simply use rb_next(), which typically
> requires iterating over less nodes of the tree and never needs to compare
> the ranges of nodes with the one we are looking for.
> 
> So add a public helper to extent_map.{h,c} to get the extent map that
> immediately follows another extent map, using rb_next(), and use that
> helper at find_delalloc_subrange().
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> Please add this patch to the next 6.1 stable release.
> It happens to fix a bug recently reported at:
> 
>      https://bugzilla.redhat.com/show_bug.cgi?id=2187312

Now queued up, thanks.

greg k-h
