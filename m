Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C964DDC0
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 01:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfFTXYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 19:24:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:60438 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfFTXYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 19:24:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 16:24:54 -0700
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="359116902"
Received: from rchatre-mobl.amr.corp.intel.com (HELO [10.24.14.110]) ([10.24.14.110])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/AES256-SHA; 20 Jun 2019 16:24:54 -0700
Subject: Re: [PATCH] x86/resctrl: Prevent possible overrun during bitmap
 operations
To:     Borislav Petkov <bp@alien8.de>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, tony.luck@intel.com,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com>
 <20190620134429.GD28032@zn.tnic>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <46d134b4-8c13-1485-e0a1-4a165cc9b727@intel.com>
Date:   Thu, 20 Jun 2019 16:24:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190620134429.GD28032@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Borislav,

On 6/20/2019 6:44 AM, Borislav Petkov wrote:
> On Wed, Jun 19, 2019 at 01:27:16PM -0700, Reinette Chatre wrote:
>> @@ -2494,26 +2498,19 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
>>   */
>>  static void cbm_ensure_valid(u32 *_val, struct rdt_resource *r)
>>  {
>> -	/*
>> -	 * Convert the u32 _val to an unsigned long required by all the bit
>> -	 * operations within this function. No more than 32 bits of this
>> -	 * converted value can be accessed because all bit operations are
>> -	 * additionally provided with cbm_len that is initialized during
>> -	 * hardware enumeration using five bits from the EAX register and
>> -	 * thus never can exceed 32 bits.
>> -	 */
>> -	unsigned long *val = (unsigned long *)_val;
>> +	unsigned long val = *_val;
>>  	unsigned int cbm_len = r->cache.cbm_len;
>>  	unsigned long first_bit, zero_bit;
> 
> Please sort function local variables declaration in a reverse christmas
> tree order:
> 
> 	<type A> longest_variable_name;
> 	<type B> shorter_var_name;
> 	<type C> even_shorter;
> 	<type D> i;
> 
>> -	if (*val == 0)
>> +	if (val == 0)
> 
> 	if (!val)
> 
>>  		return;
>>  
>> -	first_bit = find_first_bit(val, cbm_len);
>> -	zero_bit = find_next_zero_bit(val, cbm_len, first_bit);
>> +	first_bit = find_first_bit(&val, cbm_len);
>> +	zero_bit = find_next_zero_bit(&val, cbm_len, first_bit);
>>  
>>  	/* Clear any remaining bits to ensure contiguous region */
>> -	bitmap_clear(val, zero_bit, cbm_len - zero_bit);
>> +	bitmap_clear(&val, zero_bit, cbm_len - zero_bit);
>> +	*_val = (u32)val;
> 
> ... and also, that function should simply return the u32 value instead
> of using @_val as an input and output var.
> 
> But that should be a separate cleanup patch anyway.

Thank you very much. I will provide that separate cleanup patch.

Reinette

