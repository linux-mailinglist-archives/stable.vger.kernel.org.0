Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F196688C3C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 02:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjBCBHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 20:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjBCBHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 20:07:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474E7470AE;
        Thu,  2 Feb 2023 17:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F332DB828EC;
        Fri,  3 Feb 2023 01:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5044BC433D2;
        Fri,  3 Feb 2023 01:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675386446;
        bh=fz7m0oNp3+iBydgkgnlasJNzPQcxkPq6HJHHFp/eDmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOPBW7zi68EwVAEdF7hysr6oZSetdbFyWDQ38pu9afuQOyIaPfIj+GPMbinOGVKwF
         jOpH9BpW+bFA8vk7Oz4cWWpqnAqwPG7tuOwazTT8kOuxLoXmnkIa0biz8NiC8WUZfa
         NKuoTC94VJ+yKXU7LXEvM8Irk+XI3Mjv332MA4lkEK0Hqeyk7CSKdtUDdl/kqRWCGQ
         MbybtQGZhULhNZV0MFyzvrt8AOHC1Ggpkq2BaXFEA0/oNk8H6zxXUFJ64hcx5eS5OC
         MDxra6w/3V4tQGiLhEIhmdYs8ky9b8YHTMa4Rzj2vL9clXunI18/XZsl6ugnW/lVbd
         KSk8JF2n/4nFw==
Date:   Thu, 2 Feb 2023 17:07:24 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        stable@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Message-ID: <Y9xeTDOmMZ75G6cq@sol.localdomain>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
 <Y9bkoasmAmtQ2nSV@casper.infradead.org>
 <Y9mH0PCcZoGPryXw@slm.duckdns.org>
 <Y9oHQ6MfRbfwmFyK@sol.localdomain>
 <Y9wrglzrfzTiCjh8@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9wrglzrfzTiCjh8@slm.duckdns.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 11:30:42AM -1000, Tejun Heo wrote:
> > The bug we're discussing here is that when ext4 writes out a pagecache page in
> > an encrypted file, it first encrypts the data into a bounce page, then passes
> > the bounce page (which don't have a memcg) to wbc_account_cgroup_owner().  Maybe
> > the proper fix is to just pass the pagecache page to wbc_account_cgroup_owner()
> > instead?  See below for ext4 (a separate patch would be needed for f2fs):
> 
> Yeah, this makes sense to me and is the right thing to do no matter what.
> wbc_account_cgroup_owner() should be fed the origin page so that the IO can
> be blamed on the owner of that page.

Thanks.  These patches fix this for ext4 and f2fs:

    * https://lore.kernel.org/r/20230203005503.141557-1-ebiggers@kernel.org
    * https://lore.kernel.org/r/20230203010239.216421-1-ebiggers@kernel.org

- Eric
