Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043C64F5D15
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 14:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiDFMCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 08:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiDFMBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 08:01:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75343501B7B;
        Wed,  6 Apr 2022 00:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1309961ACC;
        Wed,  6 Apr 2022 07:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5381C385A1;
        Wed,  6 Apr 2022 07:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649230965;
        bh=FPQgizAWfaK6hQrax6XOm+ZiH05200LIn8p/UnCbPH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uSN9vjECe0QbprUSN33rHnuuDiIBd7LroDpZgZB8/4iZEQpSOhKL+KpNzPWHwHHol
         M1pjajCX5qeVhJ2tOZw74c5oBO2IYZvv4TEYAzwNF3SAarEB6SOxtuiZMArvTNVXwJ
         2U1AW5pj9J2NoIPiMHl/KrXCLHWA7asjCaXzQKBc=
Date:   Wed, 6 Apr 2022 09:42:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Michael Walle <michael@walle.cc>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.16 0018/1017] Revert "gpio: Revert regression in
 sysfs-gpio (gpiolib.c)"
Message-ID: <Yk1EcpVPLSZbE0Xx@kroah.com>
References: <20220405070354.155796697@linuxfoundation.org>
 <20220405070354.714970989@linuxfoundation.org>
 <20220405212852.GA5493@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405212852.GA5493@amd>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 11:28:52PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 56e337f2cf1326323844927a04e9dbce9a244835 ]
> > 
> > This reverts commit fc328a7d1fcce263db0b046917a66f3aa6e68719.
> > 
> > This commit - while attempting to fix a regression - has caused a number
> > of other problems. As the fallout from it is more significant than the
> > initial problem itself, revert it for now before we find a correct
> > solution.
> 
> The patch this reverts is queued as 15/ in the series. Rather than
> applying broken patch and then reverting, it would be better to drop
> both, right?

No, this way we don't accidentally add the patch back when the scripts
go "hey, you forgot this old commit!"

thanks,

greg k-h
