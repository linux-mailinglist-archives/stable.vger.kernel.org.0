Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD116DD094
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDKD7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDKD7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1635998;
        Mon, 10 Apr 2023 20:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A77F761A70;
        Tue, 11 Apr 2023 03:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03B7C433EF;
        Tue, 11 Apr 2023 03:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681185540;
        bh=ysMBOb2Dvl1FfFehaRIlhqrwfBY5Os8ctxq9hZuc2vQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BInDaczbywhfbiGGix6YCGkT73PVOcZhQHfpOAuaEd4J0IGYaohvGY+JHeNIhas5I
         EdXKmeXJGS6vHjP6me/MoSRy2uJ5NqkIEjGJxNVBqNo6osnjbWhCAs+khJC5Tdd8/A
         p77yVj5wmTQiE/eN1GH/1zeKzbXQpCvcsvh0SNh8=
Date:   Mon, 10 Apr 2023 20:58:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peng Zhang <zhangpeng.00@bytedance.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Liam.Howlett@oracle.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org,
        David Binderman <dcb314@hotmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] maple_tree: Use correct variable type in sizeof
Message-Id: <20230410205859.8dca31a8c0cd54484c60c07c@linux-foundation.org>
In-Reply-To: <f132db6d-5b5f-cf18-3e4e-2f3053c93033@bytedance.com>
References: <20230411023513.15227-1-zhangpeng.00@bytedance.com>
        <20230410202935.d1abf62f386eefb1efa36ce4@linux-foundation.org>
        <ZDTXE8jKMz802jqR@casper.infradead.org>
        <f132db6d-5b5f-cf18-3e4e-2f3053c93033@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Apr 2023 11:49:56 +0800 Peng Zhang <zhangpeng.00@bytedance.com> wrote:

> 在 2023/4/11 11:42, Matthew Wilcox 写道:
> > On Mon, Apr 10, 2023 at 08:29:35PM -0700, Andrew Morton wrote:
> >> On Tue, 11 Apr 2023 10:35:13 +0800 Peng Zhang <zhangpeng.00@bytedance.com> wrote:
> >>
> >>> The type of variable pointed to by pivs is unsigned long, but the type
> >>> used in sizeof is a pointer type. Change it to unsigned long.
> >> Thanks, but there's nothing in this changelog which explains why a
> >> -stable backport is being proposed.  When fixing a bug, please always
> >> describe the user-visible effects of that bug.
> > There is no user-visible effect of this bug as the assembly code
> > generated will be identical.
> 
> Therefore, if this has always been the case, cc stable
> is also unnecessary.

I removed the cc:stable, added

	This change has no runtime effect, as sizeof(ul) == sizeof(ul *).

and staged the patch for next merge window, thanks.
