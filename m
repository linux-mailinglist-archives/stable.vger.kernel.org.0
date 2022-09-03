Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C0A5ABD3E
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 07:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiICFgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 01:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiICFgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 01:36:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9A02C64F;
        Fri,  2 Sep 2022 22:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6429609D0;
        Sat,  3 Sep 2022 05:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DB3C433C1;
        Sat,  3 Sep 2022 05:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662183381;
        bh=OpKJfWdrDc3n3wA6yyELGco8XbWwsYE05NA7T35/G2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hv3UQax3zC9KwiMM1HJaOv5cCenbfX3sbxN7smMl4G/+VABgRVil24EXJn7Ho32Cb
         +ScKqzdQxPZGXOux5Guv75MhbvbZNmu+ISgv7Ob8aQEX2OiTUghk0btQpKrPiysz81
         KJaKP+lACKs8DYJdw2+aSzSLI4laZi++O54F71sw=
Date:   Sat, 3 Sep 2022 07:36:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     akpm@linux-foundation.org, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/dbgfs: fix memory leak when using
Message-ID: <YxLn5kSmX+xE5QLe@kroah.com>
References: <20220902191149.112434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902191149.112434-1-sj@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 07:11:49PM +0000, SeongJae Park wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> debugfs_lookup()
> Date: Fri,  2 Sep 2022 14:56:31 +0200	[thread overview]
> Message-ID: <20220902125631.128329-1-gregkh@linuxfoundation.org> (raw)
> 
> When calling debugfs_lookup() the result must have dput() called on it,
> otherwise the memory will leak over time.  Fix this up by properly
> calling dput().
> 
> Fixes: 75c1c2b53c78b ("mm/damon/dbgfs: support multiple contexts")
> Cc: <stable@vger.kernel.org> # 5.15.x
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: damon@lists.linux.dev
> Cc: linux-mm@kvack.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
> Changes from v1
> (https://lore.kernel.org/damon/20220902125631.128329-1-gregkh@linuxfoundation.org/)
> - Call dput() for failure-return case (Andrew Morton)

Thanks for fixing this up, I missed the other return error cases in my
rush to audit the whole tree at once.

This version looks great, and I see Andrew has taken it now into his
tree, thanks!

greg k-h
