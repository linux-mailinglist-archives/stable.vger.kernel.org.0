Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E76C3893
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 17:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731937AbfJAPIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 11:08:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727005AbfJAPIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 11:08:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x91F3l7a138750
        for <stable@vger.kernel.org>; Tue, 1 Oct 2019 11:07:57 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vc8kqhjks-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 11:07:57 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 1 Oct 2019 16:07:55 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 1 Oct 2019 16:07:52 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x91F7MEq29819342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Oct 2019 15:07:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D55EBA4055;
        Tue,  1 Oct 2019 15:07:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8033EA4051;
        Tue,  1 Oct 2019 15:07:50 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.98.61])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Oct 2019 15:07:50 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH v2] zfcp: fix reaction on bit error theshold notification
 with adapter close
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, stable@vger.kernel.org
References: <yq1d0fhw2ex.fsf@oracle.com>
 <20191001104949.42810-1-maier@linux.ibm.com>
 <20191001141408.GB3129841@kroah.com>
Date:   Tue, 1 Oct 2019 17:07:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191001141408.GB3129841@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19100115-0020-0000-0000-000003740055
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100115-0021-0000-0000-000021CA0046
Message-Id: <71b8fc68-23a8-a591-1018-f290d6e3312a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-01_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910010136
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/1/19 4:14 PM, Greg KH wrote:
> On Tue, Oct 01, 2019 at 12:49:49PM +0200, Steffen Maier wrote:
>> On excessive bit errors for the FCP channel ingress fibre path, the channel
>> notifies us. Previously, we only emitted a kernel message and a trace record.
>> Since performance can become suboptimal with I/O timeouts due to
>> bit errors, we now stop using an FCP device by default on channel
>> notification so multipath on top can timely failover to other paths.
>> A new module parameter zfcp.ber_stop can be used to get zfcp old behavior.
> 
> Ugh, module parameters?  This isn't the 1990's anymore :(
> 
> Why not just make this a dynamic sysfs variable, that way you properly
> can set this on whatever device you want, not just "all or nothing"?

Since we can see many more (virtual) FCP devices than we want to actually use, 
we defer probing. It means, we only start allocating structures and sysfs 
entries on setting an FCP "online" for the first time. Setting online works 
through another sysfs attribute owned by our ccw bus code component called 
"cio". IIRC, setting online does not emit a uevent. On setting online, the 
(add) uevent of hot-/coldplug of an FCP device had already happened, so we 
could not easily have end users craft udev rules to automatically/persistently 
configure a new sysfs attribute (which is FCP-device-specific and appears late) 
to disable the new code behavior.

Not sure if that could ever become a problem for end users: Even if we were to 
write into a new sysfs attribute, the attribute only appears during setting 
online so this might race with starting to actually use the FCP device with the 
new default behavior and could potentially disable I/O paths before the sysfs 
attribute write could become effective to disable the new behavor.


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

