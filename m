Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A544117823
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 22:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfLIVPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 16:15:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLIVPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 16:15:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9LEHH3096116;
        Mon, 9 Dec 2019 21:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hv9HeQxEfDzHfPEsiur0m3wLUKoOIe5Nkd8kAnU/XqM=;
 b=dSwgz0pG2lWSd6quJcho2IBvDFhhMqDU7Fi/t+sFaWy/8V8P7vvCzIPnOGfrJLijwSZe
 rrX2RMCazVBEKOBABK9oZUPD8r+R34oD6Jmug5R+pGLA0l7SUj32RFt54M+wKhqRQE3w
 zNo+z+x0LQLs1qtscirqVCAaJ29gpJ4AkMcopYaFlZJF2Ys3XFKG/XgHXuWleAkclvWk
 UIjIFQmMBUFBMzOjfVutzXPgLreTYGiSEoHgLjEyzbKiG8oGs/Gbnb8osBpdvAqaMvkt
 yZlU2ibcWyQ2ion3qQd3ocH+3Eq6V9nS4eD5Ic8yQoLFUajWtkGeho1dJr5AuaoinsjU hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wr4qra58j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 21:14:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9LDWoY103614;
        Mon, 9 Dec 2019 21:14:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wsw6fsy30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 21:14:57 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB9LEt8I020620;
        Mon, 9 Dec 2019 21:14:55 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 13:14:54 -0800
Date:   Mon, 9 Dec 2019 16:15:02 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Sistare <steven.sistare@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Bob Picco <bob.picco@oracle.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v1 1/3] mm: fix uninitialized memmaps on a partially
 populated last section
Message-ID: <20191209211502.zhbvzv2qwbvcperm@ca-dmjordan1.us.oracle.com>
References: <20191209174836.11063-1-david@redhat.com>
 <20191209174836.11063-2-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209174836.11063-2-david@redhat.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=556
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=609 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090167
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On Mon, Dec 09, 2019 at 06:48:34PM +0100, David Hildenbrand wrote:
> If max_pfn is not aligned to a section boundary, we can easily run into
> BUGs. This can e.g., be triggered on x86-64 under QEMU by specifying a
> memory size that is not a multiple of 128MB (e.g., 4097MB, but also
> 4160MB). I was told that on real HW, we can easily have this scenario
> (esp., one of the main reasons sub-section hotadd of devmem was added).
> 
> The issue is, that we have a valid memmap (pfn_valid()) for the
> whole section, and the whole section will be marked "online".
> pfn_to_online_page() will succeed, but the memmap contains garbage.
> 
> E.g., doing a "cat /proc/kpageflags > /dev/null" results in
> 
> [  303.218313] BUG: unable to handle page fault for address: fffffffffffffffe
> [  303.218899] #PF: supervisor read access in kernel mode
> [  303.219344] #PF: error_code(0x0000) - not-present page
> [  303.219787] PGD 12614067 P4D 12614067 PUD 12616067 PMD 0
> [  303.220266] Oops: 0000 [#1] SMP NOPTI
> [  303.220587] CPU: 0 PID: 424 Comm: cat Not tainted 5.4.0-next-20191128+ #17

I can't reproduce this on x86-64 qemu, next-20191128 or mainline, with either
memory size.  What config are you using?  How often are you hitting it?

It may not have anything to do with the config, and I may be getting lucky with
the garbage in my memory.
