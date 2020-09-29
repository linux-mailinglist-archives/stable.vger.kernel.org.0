Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9F327D2C4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 17:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgI2Pcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 11:32:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbgI2Pcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 11:32:42 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TFWYMY060034;
        Tue, 29 Sep 2020 11:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pfE9Mc7EehQtVbY5WGbAjVSIwSVWRMNhooXCssMMLdg=;
 b=SnPkgOx982Za4LpSmnLA2RG8IR7vqn8INGtN7zEISvy5mSkf1EJVeZ1cqx98Hhf+/4DB
 oxlo99Iy6Da2yAFMRX3lBaiGdm8m9G+0WjEkaxNOHCLvvboZllPb6UcHMke4b868TXR/
 9YHYsMrRKOvLdhQh14RKFvkcxHupGrmaaVmSEVAzjl01ixeh/USiuqXQ3xAgczGkywsX
 4IQriejqV1rkXxqVW2+8oVLaAz0Z18UiKFeUEICmbhCQ05dX1xaWsbHZJVRzJwU9ZxXg
 rOFy9ZjSJFzeOW32pJT8/glPPN++lRr6KUqhklnP6xfm12EZTxWeAyL5LucGamH4ZWPm Ng== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v7m701bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 11:32:39 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TFR9xq008163;
        Tue, 29 Sep 2020 15:31:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw983g52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 15:31:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TFVob030736826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 15:31:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F2E44204D;
        Tue, 29 Sep 2020 15:31:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3738442042;
        Tue, 29 Sep 2020 15:31:50 +0000 (GMT)
Received: from pomme.local (unknown [9.145.50.8])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 15:31:50 +0000 (GMT)
Subject: Re: [PATCH 1/2] mm: replace memmap_context by memplug_context
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20200929135738.28697-1-ldufour@linux.ibm.com>
 <20200929142904.GC1203131@kroah.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <b4e8f0ea-2d4a-eacf-b617-932906cbf1b1@linux.ibm.com>
Date:   Tue, 29 Sep 2020 17:31:50 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200929142904.GC1203131@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_07:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290133
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 29/09/2020 à 16:29, Greg KH a écrit :
> On Tue, Sep 29, 2020 at 03:57:37PM +0200, Laurent Dufour wrote:
>> Backport version to the 5.4-stable tree of the commit:
>>
>> c1d0da83358a ("mm: replace memmap_context by meminit_context")
>>
>> Cc: <stable@vger.kernel.org> # 5.4.y
>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> 
> What happened to the full changelog from the original commit, and all of
> the cc: and signed-off-by from it?
> 
> Please include that in the patch, you don't want to see all of that
> stripped off, right?

Sorry, I was thinking some magic script was pulling the original commit 
description based on the git commit id ;)

I'll send the patches again.
Is there a specific tag to use when mentioning the original commit id?

Thanks,
Laurent.
