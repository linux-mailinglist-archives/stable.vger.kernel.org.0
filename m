Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0777741ACF5
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 12:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbhI1KbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 06:31:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32538 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240055AbhI1KbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 06:31:24 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S8sEdW035509;
        Tue, 28 Sep 2021 06:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PQeU7C76MiSQb8Cpy524WrJ4qxMuQBE5aX+bqIChG3k=;
 b=UGk9cebiBCrmQtvKmd0wn4fM+LR4aMJSCRidVWWufckfiy1j1YbAx7VGbui5P5hRD6ye
 FfUghDoUHxfv1EvQq+RLZc8n/6/C1WeBg0NeEHB3nOjHCTDMsrrZJlmOMGJhcIQY4Pm0
 z5I7jveWZny0c331aQYBXp8varwlPnt/QsWwKBzJbml/EW8wgqZwmOe75s44Qo5JzFDM
 /rn7m3uIMxsoZ02imiMVbsT3iKBK8UH+lyXB639JDVqMsTjNLAOk0m740BSU+hljYX26
 b16S0ZSKA7gdpwdyVxkpGgi9nTl66kJp73F4Y3t12ULuc7FRvpvssPbNqrmf8bne/oNk 6w== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbtew8jwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 06:29:40 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SADuof003951;
        Tue, 28 Sep 2021 10:29:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3b9ud9k953-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 10:29:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SATZPQ40108514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:29:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D46D52052;
        Tue, 28 Sep 2021 10:29:35 +0000 (GMT)
Received: from [9.171.64.190] (unknown [9.171.64.190])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CC0BF5205A;
        Tue, 28 Sep 2021 10:29:34 +0000 (GMT)
Message-ID: <b224bdf4-cd15-369e-e82a-95e77e8f798c@linux.ibm.com>
Date:   Tue, 28 Sep 2021 12:29:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 5.10 048/103] s390/qeth: fix deadlock during failing
 recovery
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>
References: <20210927170225.702078779@linuxfoundation.org>
 <20210927170227.414776158@linuxfoundation.org>
 <CA+G9fYs2a78_RXaqfE3WMjSOh=HhuS=OjVxh9Hswzrme+pqxqQ@mail.gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <CA+G9fYs2a78_RXaqfE3WMjSOh=HhuS=OjVxh9Hswzrme+pqxqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H-ZsEvG73U7IQqDIdrlHLkQwObtoFBm-
X-Proofpoint-GUID: H-ZsEvG73U7IQqDIdrlHLkQwObtoFBm-
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280058
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.09.21 19:45, Naresh Kamboju wrote:
> Following commit caused the build failures on s390,
> 
> On Mon, 27 Sept 2021 at 22:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> From: Alexandra Winter <wintera@linux.ibm.com>
>>
>> [ Upstream commit d2b59bd4b06d84a4eadb520b0f71c62fe8ec0a62 ]
>>

Yes, this depends on ee909d0b1dac ("s390/qeth: Fix deadlock in remove_discipline").


> 
> drivers/s390/net/qeth_core_main.c: In function 'qeth_close_dev_handler':
> drivers/s390/net/qeth_core_main.c:83:9: error: too few arguments to
> function 'ccwgroup_set_offline'
>    83 |         ccwgroup_set_offline(card->gdev);
>       |         ^~~~~~~~~~~~~~~~~~~~
> In file included from drivers/s390/net/qeth_core.h:44,
>                  from drivers/s390/net/qeth_core_main.c:46:
> arch/s390/include/asm/ccwgroup.h:61:5: note: declared here
>    61 | int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv);
>       |     ^~~~~~~~~~~~~~~~~~~~
> make[3]: *** [scripts/Makefile.build:280:
> drivers/s390/net/qeth_core_main.o] Error 1
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> 
> Build url:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1626658768#L73
> 
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 

