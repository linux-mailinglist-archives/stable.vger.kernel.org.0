Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D154F599A7B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348648AbiHSLOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348761AbiHSLOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:14:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AADB2649
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 04:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C1961772
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 11:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999A1C433C1;
        Fri, 19 Aug 2022 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660907655;
        bh=v9XKfWfsN0oL8Ynp38T2UGu/MJ693tUuWeAE23HisaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oNAtM7BYKP4V9ZHYWiKufGZCfKlOOXl7JUwQg1+tLyZ1WIWlWDDS7/YRHM/WkkRj7
         4wbqb1l3JMU4AORfrz+gqnZcpsuAGzOXdirMp7xGNfW0EqHTur/Vc589eyNtzW09nm
         jtDeD3f6sXVlnzaCqrOx+VQolHm1MNrrVXoDEm5g=
Date:   Fri, 19 Aug 2022 13:14:12 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] powerpc/ptdump: Fix display of RW pages
 on FSL_BOOK3E" failed to apply to 4.19-stable tree
Message-ID: <Yv9whLXyKRILwpdt@kroah.com>
References: <16604015377291@kroah.com>
 <d5a228f8-a640-cb66-2494-7da26aa9744a@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5a228f8-a640-cb66-2494-7da26aa9744a@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 08:37:59AM +0000, Christophe Leroy wrote:
> 
> 
> Le 13/08/2022 à 16:38, gregkh@linuxfoundation.org a écrit :
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> 
> For 4.19, not worth the effort to backport without commit 
> 97026b5a5ac26541b3d294146f5c941491a9e609
> 
> With that commit applied, no conflict is observed:
> 
> [chleroy@PO20335 linux-powerpc]$ git log -1 --oneline
> 5c7ccbe1aade (HEAD -> linux-4.19.y, tag: v4.19.255, stable/linux-4.19.y) 
> Linux 4.19.255
> 
> [chleroy@PO20335 linux-powerpc]$ git cherry-pick 
> 97026b5a5ac26541b3d294146f5c941491a9e609
> Fusion automatique de arch/powerpc/mm/dump_linuxpagetables.c
> [linux-4.19.y 55605f963e22] powerpc/mm: Split dump_pagelinuxtables 
> flag_array table
>   Author: Christophe Leroy <christophe.leroy@c-s.fr>
>   Date: Tue Oct 9 13:51:58 2018 +0000
>   6 files changed, 307 insertions(+), 153 deletions(-)
>   create mode 100644 arch/powerpc/mm/dump_linuxpagetables-8xx.c
>   create mode 100644 arch/powerpc/mm/dump_linuxpagetables-book3s64.c
>   create mode 100644 arch/powerpc/mm/dump_linuxpagetables-generic.c
>   create mode 100644 arch/powerpc/mm/dump_linuxpagetables.h
> 
> [chleroy@PO20335 linux-powerpc]$ git cherry-pick 
> dd8de84b57b02ba9c1fe530a6d916c0853f136bd
> Fusion automatique de arch/powerpc/mm/dump_linuxpagetables-generic.c
> [linux-4.19.y 864f14f5b787] powerpc/ptdump: Fix display of RW pages on 
> FSL_BOOK3E
>   Date: Tue Jun 28 16:43:35 2022 +0200
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Thanks, that worked.

greg k-h
