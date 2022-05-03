Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1B9518983
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 18:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbiECQUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 12:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiECQUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 12:20:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB4C1FA47;
        Tue,  3 May 2022 09:16:51 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243Fib6n015328;
        Tue, 3 May 2022 16:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=pOQy/PjfoUASKQBsieVyMYXmR6G6qlGPQnBZNfJWYg8=;
 b=BpF1tovUo0NLs4JjdkCQWqpadzsmAtsnb1063mBmad/i6o3krKlOAEYX1B40+CrCs2tG
 JLhXySV7fx8Lm9j5lS/MxyBSmNK7CQqvR5TL3uWZ99UuXU7Ut6SfBCNbJnJ+bkef1gsu
 WU2kAi+GBK1krUY+R1QPPeGWM1xyeA+v9BtYtGRhcpW9gbUzWVE9Lix279xmolKgsd04
 KzVOIOs6c2D0eOpxSE9jrS95RtleBTYUGdjWK2T9CVaNA8z+qWuN4OEDGJekhoCFYOBr
 WdYItzavFrISq5ujT3a+hqMAj7pYVsvFPlIq6MohP+eHs2yXGjYPr2Qnt1+NmIOxaFaF dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fu7a8rp91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 16:16:42 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 243FqOZ1003505;
        Tue, 3 May 2022 16:16:42 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fu7a8rp8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 16:16:42 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 243G6UXE005814;
        Tue, 3 May 2022 16:16:41 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3frvr9myq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 16:16:40 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 243GGeR631195406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 May 2022 16:16:40 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DFFB7805E;
        Tue,  3 May 2022 16:16:40 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5932578066;
        Tue,  3 May 2022 16:16:36 +0000 (GMT)
Received: from localhost (unknown [9.160.48.141])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue,  3 May 2022 16:16:35 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] powerpc/rtas: Keep MSR[RI] set when calling RTAS
In-Reply-To: <87r15aveny.fsf@mpe.ellerman.id.au>
References: <20220401140634.65726-1-ldufour@linux.ibm.com>
 <87r15aveny.fsf@mpe.ellerman.id.au>
Date:   Tue, 03 May 2022 13:16:29 -0300
Message-ID: <87levia8wy.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4QIy9T9IVO1N4-KCXdHIXyrKE1c93rvw
X-Proofpoint-ORIG-GUID: YQ4p8xJgLWTLQN6qlQo2zo0ubGdZUdNr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-03_06,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=852 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205030109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:

>> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
>> index 9581906b5ee9..65cb14b56f8d 100644
>> --- a/arch/powerpc/kernel/entry_64.S
>> +++ b/arch/powerpc/kernel/entry_64.S
>> @@ -330,22 +330,18 @@ _GLOBAL(enter_rtas)
>>  	clrldi	r4,r4,2			/* convert to realmode address */
>>         	mtlr	r4
>>  
>> -	li	r0,0
>> -	ori	r0,r0,MSR_EE|MSR_SE|MSR_BE|MSR_RI
>> -	andc	r0,r6,r0
>> -	
>> -        li      r9,1
>> -        rldicr  r9,r9,MSR_SF_LG,(63-MSR_SF_LG)
>> -	ori	r9,r9,MSR_IR|MSR_DR|MSR_FE0|MSR_FE1|MSR_FP|MSR_RI|MSR_LE
>> -	andc	r6,r0,r9
>  
> One advantage of the old method is it can adapt to new MSR bits being
> set by the kernel.
>
> For example we used to use RTAS on powernv, and this code didn't need
> updating to cater to MSR_HV being set. We will probably never use RTAS
> on bare-metal again, so that's OK.
>
> But your change might break secure virtual machines, because it clears
> MSR_S whereas the old code didn't. I think SVMs did use RTAS, but I
> don't know whether it matters if it's called with MSR_S set or not?
>
> Not sure if anyone will remember, or has a working setup they can test.
> Maybe for now we just copy MSR_S from the kernel MSR the way the
> current code does.

Would the kernel even be able to change the bit? I think only urfid can
clear MSR_S.
