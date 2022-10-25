Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1470B60CD33
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 15:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiJYNQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 09:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiJYNQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 09:16:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171EE4C34;
        Tue, 25 Oct 2022 06:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 53BFFCE1D3E;
        Tue, 25 Oct 2022 13:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266A4C433C1;
        Tue, 25 Oct 2022 13:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666703793;
        bh=wVGWwrHfgzYkkGdBBbnsd8BkLklDXYYfWo7u/4uzzdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ni5aywoaYtYYP26T27kHY/BmtpFOgTt8rIcI5g/1jRhh2uxzb2MSfT6qYC8ziQWu5
         qTzUbqvxV5Cu4dOzR1KCPElB28UeVIf7nmRRAQTriHg5wrrNCY/i0rtsT4mq+07wrn
         qJf7wricUf6qQBlKdDCV4YhoD/zORLGIqASEel9Y=
Date:   Tue, 25 Oct 2022 15:16:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH 5.10 044/390] serial: 8250: Let drivers request full
 16550A feature probing
Message-ID: <Y1fhrrEz50XCmD79@kroah.com>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113024.492214172@linuxfoundation.org>
 <20221024172710.GA24827@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024172710.GA24827@duo.ucw.cz>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 07:27:10PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Maciej W. Rozycki <macro@orcam.me.uk>
> > 
> > commit 9906890c89e4dbd900ed87ad3040080339a7f411 upstream.
> > 
> > A SERIAL_8250_16550A_VARIANTS configuration option has been recently
> > defined that lets one request the 8250 driver not to probe for 16550A
> > device features so as to reduce the driver's device startup time in
> > virtual machines.
> > 
> > Some actual hardware devices require these features to have been fully
> > determined however for their driver to work correctly, so define a flag
> > to let drivers request full 16550A feature probing on a device-by-device
> > basis if required regardless of the SERIAL_8250_16550A_VARIANTS option
> > setting chosen.
> 
> As far as I can see, the UPF_FULL_PROBE is never set in 5.10.150 tree,
> so we should not need it there.

Ah, yes, it was tagged wrong.  I'll go drop this now, it's only needed
in 5.15.y

thanks,

greg k-h
