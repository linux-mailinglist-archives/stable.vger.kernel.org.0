Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6ECF552AB7
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 08:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbiFUGDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 02:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345407AbiFUGDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 02:03:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8FD120A6
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 23:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DEC261185
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 06:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2C5C3411D;
        Tue, 21 Jun 2022 06:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655791387;
        bh=TeTiw65TlF3YNpUIYadOfqrtnot+16lUNz9Rp9WN2+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I3pufI9XAfMarM4+peM8MUYdPdAChE9xApAyZBULXnad1O6AMsoluaPSsoHq+UpNT
         jPiuW0ipOLDRfiMXAHwqzWZru22Lta8zgVKmkFxtlhpIDAuy50BZegpHe+u7xRsW/4
         RdC5gi4tVOfij8o/6V2crBlNs3/coCgLbxAtziVY=
Date:   Tue, 21 Jun 2022 08:03:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: patch request for 5.18-stable to fix gcc-12 build
Message-ID: <YrFfF4O/y/MjZTsJ@kroah.com>
References: <YqxguwkPJhyvKbRk@debian>
 <YrBILWzY4ziMl7xE@kroah.com>
 <0a063bd4-e719-6179-fd44-356617026539@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a063bd4-e719-6179-fd44-356617026539@suse.cz>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 07:03:20AM +0200, Jiri Slaby wrote:
> On 20. 06. 22, 12:13, Greg Kroah-Hartman wrote:
> > On Fri, Jun 17, 2022 at 12:08:43PM +0100, Sudip Mukherjee wrote:
> > > Hi Greg,
> > > 
> > > v5.18.y riscv builds fails with gcc-12. Can I please request to add the
> > > following to the queue:
> > > 
> > > f0be87c42cbd ("gcc-12: disable '-Warray-bounds' universally for now")
> > > 49beadbd47c2 ("gcc-12: disable '-Wdangling-pointer' warning for now")
> > > 7e415282b41b ("virtio-pci: Remove wrong address verification in vp_del_vqs()")
> > > 
> > > This is only for the config that fdsdk is using, I will start a full
> > > allmodconfig to check if anything else is needed.
> > 
> > Now queued up, thanks.
> > 
> > I don't think 5.18 will build with gcc-12 for x86-64 yet either, I'm
> > sticking with gcc-11 for my builds at the moment...
> 
> FWIW Tumbleweed compiles using gcc 12 since around 5.17.5. (Obviously, with
> CONFIG_WERROR unset.)

Yeah, I want to be able to set that value again, it helps out a lot with
testing stable patches to ensure that nothing got accidentally
backported improperly.

thanks,

greg k-h
