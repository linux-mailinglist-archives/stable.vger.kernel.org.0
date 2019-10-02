Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDA5C4981
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 10:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfJBIbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 04:31:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfJBIbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 04:31:09 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x928RS4b104246
        for <stable@vger.kernel.org>; Wed, 2 Oct 2019 04:31:08 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vcqwd91d4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 02 Oct 2019 04:31:07 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <maier@linux.ibm.com>;
        Wed, 2 Oct 2019 09:31:05 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 2 Oct 2019 09:31:03 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x928UXZO40239568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Oct 2019 08:30:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D641BA405C;
        Wed,  2 Oct 2019 08:31:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E0D6A405B;
        Wed,  2 Oct 2019 08:31:01 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.98.63])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Oct 2019 08:31:01 +0000 (GMT)
Subject: Re: [PATCH v2] zfcp: fix reaction on bit error theshold notification
 with adapter close
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, stable@vger.kernel.org
References: <yq1d0fhw2ex.fsf@oracle.com>
 <20191001104949.42810-1-maier@linux.ibm.com>
 <20191001141408.GB3129841@kroah.com>
 <71b8fc68-23a8-a591-1018-f290d6e3312a@linux.ibm.com>
 <20191001154208.GB3523275@kroah.com> <yq1tv8stj87.fsf@oracle.com>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Wed, 2 Oct 2019 10:31:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <yq1tv8stj87.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19100208-0020-0000-0000-0000037441CA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100208-0021-0000-0000-000021CA44EC
Message-Id: <c0a921a4-f529-03cd-b39c-24c5f25f8b44@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-02_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910020080
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/1/19 8:26 PM, Martin K. Petersen wrote:
>> Ok, then why make this a module option that you will have to support
>> for the next 20+ years anyway if you feel this fix is the correct way
>> that it should be done instead?
> 
> I agree.
> 
> Why not just shut FCP down unconditionally on excessive bit errors?
> What's the benefit of allowing things to continue? Are you hoping things
> will eventually recover in a single-path scenario?

Experience told me that there will be an unforeseen end user scenario where I 
need a quick switch to let even shaky paths survive.


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

