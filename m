Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB9E5866A0
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 10:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiHAIy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 04:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiHAIy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 04:54:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CB13AE79
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 01:54:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E056F61031
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 08:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7FFC433D6;
        Mon,  1 Aug 2022 08:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659344066;
        bh=9H02QHosvymdeSV/aCXjaqBu/8TaV+rqvACpnxfAqrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f95H4WapxXUiddtkf0ydaaC/ggihisdizI+5Rmph4IYYknmvjgunSPhslOdLuUai1
         u0QP1Ju/Yr/fIZ3sYdiyNNxWG2yU7Asq0LHKOOZrdmlzl4roWF7MN/luzYcwrRp7VW
         Ufrl486b/eSBC+X7yLkei3vt6vXjGVkEtNvl0xTM=
Date:   Mon, 1 Aug 2022 10:54:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org,
        llvm@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 4.9] ion: Make user_ion_handle_put_nolock() a void
 function
Message-ID: <YueUv32PkLdw651V@kroah.com>
References: <20220727164617.980209-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727164617.980209-1-nathan@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 09:46:17AM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   drivers/staging/android/ion/ion-ioctl.c:71:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>           if (--handle->user_ref_count == 0)
>               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/staging/android/ion/ion-ioctl.c:74:9: note: uninitialized use occurs here
>           return ret;
>                  ^~~
>   drivers/staging/android/ion/ion-ioctl.c:71:2: note: remove the 'if' if its condition is always true
>           if (--handle->user_ref_count == 0)
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/staging/android/ion/ion-ioctl.c:69:9: note: initialize the variable 'ret' to silence this warning
>           int ret;
>                  ^
>                   = 0
>   1 warning generated.
> 
> The return value of user_ion_handle_put_nolock() is not checked in its
> one call site in user_ion_free_nolock() so just make
> user_ion_handle_put_nolock() return void to remove the warning.
> 
> Fixes: a8200613c8c9 ("ion: Protect kref from userspace manipulation")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/staging/android/ion/ion-ioctl.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Now queued up, thanks.

greg k-h
