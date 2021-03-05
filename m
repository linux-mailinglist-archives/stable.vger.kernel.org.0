Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB6732F080
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCERBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:01:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229573AbhCERBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:01:11 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125GX0MG005830;
        Fri, 5 Mar 2021 12:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ja40FQIv5e2vkmFlsLDSDU8/jkakWKsrFjjZV7N+kjA=;
 b=revsDj5pHP6wnUfOYmesxOYEfzb3sxeomnhM8WrK9WEzfwb5Gtr9zkrttWkKZOEFIKJL
 plM7ZPdQbUT/8RgYtAVznPN1c/nSE+E0ZRxrzOyDL7unqME8EubpNjnT8YmjsqB3nyEN
 IaviXuHngccXQ3kHJOXH9jlUkBLlXXOoTFW6gFVE+/BkSTXA+w2EwygwaZEOPOQf165/
 RTJyTTyyEX3sshfjVgForItKYBbNxSq04kSzaGiRL3KlXAMI4hcFJUMNJAaChiVvhAPe
 +ktRHDE5yy1psqlxu5MjjOR98WM0AGPqgYci8LDujRHqGqghI4POuwUTw8P8jYzGjNuT JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 373r17h7pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 12:01:08 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 125GXEJh008148;
        Fri, 5 Mar 2021 12:01:08 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 373r17h7ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 12:01:08 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 125GxHmf004479;
        Fri, 5 Mar 2021 17:01:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 37150ct06g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 17:01:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 125H0nAh30212486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Mar 2021 17:00:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 880DE42045;
        Fri,  5 Mar 2021 17:01:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 166074204C;
        Fri,  5 Mar 2021 17:01:03 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.57.80])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Mar 2021 17:01:03 +0000 (GMT)
Subject: Re: [PATCH v5 2/3] s390/kvm: extend kvm_s390_shadow_fault to return
 entry pointer
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org, Janosch Frank <frankja@de.ibm.com>
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
 <20210302174443.514363-3-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <5b3af39c-d141-c51d-156a-a2ed0f9396ee@de.ibm.com>
Date:   Fri, 5 Mar 2021 18:01:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302174443.514363-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_10:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 adultscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103050083
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 02.03.21 18:44, Claudio Imbrenda wrote:
> Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
> DAT table entry, or to the invalid entry.
> 
> Also return some flags in the lower bits of the address:
> PEI_DAT_PROT: indicates that DAT protection applies because of the
>                protection bit in the segment (or, if EDAT, region) tables.
> PEI_NOT_PTE: indicates that the address of the DAT table entry returned
>               does not refer to a PTE, but to a segment or region table.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Janosch Frank <frankja@de.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
