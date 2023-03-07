Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDCD6AF63E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjCGT6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjCGT5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:57:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303142410C;
        Tue,  7 Mar 2023 11:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBD69B81A06;
        Tue,  7 Mar 2023 19:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44528C433EF;
        Tue,  7 Mar 2023 19:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678218742;
        bh=XP/qsX8uwl7Bw0/AezCySOo0sb5RpBnrubSVkmp5lrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=du+67PQxlUSBJ2VJTyCr+QrQdEIZOGF3Tb3xPm6EVMIi5r1hcVjAcOzPeykM9v9Kx
         jMeh/knWNmBSYov9n6Z51g5qI2ugah389u+orSAN65CEaaOTrxaxXEs/7s7Xf3kEiN
         2vKRsE737JKGbTc/NfwyK4Bjno+u9aYGpT2PLplu2PLvGixrGDgzybLhFtaj4ImYPK
         EZ3/3ZrLKLPbHNopIN5w0tKo6jrMp9MtVLx1yRXAFtesILg5LSRnC7l0OjhpNF9tux
         0VetgiN7utR1bNUU0pjA98Bvx/Gb2KoO0rIyt8MfBKCXGgC72nSQZdNfYNHtnDMNm1
         5P/HVcx8JpUGg==
Date:   Tue, 7 Mar 2023 11:52:20 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix cgroup writeback accounting with fs-layer
 encryption
Message-ID: <ZAeV9Bl5gnmbjh/F@sol.localdomain>
References: <20230203005503.141557-1-ebiggers@kernel.org>
 <Y91QNz+U/MGs9cPc@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y91QNz+U/MGs9cPc@slm.duckdns.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 08:19:35AM -1000, Tejun Heo wrote:
> On Thu, Feb 02, 2023 at 04:55:03PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > When writing a page from an encrypted file that is using
> > filesystem-layer encryption (not inline encryption), ext4 encrypts the
> > pagecache page into a bounce page, then writes the bounce page.
> > 
> > It also passes the bounce page to wbc_account_cgroup_owner().  That's
> > incorrect, because the bounce page is a newly allocated temporary page
> > that doesn't have the memory cgroup of the original pagecache page.
> > This makes wbc_account_cgroup_owner() not account the I/O to the owner
> > of the pagecache page as it should.
> > 
> > Fix this by always passing the pagecache page to
> > wbc_account_cgroup_owner().
> > 
> > Fixes: 001e4a8775f6 ("ext4: implement cgroup writeback support")
> > Cc: stable@vger.kernel.org
> > Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks.

This patch hasn't been applied yet.  Ted, I was hoping you would take it through
the ext4 tree.  Can you do so when you have a chance?

- Eric
