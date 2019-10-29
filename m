Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32B9E7DEC
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 02:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbfJ2BZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 21:25:20 -0400
Received: from vps.xff.cz ([195.181.215.36]:51970 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbfJ2BZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 21:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1572312318; bh=yZJ2tr1txca9SLDOy4OtsLu+iAa2f0cZDLnWQ7+OML8=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=A9YyLgNhvrxlUztIuCRhuPElEulYpYKTMOb3Hdyf6b5wAYii97AeXsS/rGMCkEskW
         C0mY/yPIhHdiJKF25+6vtI21q6NsMXjfK/3/CxdTMg40ZTSycRT5LkucjHFQUkMiKD
         jKO8p4ACl0Huenevm29Hl1sHst+Z8pOKmICnXozU=
Date:   Tue, 29 Oct 2019 02:25:17 +0100
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
        stable <stable@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-sunxi] [PATCH] ARM: sunxi: Fix CPU powerdown on A83T
Message-ID: <20191029012517.eddekmphtxyslevx@core.my.home>
Mail-Followup-To: Chen-Yu Tsai <wens@csie.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        stable <stable@vger.kernel.org>, Maxime Ripard <mripard@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM/Allwinner sunXi SoC support" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20191028214914.3465156-1-megous@megous.com>
 <CAGb2v67Vy=tD4dfSXD+=HS3B2tEE-bH2D++gx9Oa=P8n-012ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v67Vy=tD4dfSXD+=HS3B2tEE-bH2D++gx9Oa=P8n-012ew@mail.gmail.com>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 09:09:40AM +0800, Chen-Yu Tsai wrote:
> On Tue, Oct 29, 2019 at 5:49 AM Ondrej Jirman <megous@megous.com> wrote:
> >
> > PRCM_PWROFF_GATING_REG has CPU0 at bit 4 on A83T. So without this
> > patch, instead of gating the CPU0, the whole cluster was power gated,
> > when shutting down first CPU in the cluster.
> >
> > Fixes: 6961275e72a8c1 ("ARM: sun8i: smp: Add support for A83T")
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > Cc: stable@vger.kernel.org
> 
> Acked-by: Chen-Yu Tsai <wens@csie.org>
> 
> Though I distinctly remember the BSP had some code dealing with chip
> revisions in which the two bits were reversed. :(

Actually, it's a bit more complicated. There's a special check in BSP
code (grep for SUN8IW6P1_REV_A) that instead of power gating, just
holds the core in reset for that revision.

regards,
	o.
