Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040A12A067F
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 14:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgJ3NdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 09:33:24 -0400
Received: from mgw-02.mpynet.fi ([82.197.21.91]:57544 "EHLO mgw-02.mpynet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgJ3NdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 09:33:23 -0400
Received: from pps.filterd (mgw-02.mpynet.fi [127.0.0.1])
        by mgw-02.mpynet.fi (8.16.0.42/8.16.0.42) with SMTP id 09UDRJwN082960;
        Fri, 30 Oct 2020 15:32:56 +0200
Received: from ex13.tuxera.com (ex13.tuxera.com [178.16.184.72])
        by mgw-02.mpynet.fi with ESMTP id 34c7xwfyab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 15:32:55 +0200
Received: from [192.168.108.50] (194.100.106.190) by tuxera-exch.ad.tuxera.com
 (10.20.48.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Oct
 2020 15:32:55 +0200
Subject: Re: [PATCH 1/4] erofs: fix setting up pcluster for temporary pages
To:     Gao Xiang <hsiangkao@redhat.com>
CC:     <linux-erofs@lists.ozlabs.org>, Gao Xiang <hsiangkao@aol.com>,
        <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20201022145724.27284-1-hsiangkao.ref@aol.com>
 <20201022145724.27284-1-hsiangkao@aol.com>
 <ba952daf-c55d-c251-9dfc-3bf199a2d4ff@tuxera.com>
 <20201030124745.GB133455@xiangao.remote.csb>
From:   Vladimir Zapolskiy <vladimir@tuxera.com>
Message-ID: <02427b81-7854-1d97-662f-ab2d2b868514@tuxera.com>
Date:   Fri, 30 Oct 2020 15:32:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201030124745.GB133455@xiangao.remote.csb>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [194.100.106.190]
X-ClientProxiedBy: tuxera-exch.ad.tuxera.com (10.20.48.11) To
 tuxera-exch.ad.tuxera.com (10.20.48.11)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_04:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=mpy_notspam policy=mpy score=0 mlxlogscore=999 malwarescore=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=2 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300101
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Gao Xiang,

On 10/30/20 2:47 PM, Gao Xiang wrote:
> Hi Vladimir,
> 
> On Fri, Oct 30, 2020 at 02:20:31PM +0200, Vladimir Zapolskiy wrote:
>> Hello Gao Xiang,
>>
>> On 10/22/20 5:57 PM, Gao Xiang via Linux-erofs wrote:
>>> From: Gao Xiang <hsiangkao@redhat.com>
>>>
>>> pcluster should be only set up for all managed pages instead of
>>> temporary pages. Since it currently uses page->mapping to identify,
>>> the impact is minor for now.
>>>
>>> Fixes: 5ddcee1f3a1c ("erofs: get rid of __stagingpage_alloc helper")
>>> Cc: <stable@vger.kernel.org> # 5.5+
>>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
>>
>> I was looking exactly at this problem recently, my change is one-to-one
>> to your fix, thus I can provide a tag:
>>
>> Tested-by: Vladimir Zapolskiy <vladimir@tuxera.com>
> 
> Many thanks for confirming this!
> I found this when I was killing magical stagingpage page->mapping,
> it's somewhat late :-)
> 

sure, for me it was an exciting immersion into the filesystem code :)

>>
>>
>> The fixed problem is minor, but the kernel log becomes polluted, if
>> a page allocation debug option is enabled:
>>
>>      % md5sum ~/erofs/testfile
>>      BUG: Bad page state in process kworker/u9:0  pfn:687de
>>      page:0000000057b8bcb4 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x687de
>>      flags: 0x4000000000002000(private)
>>      raw: 4000000000002000 dead000000000100 dead000000000122 0000000000000000
>>      raw: 0000000000000000 ffff888066758690 00000000ffffffff 0000000000000000
>>      page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
>>      Modules linked in:
>>      CPU: 1 PID: 602 Comm: kworker/u9:0 Not tainted 5.9.1 #2
>>      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
>>      Workqueue: erofs_unzipd z_erofs_decompressqueue_work
>>      Call Trace:
>>       dump_stack+0x84/0xba
>>       bad_page.cold+0xac/0xb1
>>       check_free_page_bad+0xb0/0xc0
>>       free_pcp_prepare+0x2c8/0x2d0
>>       free_unref_page+0x18/0xf0
>>       put_pages_list+0x11a/0x120
>>       z_erofs_decompressqueue_work+0xc9/0x110
>>       ? z_erofs_decompress_pcluster.isra.0+0xf10/0xf10
>>       ? read_word_at_a_time+0x12/0x20
>>       ? strscpy+0xc7/0x1a0
>>       process_one_work+0x30c/0x730
>>       worker_thread+0x91/0x640
>>       ? __kasan_check_read+0x11/0x20
>>       ? rescuer_thread+0x8a0/0x8a0
>>       kthread+0x1dd/0x200
>>       ? kthread_unpark+0xa0/0xa0
>>       ret_from_fork+0x1f/0x30
>>      Disabling lock debugging due to kernel taint
> 
> Yeah, I can make a pull-request to Linus if you need this to be in master
> now, or I can post it for v5.11-rc1 since 5.4 LTS isn't effected (and it
> would be only a print problem with debugging option.)
> 

As for myself I don't utterly need this fix on the master branch ASAP, however
it might be reasonable to get it included right into the next v5.10 release,
because I believe it'll be an LTS. Eventually it's up to you to make a decision,
from my side I won't urge you, the fixed issue is obviously a non-critical one.

Thank you for the original fix and taking my opinion into consideration :)

--
Best wishes,
Vladimir
