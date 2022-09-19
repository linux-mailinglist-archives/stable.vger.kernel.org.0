Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966815BC434
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 10:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiISIVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 04:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiISIVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 04:21:49 -0400
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4458820BEE;
        Mon, 19 Sep 2022 01:21:47 -0700 (PDT)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 6475D72C90B;
        Mon, 19 Sep 2022 11:21:45 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 609B44A472A;
        Mon, 19 Sep 2022 11:21:43 +0300 (MSK)
Date:   Mon, 19 Sep 2022 11:21:43 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 22/41] video: fbdev: pxa3xx-gcu: Fix integer
 overflow in pxa3xx_gcu_write
Message-ID: <20220919082143.g4gn5ssbzolnc57b@altlinux.org>
References: <20220628022100.595243-1-sashal@kernel.org>
 <20220628022100.595243-22-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20220628022100.595243-22-sashal@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 10:20:41PM -0400, Sasha Levin wrote:
> From: Hyunwoo Kim <imv4bel@gmail.com>
> 
> [ Upstream commit a09d2d00af53b43c6f11e6ab3cb58443c2cac8a7 ]
> 
> In pxa3xx_gcu_write, a count parameter of type size_t is passed to words of
> type int.  Then, copy_from_user() may cause a heap overflow because it is used
> as the third argument of copy_from_user().

Why this commit is still not in the stable branches?
Isn't this is the fix for CVE-2022-39842[1]?

Thanks,

[1] https://nvd.nist.gov/vuln/detail/CVE-2022-39842

> 
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/video/fbdev/pxa3xx-gcu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
> index 9421d14d0eb0..9e9888e40c57 100644
> --- a/drivers/video/fbdev/pxa3xx-gcu.c
> +++ b/drivers/video/fbdev/pxa3xx-gcu.c
> @@ -381,7 +381,7 @@ pxa3xx_gcu_write(struct file *file, const char *buff,
>  	struct pxa3xx_gcu_batch	*buffer;
>  	struct pxa3xx_gcu_priv *priv = to_pxa3xx_gcu_priv(file);
>  
> -	int words = count / 4;
> +	size_t words = count / 4;
>  
>  	/* Does not need to be atomic. There's a lock in user space,
>  	 * but anyhow, this is just for statistics. */
> -- 
> 2.35.1
> 
