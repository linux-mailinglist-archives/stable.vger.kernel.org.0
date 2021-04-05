Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28D23544F9
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242751AbhDEQOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242366AbhDEQOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EFFE61025;
        Mon,  5 Apr 2021 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617639243;
        bh=+71CR4VPWaNxi6TkmQ3DsUkmoBmkMqvKWMBfCKtK+9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AgllefME47CDaOfwozWGvxuUfjANDCamRS+6/f71FlvvKxMKT7T7oEmUqMB1MQi6F
         VHTbduM2v1yYV3M/6BnczpuQmidyS2o4NeoQorDbZ8ASoiA1SBguZiB1XoZTLi2fz/
         pgW3AZwGTJUd2WmZ6yq50oE907eZixK9QibKhI1D67iWFAcnRDubxDvn4kCE3s3Yeb
         1pBSXZgh2CsAPCZxlIIBJZbR3PCQbTZ8QHwskhpjGXehLmkM52Jfti27hnGBkI2xk9
         R/xSf0h3XkDh0YCY0WEJB+Dyqpyr0g5KJig3eUW/L+kGtbCdJupArRNVDySRCcwhiD
         ftU84jHl3l0lg==
Date:   Mon, 5 Apr 2021 12:14:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joe Perches <joe@perches.com>, Miroslav Benes <mbenes@suse.cz>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 5.4 03/74] module: merge repetitive strings in
 module_sig_check()
Message-ID: <YGs3SoEiLEW3pWOE@sashalap>
References: <20210405085024.703004126@linuxfoundation.org>
 <20210405085024.812932452@linuxfoundation.org>
 <35560933-d158-76ee-0034-0b5f43d9a3c2@omprussia.ru>
 <YGsTZrlUSYufOk9N@kroah.com>
 <b54f4a70-60df-be44-c88f-1f60f338ff12@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b54f4a70-60df-be44-c88f-1f60f338ff12@omprussia.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 05:11:13PM +0300, Sergey Shtylyov wrote:
>On 4/5/21 4:40 PM, Greg Kroah-Hartman wrote:
>
>[...]
>>>> [ Upstream commit 705e9195187d85249fbb0eaa844b1604a98fbc9a ]
>>>>
>>>> The 'reason' variable in module_sig_check() points to 3 strings across
>>>> the *switch* statement, all needlessly starting with the same text.
>>>> Let's put the starting text into the pr_notice() call -- it saves 21
>>>> bytes of the object code (x86 gcc 10.2.1).
>>>>
>>>> Suggested-by: Joe Perches <joe@perches.com>
>>>> Reviewed-by: Miroslav Benes <mbenes@suse.cz>
>>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>>> Signed-off-by: Jessica Yu <jeyu@kernel.org>
>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>> ---
>>>>  kernel/module.c | 9 +++++----
>>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/kernel/module.c b/kernel/module.c
>>>> index ab1f97cfe18d..9fe3e9b85348 100644
>>>> --- a/kernel/module.c
>>>> +++ b/kernel/module.c
>>>> @@ -2908,16 +2908,17 @@ static int module_sig_check(struct load_info *info, int flags)
>>>>  		 * enforcing, certain errors are non-fatal.
>>>>  		 */
>>>>  	case -ENODATA:
>>>> -		reason = "Loading of unsigned module";
>>>> +		reason = "unsigned module";
>>>>  		goto decide;
>>>>  	case -ENOPKG:
>>>> -		reason = "Loading of module with unsupported crypto";
>>>> +		reason = "module with unsupported crypto";
>>>>  		goto decide;
>>>>  	case -ENOKEY:
>>>> -		reason = "Loading of module with unavailable key";
>>>> +		reason = "module with unavailable key";
>>>>  	decide:
>>>>  		if (is_module_sig_enforced()) {
>>>> -			pr_notice("%s is rejected\n", reason);
>>>> +			pr_notice("%s: loading of %s is rejected\n",
>>>> +				  info->name, reason);
>>>
>>>    Mhm, in 5.4 there was no printing of 'info->name'...
>>
>> Is that now a problem?
>
>   Looking at 5.4.y, it probably shouldn't be a problem... but I had to go and look. :-)
>   I've found a simple commit that added 'info->name' printing (perhaps should also be
>considered for inclusion?):
>
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e9f35f634e099894f4d6c3b039cd3de5281ee637

Ah yes, looks like I squashed it in by mistake. I'll fix it up in the
queue. Thanks!

-- 
Thanks,
Sasha
