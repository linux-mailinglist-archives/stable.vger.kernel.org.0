Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7A271C73
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgIUH7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 03:59:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44146 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbgIUH7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 03:59:01 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08L7XDJH114862;
        Mon, 21 Sep 2020 03:58:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Czy5IBsuKiL63vGY+kb5VPoSw3OgpqoynUddwtmiVVk=;
 b=LxMRd0uxg+OdPFZVq40IpVSGbeUGGd61o4PllGcPo1MWLStTxphpPgNqAgFXBoFmC6n3
 pahcHEg/pzTCbhyBpISm7h7RTjU0kPendhi/dqxaQGi+uCbi/hP7ML0gc1bgdNogJIw/
 KrLtKvZjxg35/xmLtqaYCL9W4fvspIgAvyrbbMXcAZZ4DrAUJQ+E06vGnMQXdoO1lgxS
 8wbUIu/y1TASrZqq5wyacuxqTRnI/AucHoTnq1n3N05pQyWyzzbHDanPVzv0NoBl2AUF
 UrToXtClOI8WWDC2JKFR+seGIlD6ARI2zGTXXNI4X+emt44kLsOySQKgQuguxerS65nj Eg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33pqnbrxbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 03:58:49 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08L7vln8027027;
        Mon, 21 Sep 2020 07:58:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 33n98grx0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 07:58:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08L7wjtB17105312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 07:58:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 077785205A;
        Mon, 21 Sep 2020 07:58:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.187.68])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CE65952050;
        Mon, 21 Sep 2020 07:58:44 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 5.4 101/330] powerpc/powernv/ioda: Fix ref count
 for devices with their own PE
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
References: <20200918020110.2063155-1-sashal@kernel.org>
 <20200918020110.2063155-101-sashal@kernel.org>
 <52532d8a-8e90-8a68-07bd-5a3e08c58475@linux.ibm.com>
 <20200919181029.GI2431@sasha-vm>
From:   Frederic Barrat <fbarrat@linux.ibm.com>
Message-ID: <8eaefe77-8cdf-1da5-f573-633713598eb6@linux.ibm.com>
Date:   Mon, 21 Sep 2020 09:58:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200919181029.GI2431@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_01:2020-09-21,2020-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 clxscore=1031 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210054
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 19/09/2020 à 20:10, Sasha Levin a écrit :
> On Fri, Sep 18, 2020 at 08:35:06AM +0200, Frederic Barrat wrote:
>>
>>
>> Le 18/09/2020 à 03:57, Sasha Levin a écrit :
>>> From: Frederic Barrat <fbarrat@linux.ibm.com>
>>>
>>> [ Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 ]
>>>
>>
>> This patch is not desirable for stable, for 5.4 and 4.19 (it was 
>> already flagged by autosel back in April. Not sure why it's showing 
>> again now)
> 
> Hey Fred,
> 
> This was a bit of a "lie", it wasn't a run of AUTOSEL, but rather an
> audit of patches that went into distro/vendor trees but not into the
> upstream stable trees.
> 
> I can see that this patch was pulled into Ubuntu's 5.4 tree, is it not
> needed in the upstream stable tree?


That patch in itself is useless (it replaces a ref counter leak by 
another one). It was part of a longer series that we backported to 
Ubuntu's 5.4 tree.
So it's really not needed on the stable trees. It likely wouldn't hurt 
or break anything, but there's really no point.

   Fred

