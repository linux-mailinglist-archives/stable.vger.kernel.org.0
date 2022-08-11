Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C5B58FC0C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 14:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiHKMR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 08:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbiHKMRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 08:17:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD6390C7C
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 05:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 154E961387
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 12:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CD2C433C1;
        Thu, 11 Aug 2022 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660220263;
        bh=KH4mObGhRms5ZZ50BNpULdlzIav57A1QFB5Ry2HO0Hg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tB81CCw1NtvAKaPW5bE7dqev2lMhAPiLkv3G35zzOxauAwsld5rK0AjEH8uj3FqMo
         zhNA0bGMhbZ79F9CY5+ONB5bs99XACCZUu4Zt7itCTFhrBF0ERyrEqRSGsse3xxb5B
         kUghSRcbxWnbdCOmvkvPazHvdshVndYDpFJ2HBTY=
Date:   Thu, 11 Aug 2022 14:17:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH 4.9 1/1] LSM: Initialize security_hook_heads upon
 registration.
Message-ID: <YvTzZM499PnOTMZD@kroah.com>
References: <20220811115340.137901-1-theflamefire89@gmail.com>
 <20220811115340.137901-2-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811115340.137901-2-theflamefire89@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 01:53:40PM +0200, Alexander Grund wrote:
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> commit 3dfc9b02864b19f4dab376f14479ee4ad1de6c9e upstream.
> 
> "struct security_hook_heads" is an array of "struct list_head"
> where elements can be initialized just before registration.
> 
> There is no need to waste 350+ lines for initialization. Let's
> initialize "struct security_hook_heads" just before registration.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: John Johansen <john.johansen@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: Casey Schaufler <casey@schaufler-ca.com>
> Cc: James Morris <james.l.morris@oracle.com>
> Signed-off-by: James Morris <james.l.morris@oracle.com>
> [ bp: 4.9 backported: Adjust for changed hooks and missing __lsm_ro_after_init ]
> Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
> ---
>  security/security.c | 359 +-------------------------------------------
>  1 file changed, 7 insertions(+), 352 deletions(-)

As this fixes no bug or real issue that anyone is having with 4.9, why
is this needed?

What devices and users would benefit from this that would need it for
the next 5 months only before they move to 4.14.y?  And why aren't those
users on 4.14.y already?

thanks,

greg k-h
