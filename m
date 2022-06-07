Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CA553F945
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbiFGJPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239101AbiFGJPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:15:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823FBAE24B;
        Tue,  7 Jun 2022 02:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1392960B04;
        Tue,  7 Jun 2022 09:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9E9C385A5;
        Tue,  7 Jun 2022 09:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654593332;
        bh=71J8tbY0PQ1Gu6dEU4y9Z9et5FuCkQMlodd8idd5KuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nczUUTzvaL2rPA3pyJ+2us4OihBNRyXBW1HvEDaW9szUdVPUpY8l3s+hoCo4dgvaY
         S2Ga6GashrGJNf7R5tdJSROyx+/F8glH4seWbHdMxF1kQ2eo9o6vcX7wS9gx+2eKkP
         rChlwRrdZJkIJObli+LI+zfD0REWr7CPHXVsdQ1g=
Date:   Tue, 7 Jun 2022 11:10:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
Message-ID: <Yp8WBaqr+sLInNnc@kroah.com>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
 <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 09:47:30AM +0100, Phil Elwell wrote:
> Hi Jason,
> 
> On 07/06/2022 09:30, Jason A. Donenfeld wrote:
> > Hi Phil,
> > 
> > Thanks for testing this. Can you let me know if v1 of this works?
> > 
> > https://lore.kernel.org/lkml/20220602212234.344394-1-Jason@zx2c4.com/
> > 
> > (I'll also fashion a revert for this part of stable.)
> > 
> > Jason
> 
> Thanks for the quick response, but that doesn't work for me either. Let me
> say again that I'm on a downstream kernel (rpi-5.15.y) so this may not be a
> universal problem, but merging either of these fixing patches would be fatal
> for us.

I have reports of a "clean" 5.15.45 working just fine on a rpi.
Anything special in your tree that isn't upstream yet that might be
conflicting with this?  Any chance you can try a kernel.org release
instead?

thanks,

greg k-h
