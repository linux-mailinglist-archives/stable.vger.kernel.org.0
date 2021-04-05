Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE31354260
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhDENft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 09:35:49 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:52348 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhDENft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 09:35:49 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 8967D20E3CC1
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 5.4 03/74] module: merge repetitive strings in
 module_sig_check()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210405085024.703004126@linuxfoundation.org>
 <20210405085024.812932452@linuxfoundation.org>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <35560933-d158-76ee-0034-0b5f43d9a3c2@omprussia.ru>
Date:   Mon, 5 Apr 2021 16:35:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210405085024.812932452@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/21 11:53 AM, Greg Kroah-Hartman wrote:

> From: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> 
> [ Upstream commit 705e9195187d85249fbb0eaa844b1604a98fbc9a ]
> 
> The 'reason' variable in module_sig_check() points to 3 strings across
> the *switch* statement, all needlessly starting with the same text.
> Let's put the starting text into the pr_notice() call -- it saves 21
> bytes of the object code (x86 gcc 10.2.1).
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> Signed-off-by: Jessica Yu <jeyu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/module.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index ab1f97cfe18d..9fe3e9b85348 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2908,16 +2908,17 @@ static int module_sig_check(struct load_info *info, int flags)
>  		 * enforcing, certain errors are non-fatal.
>  		 */
>  	case -ENODATA:
> -		reason = "Loading of unsigned module";
> +		reason = "unsigned module";
>  		goto decide;
>  	case -ENOPKG:
> -		reason = "Loading of module with unsupported crypto";
> +		reason = "module with unsupported crypto";
>  		goto decide;
>  	case -ENOKEY:
> -		reason = "Loading of module with unavailable key";
> +		reason = "module with unavailable key";
>  	decide:
>  		if (is_module_sig_enforced()) {
> -			pr_notice("%s is rejected\n", reason);
> +			pr_notice("%s: loading of %s is rejected\n",
> +				  info->name, reason);

   Mhm, in 5.4 there was no printing of 'info->name'...

[...]

MBR, Sergey
