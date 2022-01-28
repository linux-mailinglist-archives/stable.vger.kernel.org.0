Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F4249F44B
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 08:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbiA1HXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 02:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbiA1HXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 02:23:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C61C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 23:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F373618A9
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 07:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBDCC340E0;
        Fri, 28 Jan 2022 07:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643354591;
        bh=8+oAGlollogp2pPb2IplBjcjIQKAN3wSRErcVdAw0DI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g3t0rkmYGANf+Kg7Wsepfl0T5CquCNb/XYCtrl6TKnLMcL3kRipe0pglhj2xEq15M
         7+nmcrMSAigsj9za5VtFV5aCh1GLQppl3JcWkU7u1GYrE0oNLlrj43ee9hGT3W0gRh
         wDb6y2P6gcdsKrRZEjzF4kJLx3ZMdJKjDaanOGqE=
Date:   Fri, 28 Jan 2022 08:23:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zack Rusin <zackr@vmware.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/vmwgfx: Fix stale file descriptors on failed usercopy
Message-ID: <YfOZ3OMAXXo6MuR6@kroah.com>
References: <20220128045437.429936-1-zack@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128045437.429936-1-zack@kde.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 11:54:37PM -0500, Zack Rusin wrote:
> From: Mathias Krause <minipli@grsecurity.net>
> 
> commit a0f90c8815706981c483a652a6aefca51a5e191c upstream.
> 
> A failing usercopy of the fence_rep object will lead to a stale entry in
> the file descriptor table as put_unused_fd() won't release it. This
> enables userland to refer to a dangling 'file' object through that still
> valid file descriptor, leading to all kinds of use-after-free
> exploitation scenarios.
> 
> Fix this by deferring the call to fd_install() until after the usercopy
> has succeeded.
> 
> Fixes: c906965dee22 ("drm/vmwgfx: Add export fence to file descriptor support")
> [mks: backport to v5.16 and older]
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Signed-off-by: Zack Rusin <zackr@vmware.com>
> Cc: <stable@vger.kernel.org> # v5.4+
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h     |  5 ++--
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 33 +++++++++++++------------
>  drivers/gpu/drm/vmwgfx/vmwgfx_fence.c   |  2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |  2 +-
>  4 files changed, 21 insertions(+), 21 deletions(-)

All now queued up, thanks.

greg k-h
