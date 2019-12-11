Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1289311C033
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 23:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfLKW7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 17:59:49 -0500
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:53884 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLKW7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 17:59:49 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id xBBMxe4F029592; Thu, 12 Dec 2019 07:59:40 +0900
X-Iguazu-Qid: 2wGr1LCjibUcg58Ctk
X-Iguazu-QSIG: v=2; s=0; t=1576105180; q=2wGr1LCjibUcg58Ctk; m=gbsfNuz+KBYcNC2h7vb+QMTGEz6U3KO65Z9ucjT1Me4=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1112) id xBBMxd2a004770;
        Thu, 12 Dec 2019 07:59:39 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xBBMxcXf021742;
        Thu, 12 Dec 2019 07:59:38 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xBBMxcMj000808;
        Thu, 12 Dec 2019 07:59:38 +0900
Date:   Thu, 12 Dec 2019 07:59:37 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nguyen Viet Dung <dung.nguyen.aj@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 121/243] ASoC: rsnd: tidyup registering method for
 rsnd_kctrl_new()
X-TSB-HOP: ON
Message-ID: <20191211225937.nnu6kvvbyexfrahr@toshiba.co.jp>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150347.300543701@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150347.300543701@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Dec 11, 2019 at 04:04:43PM +0100, Greg Kroah-Hartman wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> [ Upstream commit 9c698e8481a15237a5b1db5f8391dd66d59e42a4 ]
> 
> Current rsnd dvc.c is using flags to avoid duplicating register for
> MIXer case. OTOH, commit e894efef9ac7 ("ASoC: core: add support to card
> rebind") allows to rebind sound card without rebinding all drivers.
> 
> Because of above patch and dvc.c flags, it can't re-register kctrl if
> only sound card was rebinded, because dvc is keeping old flags.
> (Of course it will be no problem if rsnd driver also be rebinded,
> but it is not purpose of above patch).
> 
> This patch checks current card registered kctrl when registering.
> In MIXer case, it can avoid duplicate register if card already has same
> kctrl. In rebind case, it can re-register kctrl because card registered
> kctl had been removed when unbinding.
> 
> This patch is updated version of commit b918f1bc7f1ce ("ASoC: rsnd: DVC
> kctrl sets once")
> 
> Reported-by: Nguyen Viet Dung <dung.nguyen.aj@renesas.com>
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Tested-by: Nguyen Viet Dung <dung.nguyen.aj@renesas.com>
> Cc: Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This commit also requires the following commit:

commit 7aea8a9d71d54f449f49e20324df06341cc18395
Author: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Date:   Fri Feb 1 16:49:30 2019 +0900

    ASoC: rsnd: fixup MIX kctrl registration

    Renesas sound device has many IPs and many situations.
    If platform/board uses MIXer, situation will be more complex.
    To avoid duplicate DVC kctrl registration when MIXer was used,
    it had original flags.
    But it was issue when sound card was re-binded, because
    no one can't cleanup this flags then.

    To solve this issue, commit 9c698e8481a15237a ("ASoC: rsnd: tidyup
    registering method for rsnd_kctrl_new()") checks registered
    card->controls, because if card was re-binded, these were cleanuped
    automatically. This patch could solve re-binding issue.
    But, it start to avoid MIX kctrl.

    To solve these issues, we need below.
    To avoid card re-binding issue: check registered card->controls
    To avoid duplicate DVC registration: check registered rsnd_kctrl_cfg
    To allow multiple MIX registration: check registered rsnd_kctrl_cfg
    This patch do it.

    Fixes: 9c698e8481a15237a ("ASoC: rsnd: tidyup registering method for rsnd_kctrl_new()")
    Reported-by: Jiada Wang <jiada_wang@mentor.com>
    Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    Tested-By: Jiada Wang <jiada_wang@mentor.com>
    Signed-off-by: Mark Brown <broonie@kernel.org>


Please apply this to 4.19.y and 4.14.y.

Best regards,
  Nobuhiro
