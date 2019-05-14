Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D42491C5DC
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 11:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfENJTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 05:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbfENJTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 05:19:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77C8820879;
        Tue, 14 May 2019 09:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557825577;
        bh=KzWHzPF6qTJdJ1HjeQq9jL7ZD+wyZQC4ElC0ezzJBB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Crd4575xdmMVku3L4i+u5kU2q+uiLLVy6qIxJMnDFuVIeSk8Jt3c6oE/FhwLYgWK5
         pWlstUAK0VhERYI2e8f2fZJSM0Ut20Yji3DwlxNdmLWwNpfSeqwAR6KgsRUzNIkNli
         r9Yo/LlRB7SeV99rr7JSNwehZ5sIKXfk8vp2wmKk=
Date:   Tue, 14 May 2019 11:19:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@google.com, adrian.hunter@intel.com, zwisler@chromium.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        =?iso-8859-1?Q?Cl=E9ment_P=E9ron?= <peron.clem@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [stable/4.14.y PATCH 0/3] mmc: Fix a potential resource leak
 when shutting down request queue.
Message-ID: <20190514091933.GA27269@kroah.com>
References: <20190513175521.84955-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513175521.84955-1-rrangel@chromium.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 11:55:18AM -0600, Raul E Rangel wrote:
> I think we should cherry-pick 41e3efd07d5a02c80f503e29d755aa1bbb4245de
> https://lore.kernel.org/patchwork/patch/856512/ into 4.14. It fixes a
> potential resource leak when shutting down the request queue.

Potential meaning "it does happen", or "it can happen if we do this", or
just "maybe it might happen, we really do not know?"

> Once this patch is applied, there is a potential for a null pointer dereference.
> That's what the second patch fixes.

What is the git id of that upstream fix?

> The third patch is just an optimization to stop processing earlier.

That's not how stable kernels work :(

> See https://patchwork.kernel.org/patch/10925469/ for the initial motivation.

I don't understand the motivation from that link at all :(

> This commit applies to v4.14.116. It is already included in 4.19. 4.19 doesn't
> suffer from the null pointer dereference because later commits migrate the mmc
> stack to blk-mq.

What are those later commits?

> I tested this patch set by randomly connecting/disconnecting the SD
> card. I got over 189650 itarations without a problem.

And if you do not have these patches, on 4.14.y, how many iterations
cause a problem?  If you just apply the first patch, does that work?

_EVERY_ time we take a patch that is not upstream, something usually is
broken and needs to be fixed.  We have a long long long history of this,
so if you want to have a patch that is not upstream applied to a stable
kernel release, you need a whole lot of justification and explanation
and begging.  And you need to be around to fix the fallout for when it
breaks :)

thanks,

greg k-h
