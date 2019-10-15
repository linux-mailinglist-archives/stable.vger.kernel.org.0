Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5206D7F1A
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 20:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389125AbfJOSe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 14:34:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfJOSe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 14:34:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FITFtR114611;
        Tue, 15 Oct 2019 18:34:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MThrjEj9/0CfZX70Z4dae2R2GHQaF5mGxzVKKwafNro=;
 b=k3yULwCrhXn2/tiQpMANbqF6M6IqBOKsfV+H147L2s4bg3mB2I3D1rupHUL+PCojwhfV
 zYiI38rrr6tPstl18nIrQN3Cork5o/jnxN1NHWHWCEpgA9UUULiGteD76XKh4fhI7+K0
 ufhFk7GVeviH4c/2C5mRLUxFtNLWcOrUoQIENDumC90buIjPhEnbQKeetpS5UFuf7COs
 kuAkQrWsX4BeOfEui/bwEFoLBDgNRXWLoEwyk/If/BSwIM1bY98BXmRKwsXf04SNuTEc
 Rj7992wuaQ4TgoC9a9YLn5S46bTKGl6136qjweWfl1YQKMRXmwz6eriuNECTEd/878hm 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vk6sqj27q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 18:34:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FISeTN039074;
        Tue, 15 Oct 2019 18:34:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vn8enqj4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 18:34:16 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9FIYFPU031925;
        Tue, 15 Oct 2019 18:34:15 GMT
Received: from [192.168.1.222] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 18:34:14 +0000
Subject: Re: [PATCH v1] hugetlbfs: don't access uninitialized memmaps in
 pfn_range_valid_gigantic()
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>,
        stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20191015120717.4858-1-david@redhat.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <8ac821b6-7575-ab0d-1336-c376a30b8fbb@oracle.com>
Date:   Tue, 15 Oct 2019 11:34:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191015120717.4858-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150157
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/15/19 5:07 AM, David Hildenbrand wrote:
> Uninitialized memmaps contain garbage and in the worst case trigger
> kernel BUGs, especially with CONFIG_PAGE_POISONING. They should not get
> touched.
> 
> Let's make sure that we only consider online memory (managed by the
> buddy) that has initialized memmaps. ZONE_DEVICE is not applicable.
> 
> page_zone() will call page_to_nid(), which will trigger
> VM_BUG_ON_PGFLAGS(PagePoisoned(page), page) with CONFIG_PAGE_POISONING
> and CONFIG_DEBUG_VM_PGFLAGS when called on uninitialized memmaps. This
> can be the case when an offline memory block (e.g., never onlined) is
> spanned by a zone.
> 
> Note: As explained by Michal in [1], alloc_contig_range() will verify
> the range. So it boils down to the wrong access in this function.
> 
> [1] http://lkml.kernel.org/r/20180423000943.GO17484@dhcp22.suse.cz
> 
> Reported-by: Michal Hocko <mhocko@kernel.org>
> Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online") # visible after d0dc12e86b319
> Cc: stable@vger.kernel.org # v4.13+
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Thanks David,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz
