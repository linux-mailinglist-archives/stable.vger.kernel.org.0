Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F195313CF
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbiEWPPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbiEWPPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:15:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87E749FB4
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E9F5B810AC
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6881C385AA;
        Mon, 23 May 2022 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653318929;
        bh=J3kxtOn6ZDUt90cJeyS/vcT4mwnUnAWQsYk7KGdET6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WQ1i8cx8425G/NRiWWBLUnVawhca6Cg0uHGea8ken8fg8/h429nrBgOsorJ7sZv0a
         xOKEvLrh5AQBVI7oGVhOZsatNqIqogTgeVRS5ZpDfVWfeIvCN8eBu/4RBpilm/qNN9
         wK55nbDKojWRQ3kMErKffTkfT3uzM640xpyCcNpg=
Date:   Mon, 23 May 2022 17:15:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     linux-stable <stable@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joerg Vehlow <joerg.vehlow@aox.de>
Subject: Re: [PATCH 5.10] module: treat exit sections the same as init
 sections when !CONFIG_MODULE_UNLOAD
Message-ID: <YoulDn99IXPd6xBM@kroah.com>
References: <342c6a9f-771f-0714-e02c-08d0c0f4cd6b@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342c6a9f-771f-0714-e02c-08d0c0f4cd6b@jv-coder.de>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 06:39:48AM +0200, Joerg Vehlow wrote:
> Hi,
> 
> this mainline patch 33121347fb1c359bd6e3e680b9f2c6ced5734a8 should be
> applied to 5.15 as well.

You mean 5.10, right?  It's already in 5.13 and newer releases

> Without loading of some modules fails, if
>  1. MODULE_UNLOAD=n
>  2. Architecture is aarch64 (maybe others as well)
>  3. KASLR is active
> 
> Without this patch the symbol .exit.text is not relocated and when the
> linker generated a relative 32 bit relocation(PREL32) and the module is
> loaded far enough away from the default loading address, it will trigger
> a relocation overflow like this:
> 
> module algif_hash: overflow in relocation type 261 val ffff800010051c20
> 
> This happens to all modules, that use BUG in the exit section or if the
> compiler generates a jump table in the exit section.

Now queued up for 5.10.y, thanks.

greg k-h
