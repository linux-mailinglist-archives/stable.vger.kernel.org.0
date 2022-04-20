Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522F9507FBD
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 06:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiDTEHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 00:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiDTEHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 00:07:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FA333EA2;
        Tue, 19 Apr 2022 21:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C063B81CFA;
        Wed, 20 Apr 2022 04:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A66C385A1;
        Wed, 20 Apr 2022 04:04:22 +0000 (UTC)
Message-ID: <81788b56-5b15-7308-38c7-c7f2502c4e15@linux-m68k.org>
Date:   Wed, 20 Apr 2022 14:04:19 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Mike Frysinger <vapier@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com>
 <Yli8voX7hw3EZ7E/@x1-carbon>
From:   Greg Ungerer <gerg@linux-m68k.org>
In-Reply-To: <Yli8voX7hw3EZ7E/@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/4/22 10:30, Niklas Cassel wrote:
> On Fri, Apr 15, 2022 at 08:51:27AM +0900, Damien Le Moal wrote:
>> On 4/14/22 18:10, Niklas Cassel wrote:
> 
> (snip)
> 
>> This looks good to me. But thinking more about it, do we really need to
>> check what the content of the header is ? Why not simply replace this
>> entire hunk with:
>>
>> 		return rp + sizeof(unsigned long) * 2;
>>
>> to ignore the 16B (or 8B for 32-bits arch) header regardless of what the
>> header word values are ? Are there any case where the header is *not*
>> present ?
> 
> Considering that I haven't been able to find any real specification that
> describes the bFLT format. (No, the elf2flt source is no specification.)
> This whole format seems kind of fragile.
> 
> I realize that checking the first one or two entries after data start is
> not the most robust thing, but I still prefer it over skipping blindly.
> 
> Especially considering that only m68k seems to support shared libraries
> with bFLT. So even while this header is reserved for ld.so, it will most
> likely only be used on m68k bFLT binaries.. so perhaps elf2flt some day
> decides to strip away this header on all bFLT binaries except for m68k?

FWIW there has been talk for a couple of years now to remove the
shared library support for m68k. It doesn't get used - probably not
for a very long time now. And most likely doesn't even work anymore.

Regards
Greg



> bFLT seems to currently be at version 4, perhaps such a change would
> require a version bump.. Or not? (Now, if there only was a spec.. :P)
> 
> 
> Kind regards,
> Niklas
> 
>>
>>> +	}
>>> +	return rp;
>>> +}
>>> +
>>>   static int load_flat_file(struct linux_binprm *bprm,
>>>   		struct lib_info *libinfo, int id, unsigned long *extra_stack)
>>>   {
>>> @@ -789,7 +813,8 @@ static int load_flat_file(struct linux_binprm *bprm,
>>>   	 * image.
>>>   	 */
>>>   	if (flags & FLAT_FLAG_GOTPIC) {
>>> -		for (rp = (u32 __user *)datapos; ; rp++) {
>>> +		rp = skip_got_header((u32 * __user) datapos);
>>> +		for (; ; rp++) {
>>>   			u32 addr, rp_val;
>>>   			if (get_user(rp_val, rp))
>>>   				return -EFAULT;
>>
>> Regardless of the above nit, feel free to add:
>>
>> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>
>>
>> -- 
>> Damien Le Moal
>> Western Digital Research
