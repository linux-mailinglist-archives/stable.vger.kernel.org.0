Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941B64AC697
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 18:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbiBGQ7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 11:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386797AbiBGQpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 11:45:08 -0500
Received: from mgw-02.mpynet.fi (mgw-02.mpynet.fi [82.197.21.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BF7C0401DD;
        Mon,  7 Feb 2022 08:45:05 -0800 (PST)
Received: from pps.filterd (mgw-02.mpynet.fi [127.0.0.1])
        by mgw-02.mpynet.fi (8.16.0.43/8.16.0.43) with SMTP id 217GeCDA090121;
        Mon, 7 Feb 2022 18:44:58 +0200
Received: from ex13.tuxera.com (ex13.tuxera.com [178.16.184.72])
        by mgw-02.mpynet.fi with ESMTP id 3e1dtn18jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 18:44:58 +0200
Received: from [192.168.0.129] (62.78.240.173) by tuxera-exch.ad.tuxera.com
 (10.20.48.11) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Mon, 7 Feb
 2022 18:44:57 +0200
Message-ID: <cd346b72-1899-8f2d-5ff6-65c4ac93308c@tuxera.com>
Date:   Mon, 7 Feb 2022 18:44:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] fs/read_write.c: Fix a broken signed integer overflow
 check.
Content-Language: en-US
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <stable@vger.kernel.org>, Anton Altaparmakov <anton@tuxera.com>
References: <20220207120711.4070403-1-ari@tuxera.com>
 <YgEzs2Hp0LrdDmJu@zeniv-ca.linux.org.uk>
From:   Ari Sundholm <ari@tuxera.com>
In-Reply-To: <YgEzs2Hp0LrdDmJu@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.78.240.173]
X-ClientProxiedBy: tuxera-exch.ad.tuxera.com (10.20.48.11) To
 tuxera-exch.ad.tuxera.com (10.20.48.11)
X-Proofpoint-GUID: Da0sQN7Knu4Px4pte8UxgNfRYtot2MB1
X-Proofpoint-ORIG-GUID: Da0sQN7Knu4Px4pte8UxgNfRYtot2MB1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.816
 definitions=2022-02-07_06:2022-02-07,2022-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=mpy_notspam policy=mpy score=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070103
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Al,

On 2/7/22 16:58, Al Viro wrote:
> On Mon, Feb 07, 2022 at 02:07:11PM +0200, Ari Sundholm wrote:
>> The function generic_copy_file_checks() checks that the ends of the
>> input and output file ranges do not overflow. Unfortunately, there is
>> an issue with the check itself.
>>
>> Due to the integer promotion rules in C, the expressions
>> (pos_in + count) and (pos_out + count) have an unsigned type because
>> the count variable has the type uint64_t. Thus, in many cases where we
>> should detect signed integer overflow to have occurred (and thus one or
>> more of the ranges being invalid), the expressions will instead be
>> interpreted as large unsigned integers. This means the check is broken.
> 
> I must be slow this morning, but... which values of pos_in and count are
> caught by your check, but not by the original?
> 

Thank you for your response and questions.

Assuming an x86-64 target platform, please consider:

loff_t pos_out = 0x7FFFFFFFFFFEFFFFLL;
and
uint64_t count = 65537;

The type of the expression (pos_out + count) is a 64-bit unsigned type, 
by C's integer promotion rules. Its value is 0x8000000000000000ULL, that 
is, bit 63 is set.

The comparison (pos_out + count) < pos_out, again due to C's integer 
promotion rules, is unsigned. Thus, the comparison, in this case, is 
equivalent to:

0x8000000000000000ULL < 0x7FFFFFFFFFFEFFFFULL,

which is false. Please note that the LHS is not expressible as a 
positive integer of type loff_t. With larger values for count, the 
problem should become quite obvious, as some the offsets within the file 
would not be expressible as positive integers of type loff_t. But I 
digress. As we can see above, the overflow is missed.

With the LHS explicitly cast to loff_t, the comparison is equivalent to:

0x8000000000000000LL < 0x7FFFFFFFFFFEFFFFLL,

which is true, as the LHS is negative.

This has also been verified in practice, and was detected when running 
tests on special cases of the copy_file_range syscall on different 
filesystems.

>> -	if (pos_in + count < pos_in || pos_out + count < pos_out)
>> +	if ((loff_t)(pos_in + count) < pos_in ||
>> +			(loff_t)(pos_out + count) < pos_out)
> 
> Example, please.  Why do you need that comparison to be signed?

Please see the above.

I also created a small test program one can try on Compiler Explorer: 
https://godbolt.org/z/e76rb3Ec9

Please let me know if there are any further concerns.

Best regards,
Ari Sundholm
ari@tuxera.com
