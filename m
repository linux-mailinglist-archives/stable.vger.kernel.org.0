Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F6135429F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 16:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbhDEOLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 10:11:22 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:46566 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235763AbhDEOLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 10:11:22 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru B65C4233D681
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 5.4 03/74] module: merge repetitive strings in
 module_sig_check()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Miroslav Benes <mbenes@suse.cz>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20210405085024.703004126@linuxfoundation.org>
 <20210405085024.812932452@linuxfoundation.org>
 <35560933-d158-76ee-0034-0b5f43d9a3c2@omprussia.ru>
 <YGsTZrlUSYufOk9N@kroah.com>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <b54f4a70-60df-be44-c88f-1f60f338ff12@omprussia.ru>
Date:   Mon, 5 Apr 2021 17:11:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YGsTZrlUSYufOk9N@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/21 4:40 PM, Greg Kroah-Hartman wrote:

[...]
>>> [ Upstream commit 705e9195187d85249fbb0eaa844b1604a98fbc9a ]
>>>
>>> The 'reason' variable in module_sig_check() points to 3 strings across
>>> the *switch* statement, all needlessly starting with the same text.
>>> Let's put the starting text into the pr_notice() call -- it saves 21
>>> bytes of the object code (x86 gcc 10.2.1).
>>>
>>> Suggested-by: Joe Perches <joe@perches.com>
>>> Reviewed-by: Miroslav Benes <mbenes@suse.cz>
>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>> Signed-off-by: Jessica Yu <jeyu@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  kernel/module.c | 9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/module.c b/kernel/module.c
>>> index ab1f97cfe18d..9fe3e9b85348 100644
>>> --- a/kernel/module.c
>>> +++ b/kernel/module.c
>>> @@ -2908,16 +2908,17 @@ static int module_sig_check(struct load_info *info, int flags)
>>>  		 * enforcing, certain errors are non-fatal.
>>>  		 */
>>>  	case -ENODATA:
>>> -		reason = "Loading of unsigned module";
>>> +		reason = "unsigned module";
>>>  		goto decide;
>>>  	case -ENOPKG:
>>> -		reason = "Loading of module with unsupported crypto";
>>> +		reason = "module with unsupported crypto";
>>>  		goto decide;
>>>  	case -ENOKEY:
>>> -		reason = "Loading of module with unavailable key";
>>> +		reason = "module with unavailable key";
>>>  	decide:
>>>  		if (is_module_sig_enforced()) {
>>> -			pr_notice("%s is rejected\n", reason);
>>> +			pr_notice("%s: loading of %s is rejected\n",
>>> +				  info->name, reason);
>>
>>    Mhm, in 5.4 there was no printing of 'info->name'...
> 
> Is that now a problem?

   Looking at 5.4.y, it probably shouldn't be a problem... but I had to go and look. :-)
   I've found a simple commit that added 'info->name' printing (perhaps should also be
considered for inclusion?):

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e9f35f634e099894f4d6c3b039cd3de5281ee637


> thanks,
> 
> greg k-h

MBR, Sergey
