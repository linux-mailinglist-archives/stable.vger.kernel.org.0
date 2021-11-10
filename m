Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E41B44BCE8
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 09:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhKJIeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 03:34:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhKJIeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 03:34:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6851561076;
        Wed, 10 Nov 2021 08:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636533081;
        bh=nq2uOtXVYNz9SOdu50irlTfzRk28CEBB4QXolJQ53aY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0lO+EfYu4pkQyIcfDAsZQ+D4CQf9aA6RpijroJpLjftzP7xVMdJmgtjDAv1siAs65
         RCSahdRX71KnbiOTSV/O344ywuBLqkeP7YYui+dxUVEAhZXS4v/NqTh02ez24hotzk
         F8aHqnhaqtbuJV4Jyl8KVPvdPBls3vjWpi8zFj50=
Date:   Wed, 10 Nov 2021 09:31:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marco Elver <elver@google.com>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [5.15.y] kfence: default to dynamic branch instead of static
 keys mode
Message-ID: <YYuDVxniscyNtBua@kroah.com>
References: <YYqtuk4r2F9Pal+4@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYqtuk4r2F9Pal+4@elver.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 06:19:54PM +0100, Marco Elver wrote:
> Dear stable maintainers,
> 
> We propose picking the following 2 patches to 5.15.y:
> 
> 	07e8481d3c38 kfence: always use static branches to guard kfence_alloc()
> 	4f612ed3f748 kfence: default to dynamic branch instead of static keys mode
> 
> , which had not been marked for stable initially, but upon re-evaluation
> conclude that it will also avoid various unexpected behaviours [1], [2]
> as the use of frequently-switched static keys (at least on x86) is more
> trouble than it's worth.
> 
> [1] https://lkml.kernel.org/r/CANpmjNOw--ZNyhmn-GjuqU+aH5T98HMmBoCM4z=JFvajC913Qg@mail.gmail.com
> [2] https://patchwork.kernel.org/project/linux-acpi/patch/2618833.mvXUDI8C0e@kreacher/
> 
> While optional, we recommend 07e8481d3c38 as well, as it avoids the
> dynamic branch, now the default, if kfence is disabled at boot.
> 
> The main thing is to make the default less troublesome and be more
> conservative. Those choosing to enable CONFIG_KFENCE_STATIC_KEYS can
> still do so, but requires a deliberate opt-in via a config change.

Both now queued up, thanks.

greg k-h
