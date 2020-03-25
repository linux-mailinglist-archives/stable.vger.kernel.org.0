Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9524D192F5D
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 18:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgCYRe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 13:34:29 -0400
Received: from elvis.franken.de ([193.175.24.41]:34605 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgCYRe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 13:34:29 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jH9v6-0008NM-00; Wed, 25 Mar 2020 18:34:24 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 405D9C0D46; Wed, 25 Mar 2020 18:30:43 +0100 (CET)
Date:   Wed, 25 Mar 2020 18:30:43 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org,
        Pei Huang <huangpei@loongson.cn>
Subject: Re: [PATCH] MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3
Message-ID: <20200325173043.GA17524@alpha.franken.de>
References: <1585107894-8803-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585107894-8803-1-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 11:44:54AM +0800, Huacai Chen wrote:
> LDDIR/LDPTE is Loongson-3's acceleration for Page Table Walking. If BD
> (Base Directory, the 4th page directory) is not enabled, then GDOffset
> is biased by BadVAddr[63:62]. So, if GDOffset (aka. BadVAddr[47:36] for
> Loongson-3) is big enough, "0b11(BadVAddr[63:62])|BadVAddr[47:36]|...."
> can far beyond pg_swapper_dir. This means the pg_swapper_dir may NOT be
> accessed by LDDIR correctly, so fix it by set PWDirExt in CP0_PWCtl.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Pei Huang <huangpei@loongson.cn>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/mm/tlbex.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
