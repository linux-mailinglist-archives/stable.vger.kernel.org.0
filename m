Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF14609BC7
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 09:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJXHr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 03:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJXHr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 03:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEE012AE0
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 00:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 867026106D
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 07:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CACC433C1;
        Mon, 24 Oct 2022 07:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666597620;
        bh=mDxCVlbhEkBBMnGFxu+Ht1RHOrgaQVdyh81t8a1AyC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OTxgrUmDhhNfm42iIdV/QK8zP269ygoLVhYD3j5sFdeLMxWUUyM9hYp8tq2oih14L
         6mfwZ3BA2+ApjhF2bJfhcevgpQUrqHSUOJGNhO6WRria8qDPPwMOD5B5PSUiY0dQeT
         ee03QwWsBqNngUz0s6JNUgEynjV2cma340+W2Yl8=
Date:   Mon, 24 Oct 2022 09:46:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     dsterba@suse.com, nborisov@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: enhance unsupported compat RO
 flags handling" failed to apply to 5.10-stable tree
Message-ID: <Y1ZC8sOqXE5I7EoO@kroah.com>
References: <1665923098198193@kroah.com>
 <6f9bd9ba-ac8b-4ec5-d4a5-865d5546fecb@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f9bd9ba-ac8b-4ec5-d4a5-865d5546fecb@suse.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 03:08:21PM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/10/16 20:24, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > 81d5d61454c3 ("btrfs: enhance unsupported compat RO flags handling")
> > dfe8aec4520b ("btrfs: add a btrfs_block_group_root() helper")
> > b6e9f16c5fda ("btrfs: replace open coded while loop with proper construct")
> > 42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")
> 
> Hi Greg and btrfs guys,
> 
> I'm not confident enough to continue backporting this patch (and its
> dependency) for older branches.
> 
> This patch itself relies on the new function fill_dummy_bgs() to skip the
> full block group items search.
> 
> That function is the core functionality to allow us to mount fses read-only
> with unsupported compat_ro flags.
> 
> But if we backport 42437a6386ff ("btrfs: introduce mount option
> rescue=ignorebadroots"), we need the "rescue=" mount option series, which
> can be super large, especially for older and older branches.
> 
> The other solution is to still implement that fill_dummy_bgs(), but not
> introducing the "rescue=" mount option.
> This means, we will have some moderate changes to 42437a6386ff ("btrfs:
> introduce mount option rescue=ignorebadroots"), but at least no full
> dependency on the "rescue=" mount options.
> 
> I'm wondering which solution would be more acceptable from the POV of stable
> kernels?

First off, is this really needed in older kernels?  It was marked as
such, but that's up to you all to decide if it's true or not.

So I'll defer to you and the btrfs maintainers on what to do, just let
us know.

thanks,

greg k-h
