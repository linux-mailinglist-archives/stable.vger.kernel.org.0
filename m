Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0482FD47D
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 06:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfKOFnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 00:43:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbfKOFnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 00:43:13 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF5dBW2104159
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 00:43:12 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9nsm1520-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 00:43:12 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ajd@linux.ibm.com>;
        Fri, 15 Nov 2019 05:43:10 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 05:43:08 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAF5h7h157934074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 05:43:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AE8342049;
        Fri, 15 Nov 2019 05:43:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38C2A4204C;
        Fri, 15 Nov 2019 05:43:07 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 05:43:07 +0000 (GMT)
Received: from [9.102.34.42] (unknown [9.102.34.42])
        (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id A2D53A00EC;
        Fri, 15 Nov 2019 16:43:04 +1100 (AEDT)
Subject: Re: [4.14] Backport request: powerpc/perf: Fix IMC_MAX_PMU macro
From:   Andrew Donnellan <ajd@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>
References: <607891ba-9a95-fe0c-6185-2cb2406870f3@linux.ibm.com>
Date:   Fri, 15 Nov 2019 16:43:05 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <607891ba-9a95-fe0c-6185-2cb2406870f3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19111505-0012-0000-0000-00000363C8F0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111505-0013-0000-0000-0000219F44F1
Message-Id: <024b2b46-d802-5d1c-2f52-0fe12d93f6c5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_07:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=795 suspectscore=1 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150050
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/11/19 4:37 pm, Andrew Donnellan wrote:
> Dear stable team
> 
> Please backport the following patch.
> 
> Commit: 7029d1eb0c2c7ee093dc625c679fc277c8eb623b
>      ("powerpc/perf: Fix IMC_MAX_PMU macro")

Whoops, this was a local SHA - I meant 
73ce9aec65b17433e18163d07eb5cb6bf114bd6c.

There's also 110df8bd3e418b3476cae80babe8add48a8ea523 which is an 
additional fix.

Thanks,
-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited

