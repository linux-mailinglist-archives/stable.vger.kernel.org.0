Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE7F599ABD
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348267AbiHSLOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348328AbiHSLOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68BDCD52C;
        Fri, 19 Aug 2022 04:14:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2893361774;
        Fri, 19 Aug 2022 11:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3613CC433D6;
        Fri, 19 Aug 2022 11:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660907683;
        bh=kDXswYVpUCYLT3UTIkFVumBaq4rqupxUuITGN/kJSOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DhppuO0tmOnh2os/5LwxBu29Woali0ev9vHWguiB1aWmdck4cF0H1IbjIBO763iCx
         HoU4jQFvQn666hO1lgnEnG43SMmSLh9HxeUYwBJZwz+VTIF7DS3QpMl2fugR40UDWs
         NKFcioAuHWKdSbWNsfj/F6IlQ1J35FNqyfdVqE9A=
Date:   Fri, 19 Aug 2022 13:14:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] [backport for 4.14] powerpc/ptdump: Fix display of RW
 pages on FSL_BOOK3E
Message-ID: <Yv9woV6S3VmwEibv@kroah.com>
References: <2cf5dabc5d295a1591055a042aa1b791214a2f47.1660639498.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf5dabc5d295a1591055a042aa1b791214a2f47.1660639498.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 10:45:29AM +0200, Christophe Leroy wrote:
> [ Upstream commit dd8de84b57b02ba9c1fe530a6d916c0853f136bd ]
> 
> On FSL_BOOK3E, _PAGE_RW is defined with two bits, one for user and one
> for supervisor. As soon as one of the two bits is set, the page has
> to be display as RW. But the way it is implemented today requires both
> bits to be set in order to display it as RW.
> 
> Instead of display RW when _PAGE_RW bits are set and R otherwise,
> reverse the logic and display R when _PAGE_RW bits are all 0 and
> RW otherwise.
> 
> This change has no impact on other platforms as _PAGE_RW is a single
> bit on all of them.
> 
> Fixes: 8eb07b187000 ("powerpc/mm: Dump linux pagetables")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/0c33b96317811edf691e81698aaee8fa45ec3449.1656427391.git.christophe.leroy@csgroup.eu
> ---
>  arch/powerpc/mm/dump_linuxpagetables.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 

Now queued up.

greg k-h
