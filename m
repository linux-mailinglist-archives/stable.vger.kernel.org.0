Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42580589B06
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 13:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiHDL00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 07:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiHDL00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 07:26:26 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961351CFD3;
        Thu,  4 Aug 2022 04:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1659612377;
        bh=WK9JuR0DnpdEn/f7WcmaylbPNVOYgrWpb25CNtsiAXQ=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=O+qbh3N/yJU1bpPWS8Twp/QJyGjUMcZzYjs+INbcVqEkZBL0YLS7pwbb0/+ED6f2p
         QnUUIoLuXIcx1tuSqTMhm29lWsfp69Q2Slvb1YTZFn8TZX32uPfjV+UUuKKVvnmRZ0
         HcuO1d91VeZctgjC/69CRBoQgLrWih3zBgV92RTQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MVN6j-1ntTP40K8d-00SP4k; Thu, 04
 Aug 2022 13:26:17 +0200
Message-ID: <df125230-2ee7-7b55-815e-d209bbdbcb1b@gmx.com>
Date:   Thu, 4 Aug 2022 19:26:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Wang Yugui <wangyugui@e16-tech.com>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1659596446.git.wqu@suse.com>
 <20220804182554.303B.409509F4@e16-tech.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH STABLE 5.10 5.15 0/2] btrfs: raid56 backports to reduce
 destructive RMW
In-Reply-To: <20220804182554.303B.409509F4@e16-tech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OpisowDTVzeqoVfrK3/Fyd8TFytLzNso69EmoGMkMZ9iOpyDgs/
 HzCDoeDDFZqVt+q8sXpgZmtzhUgIFZSDFfF7oiZbmwa1POUWO8fMY71Xzddzwn4jrsJzjF1
 +5ZtKIO09KIaTpyiI4Odu8r7HbI9Oh2C5/+RsyO2Yawnmy2Zy29S8wOjamPS3BlujnEb1SJ
 c54x594Qc0DG+DdaieeKw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:IhuBEPOCnbE=:f9D+aLidTvqWl9JzceD3e9
 uYhfxbKkyT/Nyl/WrMIWxpSwN2UGPXZYDiSPs32MmSoLYh2a6e/ES1JQshu6MqFSN5oKfm7w5
 RAulghGCuwZTxs/q+SscthRrOFLUtQxf0q48QYKmFxodeATwsykRqsg4N/ExQr7XURzf4xC/R
 16Q2lbRYFIpM2XXiUyup7L/Bj7g4yGselj7i0xPrx0SiyqbESBDB+sfNWpVlyDWru6XOPI3gN
 uUGbJyIzgKAKkLhiroxpPHLA/cguJxQ+XucqYtOa/Gj16g4V6+u5elFuj+dxG1LZqFaBQZ+kM
 ipyThLQQnWhkNZj59oSu1YxoFhufQ/ujC305kzK+6gPjdeUynbRMhzXZY76qUiIc+9AqqHsnz
 ae3uWnZ2owyy036FaQP2v3TEOysaAE8EmjyKZA2pDAviK6N5Q2Amgx2FJHLtZ/DOEbSYYDHWj
 5mXfS73KY3gwabb7ilRnj9UsJHNQlRF9Rk0P+sDXa9ZOg9jc+tQEQ8yNVBENqaDjsHqvgPU4j
 fFDQjwof9HQzCG0mVKnIrAdXAZJ2dCAeG8q9ug3jIYrfCCgEOSkbBGQYKdPAEEV+Zcvqzu5KE
 96YoYmt1tYQT+BYMBn+CWhNfNNF1aRaKkz/Tbj0zpr2WUus3ysxas1GQ2r9Mopd9EW5vWvl+p
 SI1/jeapAHcSNe7bbonOqxoJmHxMASTOzn5Wj59cWCLZr26Y6e8XI+qdb/Ji8zTgrG/OES4ZO
 kfS1Zeasqff2Ytmb+gFL7vOmn3ld6HYN2Ac9sVxxT352JjFsVCB1LBvPqxUOi94oTqfcqZn2w
 jwntGyfwh2kMdbjXr9HU+DY/OADHii1wCwNYyMSYTbjLWBEKSRemIpR5HPS5XSGrehnLUmTwr
 6iIot1VDjE2zQ++jabYHnIjvUQj/NeKJyifzD7Hlfr9DwJbWY4zGB5YvEolNmrr/Rbs817lf6
 CINM084rBL6pv9vx1f3YnZS3JakA2ytxV56H3d9Ye2+N+jnCtb4FIlPE3Mf8mhRO+/HnQ3xFV
 UePNiwc400U6cpexvQznLJffN6z6HugL8GyIC/cdqASf9c6oC6gNvzAL2AjmCiicSWBYUh5LW
 CrUIzv7TQ1djl05KF5CYRdX/Gfzn+1JEZJrKWchCZ7pEYNW0p529g+zrA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/4 18:25, Wang Yugui wrote:
> Hi,
>
> xfstest btrfs/158 trigged a panic after these 2 patches are applied.
>
> btrfs-158-dmesg.txt
> 	dmesg output when panic
> btrfs-158-dmesg-decoded.txt
> 	dmesg output decoded by decode_stacktrace.sh
> 	and some source code is added too.
>
> reproduce rate:
> 	not 100%, but 2 times here.
>
> xfstest  './check -g scrub' seem higher rate  than
> './check test/btrfs/158' to reproduce this problem .

Also reproduced here running that in a loop.

>
> linux kernel: 5.15.59 with some local backport patches too.

Got the reason pinned down, missing one dependency.

The code triggering the crash is "const u32 sectorsize =3D
fs_info->sectorsize", and @fs_info is from bioc.

But bioc initialization doesn't ensure every bioc has its fs_info
initialized.

That is only ensured by commit 731ccf15c952 ("btrfs: make sure
btrfs_io_context::fs_info is always initialized").

So I have also need to backport that patch.

Weirdly, I ran my tests with "-g raid -g replace -g scrub" but didn't
trigger this on even older branches.

I'll do more tests to make sure it doesn't cause problems.

Thanks,
Qu


>
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2022/08/04
>
>> Hi Greg and Sasha,
>>
>> This two patches are backports for v5.15 and v5.10 (for v5.10 conflicts
>> can be auto resolved) stable branches.
>>
>> (For older branches from v4.9 to v5.4, due to some naming change,
>> although the patches can be applied with auto-resolve, they won't compi=
le).
>>
>> These two patches are reducing the chance of destructive RMW cycle,
>> where btrfs can use corrupted data to generate new P/Q, thus making som=
e
>> repairable data unrepairable.
>>
>> Those patches are more important than what I initially thought, thus
>> unfortunately they are not CCed to stable by themselves.
>>
>> Furthermore due to recent refactors/renames, there are quite some membe=
r
>> change related to those patches, thus have to be manually backported.
>>
>>
>> One of the fastest way to verify the behavior is the existing btrfs/125
>> test case from fstests. (not in auto group AFAIK).
>>
>> Qu Wenruo (2):
>>    btrfs: only write the sectors in the vertical stripe which has data
>>      stripes
>>    btrfs: raid56: don't trust any cached sector in
>>      __raid56_parity_recover()
>>
>>   fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++----------=
-
>>   1 file changed, 57 insertions(+), 17 deletions(-)
>>
>> --
>> 2.37.0
>
