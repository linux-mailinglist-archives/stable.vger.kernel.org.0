Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175854BB97B
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 13:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiBRMwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 07:52:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbiBRMws (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 07:52:48 -0500
Received: from mgw-02.mpynet.fi (mgw-02.mpynet.fi [82.197.21.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2780B5E76E;
        Fri, 18 Feb 2022 04:52:27 -0800 (PST)
Received: from pps.filterd (mgw-02.mpynet.fi [127.0.0.1])
        by mgw-02.mpynet.fi (8.16.0.43/8.16.0.43) with SMTP id 21ICmFJq033429;
        Fri, 18 Feb 2022 14:52:20 +0200
Received: from ex13.tuxera.com (ex13.tuxera.com [178.16.184.72])
        by mgw-02.mpynet.fi with ESMTP id 3e8hfxsrtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 14:52:20 +0200
Received: from [192.168.0.218] (62.78.240.173) by tuxera-exch.ad.tuxera.com
 (10.20.48.11) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Fri, 18 Feb
 2022 14:52:19 +0200
Message-ID: <51e4f5f6-957b-6df5-0b73-e25bcbc08bb8@tuxera.com>
Date:   Fri, 18 Feb 2022 14:52:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ari Sundholm <ari@tuxera.com>
Subject: Re: [PATCH] fs/read_write.c: Fix a broken signed integer overflow
 check.
CC:     Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <stable@vger.kernel.org>, Anton Altaparmakov <anton@tuxera.com>
References: <20220207120711.4070403-1-ari@tuxera.com>
 <YgEzs2Hp0LrdDmJu@zeniv-ca.linux.org.uk>
 <cd346b72-1899-8f2d-5ff6-65c4ac93308c@tuxera.com>
 <YgFR7mJE17C3LyzP@zeniv-ca.linux.org.uk>
Content-Language: en-US
To:     Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <YgFR7mJE17C3LyzP@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.78.240.173]
X-ClientProxiedBy: tuxera-exch.ad.tuxera.com (10.20.48.11) To
 tuxera-exch.ad.tuxera.com (10.20.48.11)
X-Proofpoint-GUID: PzSMEVRDdRteE2iA4S-x4m3DeWng5ozV
X-Proofpoint-ORIG-GUID: PzSMEVRDdRteE2iA4S-x4m3DeWng5ozV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.816
 definitions=2022-02-18_05:2022-02-17,2022-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=mpy_notspam policy=mpy score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202180082
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 7:07 PM, Al Viro wrote:
> On Mon, Feb 07, 2022 at 06:44:55PM +0200, Ari Sundholm wrote:
>> Hello, Al,
>>
>> On 2/7/22 16:58, Al Viro wrote:
>>> On Mon, Feb 07, 2022 at 02:07:11PM +0200, Ari Sundholm wrote:
>>>> The function generic_copy_file_checks() checks that the ends of the
>>>> input and output file ranges do not overflow. Unfortunately, there is
>>>> an issue with the check itself.
>>>>
>>>> Due to the integer promotion rules in C, the expressions
>>>> (pos_in + count) and (pos_out + count) have an unsigned type because
>>>> the count variable has the type uint64_t. Thus, in many cases where we
>>>> should detect signed integer overflow to have occurred (and thus one or
>>>> more of the ranges being invalid), the expressions will instead be
>>>> interpreted as large unsigned integers. This means the check is broken.
>>>
>>> I must be slow this morning, but... which values of pos_in and count are
>>> caught by your check, but not by the original?
>>>
>>
>> Thank you for your response and questions.
>>
>> Assuming an x86-64 target platform, please consider:
>>
>> loff_t pos_out = 0x7FFFFFFFFFFEFFFFLL;
>> and
>> uint64_t count = 65537;
>>
>> The type of the expression (pos_out + count) is a 64-bit unsigned type, by
>> C's integer promotion rules. Its value is 0x8000000000000000ULL, that is,
>> bit 63 is set.
>>
>> The comparison (pos_out + count) < pos_out, again due to C's integer
>> promotion rules, is unsigned. Thus, the comparison, in this case, is
>> equivalent to:
>>
>> 0x8000000000000000ULL < 0x7FFFFFFFFFFEFFFFULL,
>>
>> which is false. Please note that the LHS is not expressible as a positive
>> integer of type loff_t. With larger values for count, the problem should
>> become quite obvious, as some the offsets within the file would not be
>> expressible as positive integers of type loff_t. But I digress. As we can
>> see above, the overflow is missed.
>>
>> With the LHS explicitly cast to loff_t, the comparison is equivalent to:
>>
>> 0x8000000000000000LL < 0x7FFFFFFFFFFEFFFFLL,
>>
>> which is true, as the LHS is negative.
>>
>> This has also been verified in practice, and was detected when running tests
>> on special cases of the copy_file_range syscall on different filesystems.
> 
> Er...  I still don't see the problem here.  If the destination filesystem
> explicitly allows offsets in excess of 2^63, what's the point in that
> -EOVERFLOW?  And if it doesn't, you'll get count truncated by
> generic_write_check_limits(), down to the amount remaining until the
> fs limit...
> 
> Same on the input side - if your source file is at least 2^63, what's the
> problem?  And if not, you'll get count capped by file size - pos_in, right
> under that check...
> 
Oops. You are of course correct - the patch is broken for files with 
unsigned offsets. This stems from the mistaken assumption that the 
comparison was supposed to be a signed one all along. Regardless, it 
seems an appropriate amount of flagellation is in order for disregarding 
the existence of files with unsigned offsets.

However, my concerns with the behavior of generic_copy_file_checks() are 
not limited to just this line, although just improving the check would 
be a considerable step forward. If I may, I would like to make some 
points to clarify what I find the problems with generic_copy_file_checks().

At the surface level, the comparison in question, be it signed or 
unsigned, should consider and match the signedness of each of the files. 
*Both* the original code and the patch seem wrong to me here. It is also 
remarkable that the far more common case of signed offsets is the one 
not considered here.

As for more fundamental issues, first, the behavior is inconsistent with 
pread64 and pwrite64, for instance. Using the same offset and length as 
those of the out file in the example given, both pread64 and pwrite64 
immediately return -EINVAL, as rw_verify_area(), which performs these 
checks correctly, is called in vfs_read() and vfs_write() *before* 
tampering with the length of the read or write request.

The second fundamental issue is, indeed, the very tampering with the 
length of the copy before properly checking the ranges. Especially so in 
the case of signed offsets. The operation, as a whole, must fail, as the 
requested range within the output file exceeds what can be expressed 
using loff_t. I think it would be wise to follow the lead of 
p{read,write}64 here, and fail early, as the range(s) being invalid is 
independent of any filesystem-specific considerations (apart from the 
offsets being signed). Returning partial success is not very useful, as 
userspace cannot tell anything is wrong, and will call copy_file_range() 
again in an attempt to complete the copy, inevitably forcing an error to 
be returned.

(Basically, what I am trying to argue here that this is *categorically* 
a different case from errors arising from the state of a specific 
volume, such as a write failing due to ENOSPC, or exceeding some limit 
dictated by the environment or filesystem specification. The range(s) 
involved in the operation are simply inexpressible with the datatypes used.)


 > Which filesystems had been involved and what was the test?
 >

To demonstrate the variation in behavior both between copy_file_range 
and p{read,write}64 and different filesystem implementations, I carried 
out a small experiment, where the equivalent of the following sequence 
was run from userspace (pseudocode, most error handling omitted):

	const loff_t orig_pos_in = 0;
	const loff_t orig_pos_out = 0x7FFFFFFFFFFEFFFFLL;
	const size_t orig_length = 65537;
	loff_t pos_in = orig_pos_in;
	loff_t pos_out = orig_pos_out;
	size_t length = orig_length;
	ssize_t ret, written = 0;
	int fd_in = mkstemp(...);
	int fd_out = mkstemp(...);
	const char buf[128k] = { whatever };

	write(fd_in, buf, 128k); /* Magically always succeeds. */

	while (written < orig_length &&
		(ret = copy_file_range(fd_in, &pos_in, fd_out, &pos_out,
		length, 0)) > 0)
	{
		written += ret;
		length -= ret;
	}

	pos_out = orig_pos_out;
	length = orig_length;
	written = 0;
	while (written < orig_length &&
		(ret = pwrite(fd_out, buf, length, pos_out) > 0)
	{
		written += ret;
		pos_out += ret;
		length -= ret;
	}

(The range parameters are shamelessly stolen from xfstests test case 
generic/564.)

Then, the behavior for various filesystems was observed:

btrfs, xfs:
  - copy_file_range is called twice.
  - First copy_file_range copies 65536 bytes. Partial success.
  - Second copy_file_range returns -EFBIG.
  - pwrite is called once, and returns -EINVAL, having written nothing.

exfat, ext{2,3,4}, f2fs, fuse2fs, ntfs3, reiserfs, vfat:
  - copy_file_range is called once, and returns -EFBIG.
  - pwrite is called once, and returns -EINVAL, having written nothing.

hfsplus:
  - copy_file_range is called once, and returns -EINVAL.
  - pwrite is called once, and returns -EINVAL, having written nothing.

Reading the source code of vfs_read() and a few manual test runs show 
that pread64 has similar behavior to pwrite64 when invoked with similar 
parameters.

Unlike in the case of pread64 and pwrite64, the copy range operation 
(after the length was reduced) is allowed to continue on to 
filesystem-specific code, where there is some variation in how the 
operation continues. Remarkably, with the sole exception of hfsplus, the 
end result is the same regardless of whether the filesystem 
implementation and specification support sparse files. Sure, it is 
perfectly POSIX'y to allow the filesystem implementation perform a 
partial write and only return an error on the second call, but the 
difference in behavior with pread64 and pwrite64 is very odd, and seems 
unnecessary.

Please note that, had the experiment been run on files with unsigned 
offsets, and the copy parameters been set in an analogous manner so that 
they cause unsigned overflow, generic_copy_file_checks() would reject 
the operation with -EOVERFLOW. Why is the same not done for signed 
offsets? Why is there a difference with p{read,write}64?

Best regards,
Ari Sundholm
ari@tuxera.com
