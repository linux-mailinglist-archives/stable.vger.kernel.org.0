Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE32D58C979
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 15:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbiHHNbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 09:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243342AbiHHNaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 09:30:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A01391
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 06:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C72EEB80E8D
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 13:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C5CC433D6;
        Mon,  8 Aug 2022 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659965448;
        bh=w68cmlPJfXm2Wk8HtdOsozr9cV/jmFqVKx3WEX6N1yA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fKY5V68XOhvB0uYAkjnNSsa/wvXTv5uzlcdwEsewRmgR5TWYDKNnhskHbMWdfEDx7
         GkI5PikNxj7tGTq/EchtEC4Kptn50dw7R2FhLBOxTXBnnduk75wBZ9ceKtohXb/VQf
         R4KoASpzX4OhVjdoR6eW8auqp4Rrkj/0VMhRxCBo=
Date:   Mon, 8 Aug 2022 15:30:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/1] selinux: allow dontauditx and auditallowx rules
 to take effect without allowx
Message-ID: <YvEQBYO11g9ynGGz@kroah.com>
References: <20220808102049.46386-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808102049.46386-1-theflamefire89@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 12:20:48PM +0200, Alexander Grund wrote:
> This patch fixes an inconsistency, if not a clear bug, with the extended permissions.
> To quote from the original discussion [1]:
> > The behavior of dontauditx and auditallowx appears to be broken making them useless.
> 
> [1] https://lore.kernel.org/selinux/6a791504-7728-3026-17ee-c22cbff8c3d1@gmail.com/T/
> 
> bauen1 (1):
>   selinux: allow dontauditx and auditallowx rules to take effect without allowx
> 
>  security/selinux/ss/services.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

For obvious reasons, we can't take patches only for 4.9.y that are not
also in newer kernel branches.  You don't want to upgrade to 4.14.y and
have a regression, right?

So this would need to be backported to 4.14.y, 4.19.y, 5.4.y, and 5.10.y
before we could consider it.

BUT, as this is something that just never worked, why is it needed at
all?  Making it work is a "new feature", not really a bugfix for these
older kernels as it is not a regression.

I'll drop this from my queue, if you really think it needs to come back,
we need backports for all affected kernel branches.

thanks,

greg k-h
