Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03626DF744
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 15:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjDLNeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 09:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDLNeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 09:34:16 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B7739742;
        Wed, 12 Apr 2023 06:33:38 -0700 (PDT)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1pmabN-0000FF-05; Wed, 12 Apr 2023 15:33:33 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 70732C2458; Wed, 12 Apr 2023 15:32:34 +0200 (CEST)
Date:   Wed, 12 Apr 2023 15:32:34 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        and@gmx.com, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: fw: Allow firmware to pass a empty env
Message-ID: <20230412133234.GF11717@alpha.franken.de>
References: <20230411111426.55889-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411111426.55889-1-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 12:14:26PM +0100, Jiaxun Yang wrote:
> fw_getenv will use env entry to determine style of env,
> however it is legal for firmware to just pass a empty list.
> 
> Check if first entry exist before running strchr to avoid
> null pointer dereference.
> 
> Cc: stable@vger.kernel.org
> Link: https://github.com/clbr/n64bootloader/issues/5
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
> Note: Fixes tag is intentionally omitted for this patch, although
> the booting issue only comes in 6.1, the logic issue is been since very start.
> ---
>  arch/mips/fw/lib/cmdline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/fw/lib/cmdline.c b/arch/mips/fw/lib/cmdline.c
> index f24cbb4a39b5..892765b742bb 100644
> --- a/arch/mips/fw/lib/cmdline.c
> +++ b/arch/mips/fw/lib/cmdline.c
> @@ -53,7 +53,7 @@ char *fw_getenv(char *envname)
>  {
>  	char *result = NULL;
>  
> -	if (_fw_envp != NULL) {
> +	if (_fw_envp != NULL && fw_envp(0) != NULL) {
>  		/*
>  		 * Return a pointer to the given environment variable.
>  		 * YAMON uses "name", "value" pairs, while U-Boot uses
> -- 
> 2.39.2 (Apple Git-143)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
