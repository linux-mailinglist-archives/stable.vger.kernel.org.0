Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD7485561
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 16:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbiAEPFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 10:05:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47310 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241444AbiAEPET (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 10:04:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 150C06179C
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 15:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA33C36AE0;
        Wed,  5 Jan 2022 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641395058;
        bh=6K2KS3R5PnMQPP0Bk3OWgxy4JJ4GCObIIn+1VZ94UIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yA3nQY9+IgeGandXipkNqAVe+0thEQiO1sV7jHpXslEe/HcFTIX1ZIHznju/7gjRU
         0xnmf+Hp/D+PeBHIPXMTgMQbnP3d+S/tjVQdFuxZvhfPNj62RoEA0GGWavprX8/2ky
         TRIgviJHvfg86QF0r0RYnT73KvR9CfNH3FteV+rM=
Date:   Wed, 5 Jan 2022 16:04:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, llvm@lists.linux.dev,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.4] Input: touchscreen - Fix backport of
 a02dcde595f7cbd240ccd64de96034ad91cffc40
Message-ID: <YdWzb/O9yLiwppzr@kroah.com>
References: <20220103192935.3438038-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103192935.3438038-1-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 12:29:35PM -0700, Nathan Chancellor wrote:
> Upstream commit a02dcde595f7 ("Input: touchscreen - avoid bitwise vs
> logical OR warning") was applied as commit f6e9e7be9b80 ("Input:
> touchscreen - avoid bitwise vs logical OR warning") in linux-5.4.y but
> it did not properly account for commit d9265e8a878a ("Input:
> of_touchscreen - add support for touchscreen-min-x|y"), which means the
> warning mentioned in the commit message is not fully fixed:
> 
> drivers/input/touchscreen/of_touchscreen.c:78:17: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
>         data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-x",
>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/input/touchscreen/of_touchscreen.c:78:17: note: cast one or both operands to int to silence this warning
> drivers/input/touchscreen/of_touchscreen.c:92:17: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
>         data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-y",
>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/input/touchscreen/of_touchscreen.c:92:17: note: cast one or both operands to int to silence this warning
> 2 warnings generated.
> 
> It seems like the 4.19 backport was applied to the 5.4 tree, which did
> not have any conflicts so no issue was noticed at that point.
> 
> Fix up the backport to bring it more in line with the upstream version
> so that there is no warning.
> 
> Fixes: f6e9e7be9b80 ("Input: touchscreen - avoid bitwise vs logical OR warning")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/input/touchscreen/of_touchscreen.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Now queued up,t hanks.

greg k-h
