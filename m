Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E239560491
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 17:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiF2P2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 11:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiF2P2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 11:28:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7008F1F607;
        Wed, 29 Jun 2022 08:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 175F460B27;
        Wed, 29 Jun 2022 15:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55365C34114;
        Wed, 29 Jun 2022 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656516523;
        bh=9m05X+L1Yh5lABIuv59hR8VxTgJT7AqHQH/3/akiMDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vzkbkL6HN99ITQh6yKy8GY8NqM2ZQYHkpvTFkn1Af+5C5+01TEnR87Nj5ogMr9DZ9
         rDgbs8vh9HTe55KzhaScC3Ai23yAurcgTC8uVcidsHIPkZHALQxqiVkyicaAQenybE
         604ilyZm2rtJjKhO3He67IVwaNhNB20hy9f2peTg=
Date:   Wed, 29 Jun 2022 17:28:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v8] ath9k: let sleep be interrupted when unregistering
 hwrng
Message-ID: <Yrxvo4omb2qKNOVJ@kroah.com>
References: <Yrw5f8GN2fh2orid@zx2c4.com>
 <20220629114240.946411-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629114240.946411-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 01:42:40PM +0200, Jason A. Donenfeld wrote:
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4284,6 +4284,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
>  {
>  	return try_to_wake_up(p, state, 0);
>  }
> +EXPORT_SYMBOL(wake_up_state);

Should be EXPORT_SYMBOL_GPL(), right?

thanks,

greg k-h
