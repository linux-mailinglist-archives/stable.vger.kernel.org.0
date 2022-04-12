Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942FA4FEA9E
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiDLXpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiDLXpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:45:31 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C0FD65;
        Tue, 12 Apr 2022 16:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649806366;
        bh=ocx9dbxHYl/RSl3Ky4lnC9XLEZrtGjLWElYgtT7bOqQ=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=PTGricf0c2h7byw6PhErKIhV9L2VO+9piUxmh8spH0sn7hAxKM+7cQagw4ZqjkmrA
         XPmVSW36ski0gmN5JxIpq3YgTeUbhUpRZZLNBHZUESxvApRoGQRJclmoPiuU+KIwo2
         /SE81hu9umBR6LLOsXYB1RzguswviF+YosdkUPY8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mo6qv-1oK7oE22eJ-00pcCJ; Wed, 13
 Apr 2022 01:32:46 +0200
Message-ID: <447a2d76-dfff-9efb-09e8-9778ac4a44f2@gmx.com>
Date:   Wed, 13 Apr 2022 07:32:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when submit_one_bio()
 failed
Content-Language: en-US
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
 <20220412204104.GA15609@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220412204104.GA15609@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:d7JhIzIOEhggklzwnHg1+cpmi0y82YUS+eWP7GMHsMTE3hl5qFh
 DPbm7wiiRgih2Io/2ZdJ5wl5zdj4NKdjBsSed1jpWfB5ba9KyvQSAhG5cW+5fhZObTklL2y
 fYNpnUgJeFiO25e3KnrM+ZuVewSjJOnFmsQB/wpGLsPTIBHebJDKng1MS6GG1t7qEHnx64L
 OROxeIVK1z3Jsmin2ceOw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5k8dHvyFXIA=:boLlsKt3RgIjFhVDf3wMBM
 vtbFgy5VSxSpliwM2Y3YAhCtsImDGH8h1JefuUI08OQ55AYY2adCSy6SJ2xtMJNz5UXsrODrJ
 pHS8/x/Fn+SLax96DiPorQRCJ5E5EdglBMXvA5JYS+L+HV/TRjtLfPe1URfA7SwE717blUQuj
 02CYRlbs6v6vkLWKBDrqGVZiALYOEijRLaQ9roZOMFD81cnXs3QWJIhuBpR5Gf0iXtIZbmGvu
 NWVRTqJMdTAOAr/MagVZdCkyHCGhxk1WDWOgXB7VnBcMVICQEHk8oLwYPh0tB8ocpX7iFEQtK
 DvOGebiUkjp3dqlsXGhhjm6Pq8pl/pXLXJedqfDTYVBEjhxEVA/cq6FjvXT9tqWNiaqWpysMy
 ifJnSd8PfUusUWXHoSI0gX140HtATHbugwN2Sl7pJAxNUzSGXM9yTQD4CtjW4fc/QUnWOVaJi
 vzUaCec7wwe8mAkP0DUivHMrIcoUn0IzZ35wxXwweIoLqg4CCVEzyiJqYhwuj5cn+oWPl+7YG
 40YGktztQWMcIlwMobhAght0CGZxAYMA+47yiazB/LeSlg8fu5yomabrM2s/YH5NmjjyqagsH
 IbkvnmvQbEVdE7FLrltJnDYmJMWTS8zCMVHVaby6mjKZoqAMPnYxEHHZgV470r+LUxJpUx057
 PXg+Vs3aZvsc/sNalM9WQobqEX6P3peKjjZAkKl5PJJ1LG5hqZtZFief44Rxcb9X0nsmD8y62
 Da7UH4w/xCAZsfu2pWhS9nSQoH68zP8lbzAduRIwLqUzwEI/ZZu3TYJAApt549jxYO6B9gPny
 YAXertKhYTy1wUkhbJkqh7OCRG+mJkgaOPd42qZ4GNGKnP+5VYmx9ps9NNv2+e7/8rsfTtKMR
 /5myUYSlbew1J62YQmsZdMkNLgu+rOI72YNjLFdGo3yozTNayTVBRYoxViaYVho4MJ5aomRx0
 VpDArsA0HE0EKZmudcrcyGufB5QHe9fQv336S3zOHAlFbWj5UOQveIlO8ThwL38ciSNjF+lnh
 OgLODz+EhKGD7WeXsdRV9Au/hSU3v7mBEob6nBCYk07gGsqpZFWszU3a6uP/KeCjX4hh97MeI
 gc7Bk0KKRFUUKk=
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/13 04:41, David Sterba wrote:
> On Tue, Apr 12, 2022 at 08:30:13PM +0800, Qu Wenruo wrote:
>> [BUG]
>> When running generic/475 with 64K page size and 4K sector size, it has =
a
>> very high chance (almost 100%) to hang, with mostly data page locked bu=
t
>> no one is going to unlock it.
>>
>> [CAUSE]
>> With commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
>> reads"), if we failed to lookup checksum due to metadata IO error, we
>> will return error for btrfs_submit_data_bio().
>>
>> This will cause the page to be unlocked twice in btrfs_do_readpage():
>>
>>   btrfs_do_readpage()
>>   |- submit_extent_page()
>>   |  |- submit_one_bio()
>>   |     |- btrfs_submit_data_bio()
>>   |        |- if (ret) {
>>   |        |-     bio->bi_status =3D ret;
>>   |        |-     bio_endio(bio); }
>>   |               In the endio function, we will call end_page_read()
>>   |               and unlock_extent() to cleanup the subpage range.
>>   |
>>   |- if (ret) {
>>   |-        unlock_extent(); end_page_read() }
>>             Here we unlock the extent and cleanup the subpage range
>>             again.
>>
>> For unlock_extent(), it's mostly double unlock safe.
>>
>> But for end_page_read(), it's not, especially for subpage case,
>> as for subpage case we will call btrfs_subpage_end_reader() to reduce
>> the reader number, and use that to number to determine if we need to
>> unlock the full page.
>>
>> If double accounted, it can underflow the number and leave the page
>> locked without anyone to unlock it.
>>
>> [FIX]
>> The commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
>> reads") itself is completely fine, it's our existing code not properly
>> handling the error from bio submission hook properly.
>>
>> This patch will make submit_one_bio() to return void so that the caller=
s
>> will never be able to do cleanup when bio submission hook fails.
>>
>> CC: stable@vger.kernel.org # 5.18+
>
> BTW stable tags are only for released kernels, if it's still in some rc
> then Fixes: is appropriate.

The problem is I don't have a good idea on which commit to be fixed.

Commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
reads") is completely fine by itself.

The problem is there for a long long time, but can only be triggered
with IO errors with that newer commit.

Should we really use that commit? It looks like a scapegoat to me...

Thanks,
Qu
