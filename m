Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A498178258
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCCSTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:19:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45858 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgCCSTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 13:19:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023I96n8194779;
        Tue, 3 Mar 2020 18:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qBj56/ibz80boHJT5AAozBqxSDMS4b6LVKWjCwwbm6g=;
 b=D2s8AOP4NizhcoxM3bXqgEo4LZP3Y9UR2MYEb3yH1nTQfw7DA9G0B12eRavOM3Z7o4ve
 bZyraXenO2SJWt2ANp75eQBOIL1c4UeynAQRG/7QtMxK2YMwN/+cVmfA24sQE1DwUH9q
 IcuZPJ3MTkzraw5vcBJbgSavInz8orDrMHVsQkALqK7WzLmDxlJ4WfLZr6cuOgLllZSF
 eqFohSZoBQKre6a97IWN4QLV63wzXToV54Tw8Vn/1VDRgnadODbZoHHtNXmscRvQ9EGB
 CrInEYFl0onRgk/UhT16IicAHG1ypYhfHyCyAqB86zrxjFypkuJxl4p2yObdygPDFPCY Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yghn34we1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 18:19:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023IEa6B022402;
        Tue, 3 Mar 2020 18:19:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yg1p5271m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 18:19:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023IJVa9018603;
        Tue, 3 Mar 2020 18:19:31 GMT
Received: from [10.152.34.58] (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 10:19:31 -0800
Subject: Re: Patch "padata: always acquire cpu_hotplug_lock before
 pinst->lock" has been added to the 4.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <1583253273103220@kroah.com>
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
Message-ID: <57b3012d-7692-de3d-7cb2-3004599563d0@oracle.com>
Date:   Tue, 3 Mar 2020 13:18:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1583253273103220@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030122
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/20 11:34 AM, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>      padata: always acquire cpu_hotplug_lock before pinst->lock
> 
> to the 4.4-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       padata-always-acquire-cpu_hotplug_lock-before-pinst-lock.patch
> and it can be found in the queue-4.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
>  From 38228e8848cd7dd86ccb90406af32de0cad24be3 Mon Sep 17 00:00:00 2001
> From: Daniel Jordan <daniel.m.jordan@oracle.com>
> Date: Tue, 3 Dec 2019 14:31:11 -0500
> Subject: padata: always acquire cpu_hotplug_lock before pinst->lock
> 
> From: Daniel Jordan <daniel.m.jordan@oracle.com>
> 
> commit 38228e8848cd7dd86ccb90406af32de0cad24be3 upstream.

Hi, can this please be removed from all stable trees?  I guess this made its way back in after Sasha removed it before.  Justification is at

https://lkml.kernel.org/r/20200222000045.cl45vclfhvkjursm@ca-dmjordan1.us.oracle.com

thanks,
Daniel
