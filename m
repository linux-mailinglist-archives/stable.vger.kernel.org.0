Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC0B561949
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiF3LeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiF3LeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:34:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5445A445
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 04:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C4EDB82A39
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 11:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8395C34115;
        Thu, 30 Jun 2022 11:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656588845;
        bh=y/AkczZu+t5L5QS5HmrGxEEOZZGTi1cFRhvgGwdbbLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qmg64MZn4FHh18uQWV6rRCe66knAFc1oY1fGEQzGn712mLfl0ROVycbbNXMHzHvRE
         MFxzjNM4zEBjQ1LYcJ27YupCdzXULyW26LOoR+89hp0WyuqCpZtxlSb8ZEvpERkHOS
         p5wIiaR8x/xOeSlz1dkr3si+QRXTeavd7RI3LzlE=
Date:   Thu, 30 Jun 2022 13:34:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>,
        Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 5.10] xen/gntdev: Avoid blocking in unmap_grant_pages()
Message-ID: <Yr2KKpWSiuzOQr7v@kroah.com>
References: <20220627181006.1954-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627181006.1954-1-demi@invisiblethingslab.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 02:10:02PM -0400, Demi Marie Obenour wrote:
> commit dbe97cff7dd9f0f75c524afdd55ad46be3d15295 upstream
> 
> unmap_grant_pages() currently waits for the pages to no longer be used.
> In https://github.com/QubesOS/qubes-issues/issues/7481, this lead to a
> deadlock against i915: i915 was waiting for gntdev's MMU notifier to
> finish, while gntdev was waiting for i915 to free its pages.  I also
> believe this is responsible for various deadlocks I have experienced in
> the past.
> 
> Avoid these problems by making unmap_grant_pages async.  This requires
> making it return void, as any errors will not be available when the
> function returns.  Fortunately, the only use of the return value is a
> WARN_ON(), which can be replaced by a WARN_ON when the error is
> detected.  Additionally, a failed call will not prevent further calls
> from being made, but this is harmless.
> 
> Because unmap_grant_pages is now async, the grant handle will be sent to
> INVALID_GRANT_HANDLE too late to prevent multiple unmaps of the same
> handle.  Instead, a separate bool array is allocated for this purpose.
> This wastes memory, but stuffing this information in padding bytes is
> too fragile.  Furthermore, it is necessary to grab a reference to the
> map before making the asynchronous call, and release the reference when
> the call returns.
> 
> It is also necessary to guard against reentrancy in gntdev_map_put(),
> and to handle the case where userspace tries to map a mapping whose
> contents have not all been freed yet.
> 
> Fixes: 745282256c75 ("xen/gntdev: safely unmap grants in case they are still in use")
> Cc: stable@vger.kernel.org
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Link: https://lore.kernel.org/r/20220622022726.2538-1-demi@invisiblethingslab.com
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  drivers/xen/gntdev-common.h |   7 ++
>  drivers/xen/gntdev.c        | 142 +++++++++++++++++++++++++-----------
>  2 files changed, 106 insertions(+), 43 deletions(-)

All now queued up, thanks.

greg k-h
