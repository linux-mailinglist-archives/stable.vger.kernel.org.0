Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA0F59D198
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbiHWG6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 02:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbiHWG6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 02:58:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFF16170A;
        Mon, 22 Aug 2022 23:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3552AB8105C;
        Tue, 23 Aug 2022 06:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A4DC433D6;
        Tue, 23 Aug 2022 06:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661237881;
        bh=9pREzEtDD8D1Hin9NV/0CXxrHab2zUxM4K/6mcLIWBU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j+SkYAODehhMMoxFqIlBIXttWkdp7KR43X/rkxDkBvTdE3X40dWSaBN6e7w/EQnsJ
         T9zNc4OiRO9/uKFSKJuH5NjP1la+Rim2tSngiFnlRuy6/RrkSreOgh2DQ01dlrdLDR
         WsBIohtcynfZtkyv61nmDIfOiqbPxuGVMLz4K0rQ=
Date:   Tue, 23 Aug 2022 08:57:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     akpm@linux-foundation.org, badari.pulavarty@intel.com,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/damon/dbgfs: avoid duplicate context directory
 creation
Message-ID: <YwR6dgz1LEWGQagq@kroah.com>
References: <YwMhLHNfc7Fcdrd5@kroah.com>
 <20220822165236.87421-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822165236.87421-1-sj@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 04:52:36PM +0000, SeongJae Park wrote:
> > >  	new_dir = debugfs_create_dir(name, root);
> > > +	/* Below check is required for a potential duplicated name case */
> > > +	if (IS_ERR(new_dir))
> > > +		return PTR_ERR(new_dir);
> > 
> > Did you just leak the memory allocated above this check?  It's hard to
> > determine as you are setting global variables.
> 
> We re-alloc the metadata arrays for context above for this new context, and we
> do not re-alloc those in this failure case.  So yes, the arrays will have one
> more item that not really needed and also not really will be used.
> 
> However, the variable for the array, 'dbgfs_nr_ctxs' is not increased here.
> Therefore, the arrays will be re-allocated to the proper size when this
> function or other function that re-alloc the arrays based on 'dbgfs_nr_ctxs'
> (For example, 'dbgfs_rm_context()') are called.
> 
> So, though the arrays could have not-really-needed one entry that is only waste
> of memory, as it's only a small and fixed amount of memory (just one more
> pointer), and as the unneeded memory will eventually be returned (by a next
> 'dbgfs_{mk,rm}_context()' call), I think that's no problem.  This is what I
> intended for keeping the logic simple.
> 
> If I'm missing something, please let me know, though.

Ah, that makes more sense, thanks.  The code was not obvious in that
error paths normally clean up allocations that were done earlier.

All is good.

thanks,

greg k-h
