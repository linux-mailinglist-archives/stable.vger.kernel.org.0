Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABAC625DE5
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 16:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiKKPI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 10:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbiKKPID (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 10:08:03 -0500
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A906663CF;
        Fri, 11 Nov 2022 07:06:47 -0800 (PST)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1otVcD-00037d-03; Fri, 11 Nov 2022 16:06:45 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id F242CC11F2; Fri, 11 Nov 2022 16:04:24 +0100 (CET)
Date:   Fri, 11 Nov 2022 16:04:24 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        ardb@kernel.org, rostedt@goodmis.org, stable@vger.kernel.org,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Subject: Re: [PATCH v2] MIPS: jump_label: Fix compat branch range check
Message-ID: <20221111150424.GD13465@alpha.franken.de>
References: <20221103151053.213583-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221103151053.213583-1-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 03, 2022 at 03:10:53PM +0000, Jiaxun Yang wrote:
> Cast upper bound of branch range to long to do signed compare,
> avoid negative offset trigger this warning.
> 
> Fixes: 9b6584e35f40 ("MIPS: jump_label: Use compact branches for >= r6")
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
> v2: Fix typo, collect review tags.
> ---
>  arch/mips/kernel/jump_label.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
> index 71a882c8c6eb..f7978d50a2ba 100644
> --- a/arch/mips/kernel/jump_label.c
> +++ b/arch/mips/kernel/jump_label.c
> @@ -56,7 +56,7 @@ void arch_jump_label_transform(struct jump_entry *e,
>  			 * The branch offset must fit in the instruction's 26
>  			 * bit field.
>  			 */
> -			WARN_ON((offset >= BIT(25)) ||
> +			WARN_ON((offset >= (long)BIT(25)) ||
>  				(offset < -(long)BIT(25)));
>  
>  			insn.j_format.opcode = bc6_op;
> -- 
> 2.34.1

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
