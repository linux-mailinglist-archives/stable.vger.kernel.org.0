Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAAC44417
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732097AbfFMQer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbfFMHuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 03:50:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76AFE20851;
        Thu, 13 Jun 2019 07:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560412204;
        bh=XnEL3VlElUWB68j93Q14HwRdvSfpesy69g8LPOA0sHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rZIMze5xvpEynR+1I1iwFtvEQuz9TKEAHIkA5gRCvuZ6xJU/sK1XaWvw8H3iscQUL
         oXEb+OEfNIcHEZy/vV9QW+SLtua2sqfveZLnVsrIY2WFb5r4HqkBqCasWH21QM62FV
         VLuW37KvucM8ggbwc7jHMmtwvqzkNlTipl4/2xn4=
Date:   Thu, 13 Jun 2019 09:50:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Helen Koike <helen.koike@collabora.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kernel@collabora.com
Subject: Re: [PATCH] drm: don't block fb changes for async plane updates
Message-ID: <20190613075001.GD19685@kroah.com>
References: <156007626458164@kroah.com>
 <20190610133627.31923-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610133627.31923-1-helen.koike@collabora.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 10:36:27AM -0300, Helen Koike wrote:
> commit 89a4aac0ab0e6f5eea10d7bf4869dd15c3de2cd4 upstream.
> 
> In the case of a normal sync update, the preparation of framebuffers (be
> it calling drm_atomic_helper_prepare_planes() or doing setups with
> drm_framebuffer_get()) are performed in the new_state and the respective
> cleanups are performed in the old_state.
> 
> In the case of async updates, the preparation is also done in the
> new_state but the cleanups are done in the new_state (because updates
> are performed in place, i.e. in the current state).
> 
> The current code blocks async udpates when the fb is changed, turning
> async updates into sync updates, slowing down cursor updates and
> introducing regressions in igt tests with errors of type:
> 
> "CRITICAL: completed 97 cursor updated in a period of 30 flips, we
> expect to complete approximately 15360 updates, with the threshold set
> at 7680"
> 
> Fb changes in async updates were prevented to avoid the following scenario:
> 
> - Async update, oldfb = NULL, newfb = fb1, prepare fb1, cleanup fb1
> - Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb2
> - Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2 (wrong)
> Where we have a single call to prepare fb2 but double cleanup call to fb2.
> 
> To solve the above problems, instead of blocking async fb changes, we
> place the old framebuffer in the new_state object, so when the code
> performs cleanups in the new_state it will cleanup the old_fb and we
> will have the following scenario instead:
> 
> - Async update, oldfb = NULL, newfb = fb1, prepare fb1, no cleanup
> - Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb1
> - Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2
> 
> Where calls to prepare/cleanup are balanced.
> 
> Cc: <stable@vger.kernel.org> # v4.14+
> Fixes: 25dc194b34dd ("drm: Block fb changes for async plane updates")
> Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190603165610.24614-6-helen.koike@collabora.com
> ---
> 
> Hi,
> 
> This patch failed to apply on kernel stable v4.14, I'm re-sending it
> fixing the conflict.

Now applied, thanks.

greg k-h
