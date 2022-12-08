Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D913647756
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 21:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiLHUep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 15:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLHUeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 15:34:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7998566C
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 12:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7249961F52
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 20:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B703C433F0;
        Thu,  8 Dec 2022 20:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670531682;
        bh=m3ZQO7sCmOASxwYCmXZYEy3WKx+wC+5GPXpTF7yT1mU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xAolNS7nuKk+TpslT3mSMPu2AD9xt6FESb6CKtLAALhp5LMVxxfv9NeosFFh1W9PC
         5FldJLAIRf8hoZxXFN2h+wjisBdqqnWxD835Uey6lplYwc4otiSQ9kWP+gYiTloIfS
         CDRbqbLX0A/QQDAqp96KDT9UE3/ueDyoQ2PPhFCo=
Date:   Thu, 8 Dec 2022 21:34:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15 5.10 5.4 1/1] arm64: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <Y5JKYA53GnPrsr+f@kroah.com>
References: <cover.1670358255.git.tom.saeger@oracle.com>
 <9e387b71ce45d8b7fe9f2b9c52694e3df33f0c7a.1670358255.git.tom.saeger@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e387b71ce45d8b7fe9f2b9c52694e3df33f0c7a.1670358255.git.tom.saeger@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 01:43:08PM -0700, Tom Saeger wrote:
> Backport of: 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> breaks arm64 Build ID when CONFIG_MODVERSIONS=y.
> 
> CONFIG_MODVERSIONS adds extra tooling to calculate symbol versions.
> This kernel's KBUILD tooling uses both
> relocatable (-r) and (-z noexecstack) to link head.o
> which results in ld adding a .note.GNU-stack section.
> Final linking of vmlinux should add a .NOTES segment containing the
> Build ID, but does NOT if head.o has a .note.GNU-stack section.
> 
> Selectively remove -z noexecstack from head.o's KBUILD_LDFLAGS to
> prevent .note.GNU-stack from being added to head.o.  Final link of
> vmlinux then properly adds .NOTES segment containing Build ID that can
> be read using tools like 'readelf -n'.
> 
> Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> ---
>  arch/arm64/kernel/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)

Why isn't this needed in Linus's tree?

And why not cc: everyone involved in this, I would need acks from
maintainers to be able to accept this...

thanks,

greg k-h
