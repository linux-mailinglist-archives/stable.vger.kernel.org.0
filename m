Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A7411C956
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfLLJiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbfLLJiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:38:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BDA92465A;
        Thu, 12 Dec 2019 09:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143504;
        bh=cYCuMCFTyNXD7PUxwYw2ckoA49kvU1ho0ahRRcF6HIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OaPvK91qW6c2n7oIv7S0D+PgS7UheRojABAkgJDWgwyOq3RHz2v8hEFPwYiu/mAAb
         xImda4KEY6GhDVxE/32eCEy03sMz4fGVXBsO6DkYwTbZ+bz5thnAjLJOqxgumJFaRp
         MC8TkQ/YjsBOsaDaDGfIwuFIQzW+eY0PnD6rf4GI=
Date:   Thu, 12 Dec 2019 10:34:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nguyen Viet Dung <dung.nguyen.aj@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 121/243] ASoC: rsnd: tidyup registering method for
 rsnd_kctrl_new()
Message-ID: <20191212093433.GE1378792@kroah.com>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150347.300543701@linuxfoundation.org>
 <20191211225937.nnu6kvvbyexfrahr@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211225937.nnu6kvvbyexfrahr@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 07:59:37AM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Wed, Dec 11, 2019 at 04:04:43PM +0100, Greg Kroah-Hartman wrote:
> > From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > 
> > [ Upstream commit 9c698e8481a15237a5b1db5f8391dd66d59e42a4 ]
> > 
> > Current rsnd dvc.c is using flags to avoid duplicating register for
> > MIXer case. OTOH, commit e894efef9ac7 ("ASoC: core: add support to card
> > rebind") allows to rebind sound card without rebinding all drivers.
> > 
> > Because of above patch and dvc.c flags, it can't re-register kctrl if
> > only sound card was rebinded, because dvc is keeping old flags.
> > (Of course it will be no problem if rsnd driver also be rebinded,
> > but it is not purpose of above patch).
> > 
> > This patch checks current card registered kctrl when registering.
> > In MIXer case, it can avoid duplicate register if card already has same
> > kctrl. In rebind case, it can re-register kctrl because card registered
> > kctl had been removed when unbinding.
> > 
> > This patch is updated version of commit b918f1bc7f1ce ("ASoC: rsnd: DVC
> > kctrl sets once")
> > 
> > Reported-by: Nguyen Viet Dung <dung.nguyen.aj@renesas.com>
> > Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > Tested-by: Nguyen Viet Dung <dung.nguyen.aj@renesas.com>
> > Cc: Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This commit also requires the following commit:
> 
> commit 7aea8a9d71d54f449f49e20324df06341cc18395
> Author: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Date:   Fri Feb 1 16:49:30 2019 +0900
> 
>     ASoC: rsnd: fixup MIX kctrl registration
> 
>     Renesas sound device has many IPs and many situations.
>     If platform/board uses MIXer, situation will be more complex.
>     To avoid duplicate DVC kctrl registration when MIXer was used,
>     it had original flags.
>     But it was issue when sound card was re-binded, because
>     no one can't cleanup this flags then.
> 
>     To solve this issue, commit 9c698e8481a15237a ("ASoC: rsnd: tidyup
>     registering method for rsnd_kctrl_new()") checks registered
>     card->controls, because if card was re-binded, these were cleanuped
>     automatically. This patch could solve re-binding issue.
>     But, it start to avoid MIX kctrl.
> 
>     To solve these issues, we need below.
>     To avoid card re-binding issue: check registered card->controls
>     To avoid duplicate DVC registration: check registered rsnd_kctrl_cfg
>     To allow multiple MIX registration: check registered rsnd_kctrl_cfg
>     This patch do it.
> 
>     Fixes: 9c698e8481a15237a ("ASoC: rsnd: tidyup registering method for rsnd_kctrl_new()")
>     Reported-by: Jiada Wang <jiada_wang@mentor.com>
>     Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>     Tested-By: Jiada Wang <jiada_wang@mentor.com>
>     Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> 
> Please apply this to 4.19.y and 4.14.y.

Now queued up, thanks!

greg k-h
