Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D1E4B3B1D
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 12:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiBML10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 06:27:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiBML1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 06:27:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AB35B3FD
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 03:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82AA7B80761
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 11:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E51C004E1;
        Sun, 13 Feb 2022 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644751637;
        bh=UV7f8L0Okfsc7WKYj4MDggWVXQaWRc+TjmtfE2x36qA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cju6jyr051r2cpeietUgkr6hLk9i6zls2XspPNw2WKyc/DoxZL3XQXhifELo4IAMJ
         UPZutrd/wv/3s/zBgLOK2OrBtdGXn3P3tLCSaykK/5+ASwEDu6gWc1Id5BCu4xpaIU
         nQC40qsucBEpNisdBYm3nSqtsfv7UBmhRHzBxTVM=
Date:   Sun, 13 Feb 2022 12:27:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     stable@vger.kernel.org, pali@kernel.org
Subject: Re: [PATCH] hwmon: (dell-smm) Speed up setting of fan speed
Message-ID: <YgjrEjD067GrtZ55@kroah.com>
References: <20220212225418.16662-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220212225418.16662-1-W_Armin@gmx.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 12, 2022 at 11:54:18PM +0100, Armin Wolf wrote:
> commit c0d79987a0d82671bff374c07f2201f9bdf4aaa2 upstream.
> 
> When setting the fan speed, i8k_set_fan() calls i8k_get_fan_status(),
> causing an unnecessary SMM call since from the two users of this
> function, only i8k_ioctl_unlocked() needs to know the new fan status
> while dell_smm_write() ignores the new fan status.
> Since SMM calls can be very slow while also making error reporting
> difficult for dell_smm_write(), remove the function call from
> i8k_set_fan() and call it separately in i8k_ioctl_unlocked().
> 
> Since this patch was backported from kernel 5.16, the data argument
> of i8k_set_fan and i8k_get_fan_status was omitted (it exists since
> kernel 5.15).
> 
> This patch was originally a performance optimization, but it turned
> out a user with a buggy machine requires this patch since it also
> fixes error reporting when i8k_get_fan_status fails.
> https://github.com/lm-sensors/lm-sensors/pull/383
> 
> Tested on a Dell Inspiron 3505.
> 
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: <stable@vger.kernel.org> # 5.4.x
> Cc: <stable@vger.kernel.org> # 4.x.x
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---
>  drivers/hwmon/dell-smm-hwmon.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

All now queued up, thanks!
