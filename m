Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54928119C3E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfLJWTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:19:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfLJWTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 17:19:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAME8aK137834;
        Tue, 10 Dec 2019 22:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=V7NOZM87Hjo3aH85Tq0UMYJwfwxR0GULXsdxgUGpUIg=;
 b=iS3GKONzKGMUa3EaM0O0NhvcAW/iG7hEk43Pi/ciGvg5J2j6uemEbhNIYdyZcCUV6Gnl
 IF1zKbNQ+cW9QoyaOp4Bj+Mh3gv87Zdzbi599PzAXTQ5sCuGtrCSm0CqsZkqAJY/dTF4
 8T01Nh/C9dbkCkqZBAGZMagCMrkjM+TZ/XLAVw+odnDtoKOOLNdTNElSduSGasvTQTXy
 +lIHRrXiRwBTOM6/TG4DajAGjnKLetFKXe4JaygKnhbxSN+TQXvyiO030SMahQgViKsO
 5GOLZcNtEQL5Fyt+uO+L1TIIc8B8GiNiRsksrHXf6bv+U5SoK2igY+vOMjpy3i2Hh7vT Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wrw4n5y9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 22:19:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAMJ8g3075501;
        Tue, 10 Dec 2019 22:19:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wte9asq7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 22:19:29 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBAMI5ZW018162;
        Tue, 10 Dec 2019 22:18:05 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Dec 2019 14:18:04 -0800
Date:   Tue, 10 Dec 2019 17:18:14 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Sistare <steven.sistare@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Bob Picco <bob.picco@oracle.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v1 1/3] mm: fix uninitialized memmaps on a partially
 populated last section
Message-ID: <20191210221814.bdgd4rw55paowhpv@ca-dmjordan1.us.oracle.com>
References: <20191209174836.11063-1-david@redhat.com>
 <20191209174836.11063-2-david@redhat.com>
 <20191209211502.zhbvzv2qwbvcperm@ca-dmjordan1.us.oracle.com>
 <c0733e11-bf06-8813-11de-019cdbddef34@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0733e11-bf06-8813-11de-019cdbddef34@redhat.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100183
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 11:11:03AM +0100, David Hildenbrand wrote:
> Some things that might be relevant from my config.
> 
> # CONFIG_PAGE_POISONING is not set
> CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_MEMORY_HOTPLUG=y
> CONFIG_MEMORY_HOTPLUG_SPARSE=y
> CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y

Thanks for all that.  After some poking around, turns out enabling DEBUG_VM
with its page poisoning let me hit it right away, which makes me wonder how
often someone would see this without it.

Anyway, fix looks good to me.

Tested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
