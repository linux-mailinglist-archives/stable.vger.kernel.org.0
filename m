Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2225460EFF3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 08:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiJ0GPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 02:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiJ0GPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 02:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3CB9638D
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 23:15:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59D7A6216C
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 06:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FB3C433D6;
        Thu, 27 Oct 2022 06:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666851339;
        bh=jnFCxxDhUucRfvLps01EIDUDmAygWHzT17zUy2dw7QA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y1zBdXuEIWZsMXSMYZZaHvaYtozBptwUjfND1zgr1Xwqr8UlIcCZOokWems9n9qxT
         2LPz99T5gzIdgw4jUvltwjrhF43ObqIdwxNDWi1qzkQk61qWnK3EJ2oM7sz9kNko7e
         vESGFtK/keY0Ykau82LxWTpVPbDXHq+r/+d7VgqU=
Date:   Thu, 27 Oct 2022 08:16:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Seth Jenkins <sethjenkins@google.com>
Cc:     willy@infradead.org, Liam.Howlett@oracle.com,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH stable 4.19-5.19] mm: /proc/pid/smaps_rollup: fix no
 vma's null-deref
Message-ID: <Y1oiQbA2cbr3VGNG@kroah.com>
References: <20221026162438.711738-1-sethjenkins@google.com>
 <Y1ljQBkfcCoLYTx+@kroah.com>
 <CALxfFW6a_Fe1rwbXf6LnG-1PvjtwLwGLHYYPr8c-Wda3NNJD8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxfFW6a_Fe1rwbXf6LnG-1PvjtwLwGLHYYPr8c-Wda3NNJD8g@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Oct 26, 2022 at 02:32:00PM -0400, Seth Jenkins wrote:
> Hi Greg,
> 
> The upstream commit that fixed the issue was not an intentional fix
> AFAIK, but a refactor to switch to maple tree VMA lookups. I was under
> the impression that there were no plans to backport maple trees back
> to stable trees but do let me know if that presumption is incorrect.
> Assuming they're not getting backported, what do you think of this
> instead:

Yes, as Matthew said, backporting maple trees is not a good idea, we
don't want that.

> c4c84f06285e on upstream resolves this issue as part of the switch to
> using maple trees for VMA lookups, but a fix must still be applied to
> stable trees 4.19-5.19.

That's better, yes.  Please add that and resend a new version.

thanks,

greg k-h
