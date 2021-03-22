Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B795343BEA
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCVIjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:39:05 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:44534 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhCVIiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:38:55 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2021 04:38:54 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 0906920C7FE4
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: Patch "module: merge repetitive strings in module_sig_check()"
 has been added to the 5.10-stable tree
To:     Sasha Levin <sashal@kernel.org>
CC:     <stable-commits@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210322030544.97E2961930@mail.kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform
Message-ID: <775e4802-cfdd-e78e-c97b-abf36a49fb43@omprussia.ru>
Date:   Mon, 22 Mar 2021 11:31:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322030544.97E2961930@mail.kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 22.03.2021 6:05, Sasha Levin wrote:

> This is a note to let you know that I've just added the patch titled
> 
>      module: merge repetitive strings in module_sig_check()
> 
> to the 5.10-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       module-merge-repetitive-strings-in-module_sig_check.patch
> and it can be found in the queue-5.10 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

    Why add this patch to the -stable tree? It's just a cleanup...

> commit dd8dfb1bde1ec60845b6e32d1150814d8d98b396
> Author: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> Date:   Sat Oct 31 23:06:45 2020 +0300
> 
>      module: merge repetitive strings in module_sig_check()
>      
>      [ Upstream commit 705e9195187d85249fbb0eaa844b1604a98fbc9a ]
>      
>      The 'reason' variable in module_sig_check() points to 3 strings across
>      the *switch* statement, all needlessly starting with the same text.
>      Let's put the starting text into the pr_notice() call -- it saves 21
>      bytes of the object code (x86 gcc 10.2.1).
>      
>      Suggested-by: Joe Perches <joe@perches.com>
>      Reviewed-by: Miroslav Benes <mbenes@suse.cz>
>      Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>      Signed-off-by: Jessica Yu <jeyu@kernel.org>
>      Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 94f926473e35..3b6dd8200d3d 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2922,16 +2922,17 @@ static int module_sig_check(struct load_info *info, int flags)
>   		 * enforcing, certain errors are non-fatal.
>   		 */
>   	case -ENODATA:
> -		reason = "Loading of unsigned module";
> +		reason = "unsigned module";
>   		goto decide;
>   	case -ENOPKG:
> -		reason = "Loading of module with unsupported crypto";
> +		reason = "module with unsupported crypto";
>   		goto decide;
>   	case -ENOKEY:
> -		reason = "Loading of module with unavailable key";
> +		reason = "module with unavailable key";
>   	decide:
>   		if (is_module_sig_enforced()) {
> -			pr_notice("%s: %s is rejected\n", info->name, reason);
> +			pr_notice("%s: loading of %s is rejected\n",
> +				  info->name, reason);
>   			return -EKEYREJECTED;
>   		}
>   

MBR, Sergei
