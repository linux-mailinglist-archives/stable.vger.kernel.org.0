Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F218343BF8
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhCVIlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:41:50 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:59918 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhCVIlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:41:19 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru BF17920AF1BA
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: Patch "module: avoid *goto*s in module_sig_check()" has been
 added to the 5.10-stable tree
To:     Sasha Levin <sashal@kernel.org>
CC:     <stable-commits@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210322030545.C1CC761931@mail.kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform
Message-ID: <b57c2e45-0114-c7ea-4665-307a82826ff7@omprussia.ru>
Date:   Mon, 22 Mar 2021 11:35:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322030545.C1CC761931@mail.kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.03.2021 6:05, Sasha Levin wrote:

> This is a note to let you know that I've just added the patch titled
> 
>      module: avoid *goto*s in module_sig_check()
> 
> to the 5.10-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       module-avoid-goto-s-in-module_sig_check.patch
> and it can be found in the queue-5.10 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

    Again, it's just a cleanup...

> commit c5d4af31cebd2d83fdb7bb7b7d11cbc086c18a4a
> Author: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> Date:   Sat Oct 31 23:09:31 2020 +0300
> 
>      module: avoid *goto*s in module_sig_check()
>      
>      [ Upstream commit 10ccd1abb808599a6dc7c9389560016ea3568085 ]
>      
>      Let's move the common handling of the non-fatal errors after the *switch*
>      statement -- this avoids *goto*s inside that *switch*...
>      
>      Suggested-by: Joe Perches <joe@perches.com>
>      Reviewed-by: Miroslav Benes <mbenes@suse.cz>
>      Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>      Signed-off-by: Jessica Yu <jeyu@kernel.org>
>      Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 3b6dd8200d3d..f1be6b6a3a3d 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2923,20 +2923,13 @@ static int module_sig_check(struct load_info *info, int flags)
>   		 */
>   	case -ENODATA:
>   		reason = "unsigned module";
> -		goto decide;
> +		break;
>   	case -ENOPKG:
>   		reason = "module with unsupported crypto";
> -		goto decide;
> +		break;
>   	case -ENOKEY:
>   		reason = "module with unavailable key";
> -	decide:
> -		if (is_module_sig_enforced()) {
> -			pr_notice("%s: loading of %s is rejected\n",
> -				  info->name, reason);
> -			return -EKEYREJECTED;
> -		}
> -
> -		return security_locked_down(LOCKDOWN_MODULE_SIGNATURE);
> +		break;
>   
>   		/* All other errors are fatal, including nomem, unparseable
>   		 * signatures and signature check failures - even if signatures
> @@ -2945,6 +2938,13 @@ static int module_sig_check(struct load_info *info, int flags)
>   	default:
>   		return err;
>   	}
> +
> +	if (is_module_sig_enforced()) {
> +		pr_notice("%s: loading of %s is rejected\n", info->name, reason);
> +		return -EKEYREJECTED;
> +	}
> +
> +	return security_locked_down(LOCKDOWN_MODULE_SIGNATURE);
>   }
>   #else /* !CONFIG_MODULE_SIG */
>   static int module_sig_check(struct load_info *info, int flags)
> 

