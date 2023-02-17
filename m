Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CCE69AD98
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBQONn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjBQONm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:13:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C025B6BDE8;
        Fri, 17 Feb 2023 06:13:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95D75B82A26;
        Fri, 17 Feb 2023 14:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9199C433EF;
        Fri, 17 Feb 2023 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676643152;
        bh=QqnRJjow+VeoF1WpEnmgWNf9DKM4ggTY8/62VYEOaR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AqlB1A5BdXZKe8egIryd1rhfbF4fPdCuTtVa4osAtwwB5TqNg7V+o2WuIoNXhrKzd
         IuINZ4WM7VGK5NgRlPmRodHxgJmy72Q/T4Cso2+2DrFfn7rGXqeFU2iG6FKAbYGO29
         qc3AuRz3WhiZvlqQ1lRuJNdZEwuJeI1Offqt4cbE=
Date:   Fri, 17 Feb 2023 15:12:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] Backport two overlayfs fixed to 5.10.y
Message-ID: <Y++LSEmfKw6SkMx0@kroah.com>
References: <20230212090204.339226-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230212090204.339226-1-amir73il@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 12, 2023 at 11:02:02AM +0200, Amir Goldstein wrote:
> Greg,
> 
> These two patches have been (correctly) auto selected to 5.15.y
> along with the two dependency patches tagged with:
> Stable-dep-of: b306e90ffabd ("ovl: remove privs in ovl_copyfile()")
> 9636e70ee2d3 ("ovl: use ovl_copy_{real,upper}attr() wrappers")
> a54843833caf ("ovl: store lower path in ovl_inode")
> 
> It wasn't wrong to apply those patches with the two dependencies
> to 5.15.y, but it is not as easy to do for 5.10.y, so here is a
> very simple backport of the two fixes to 5.10.y, i.e.:
> replaced ovl_copyattr(X) with ovl_copyattr(ovl_inode_real(X), X).
> 
> Note that the language "This fixes some failure in fstests..."
> in commit message means that those fixes are not enough for the
> tests to pass. Additional backports from v6.2 are needed for the
> tests to pass and I am collaborating those backports with Leah,
> so they will hit 5.15.y first before posting them for 5.10.y.
> 
> Never the less, these overlayfs fixes are important security
> fixes, so they should be applied to LTS kernel even before
> all the cases in the fstests are fixed.
> 
> Thanks,
> Amir.
> 
> Amir Goldstein (2):
>   ovl: remove privs in ovl_copyfile()
>   ovl: remove privs in ovl_fallocate()
> 
>  fs/overlayfs/file.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> -- 
> 2.34.1
> 

Now queued up, thanks.

greg k-h
