Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797D829D564
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgJ1WAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:00:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32118 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729440AbgJ1WAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:00:34 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SDY1lC111372;
        Wed, 28 Oct 2020 09:49:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IDQmMwvqE3BIPtsJjL2PtnQ5y0GM7gcvLr6wNoeY+yc=;
 b=Fajcbce/dcGtAMEBjYmqxgxu14eU1G/hk8K8pFezScUhDB5R3sCn5936edEkcN1szk+n
 TLhWPvA7dY5+KPbNs28byecSryku0RiTfUA0bkolM1LUwSK0fY8SvPs0A2+3Cw8k0wVo
 VLqU9wm2aFcIIYwLR2AugCabWSfM4zGqznu8+JWkdj9rambEPsaowXkfzCEO1HUZJzNj
 KJ3Ca8QVihGcGixzvDxnHBJEODPEToB52l2/KjViULy3Xmhv4d4JoLaPLiTjgacAc53B
 MrfcizYYOpcnl9ENM+5wL8d88XrmqVB6zQwlHLRpMF8rAfV/dGQKAQBMtr7pMKZauOjy zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34d97hp094-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 09:49:51 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09SDYqfb115286;
        Wed, 28 Oct 2020 09:49:51 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34d97hp08f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 09:49:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SDmYRQ019172;
        Wed, 28 Oct 2020 13:49:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 34e56qsxaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 13:49:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SDnkJk30671350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 13:49:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEA1511C050;
        Wed, 28 Oct 2020 13:49:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74E0611C04A;
        Wed, 28 Oct 2020 13:49:45 +0000 (GMT)
Received: from pomme.local (unknown [9.145.78.110])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Oct 2020 13:49:45 +0000 (GMT)
Subject: Re: [PATCH v2] mm/slub: fix panic in slab_alloc_node()
To:     Christopher Lameter <cl@linux.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com, mhocko@suse.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <7ef64e75-2150-01a9-074d-a754348683b3@suse.cz>
 <20201027190406.33283-1-ldufour@linux.ibm.com>
 <alpine.DEB.2.22.394.2010281109580.1521@www.lameter.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <73aa614f-24e6-75d5-8173-d858a5b33fec@linux.ibm.com>
Date:   Wed, 28 Oct 2020 14:49:45 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2010281109580.1521@www.lameter.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_06:2020-10-26,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=952
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010280088
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 28/10/2020 à 12:11, Christopher Lameter a écrit :
> On Tue, 27 Oct 2020, Laurent Dufour wrote:
> 
>> The issue is that object is not NULL while page is NULL which is odd but
>> may happen if the cache flush happened after loading object but before
>> loading page. Thus checking for the page pointer is required too.
> 
> 
> Ok then lets revert commit  6159d0f5c03e? The situation may occur
> elsewhere too.

The only other call to node_match() is in ___slab_alloc(), and the page pointer 
is already checked there.
So there is no real need to check it in node_match().
