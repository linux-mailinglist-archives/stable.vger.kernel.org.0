Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4C6E6AAA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 19:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjDRRNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 13:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjDRRMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 13:12:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A74C4486;
        Tue, 18 Apr 2023 10:12:45 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IGCSmm030355;
        Tue, 18 Apr 2023 17:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=QOW8SVoxJK95qoMW/VfatK4OBgyBh912fqcPqWrvep4=;
 b=T8CUH6WYNoYk68i0cQ6whboyVYUjfeRLJSTj20UleAlCk5q/koxwDz9wV334xm/3QLWi
 K66wbUvFvdUnoXHeIm94wTmrky6Ur3avR+UnqUKYlSJ+LnlRRPZF5b5OheP7wn5t/uQe
 h3jzd0DW9cF3xgwFqzJhNSxYrcPhXTQk1Vv0+lx5UQiyPzQNRdnnfqzotH5QmeeVGvlu
 Zrbaq5RJJIs5FR+v+rfTq/aol5DKRbx2iyavzu4q/QBAb+sgB9bKdYFzTXiLy8Ed7c2l
 8SJsBi5kLe/r80sDd3iemLyzFaRd48emVX5pwcrbor9yUQKYPUxOSiF47HS43tdk4HD4 ZA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1q52g9f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 17:12:40 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33IFabjc013985;
        Tue, 18 Apr 2023 17:12:40 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3pykj76ka3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 17:12:39 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33IHCciU9044488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 17:12:38 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C018258058;
        Tue, 18 Apr 2023 17:12:38 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BB295805D;
        Tue, 18 Apr 2023 17:12:37 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.163.32.220])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Apr 2023 17:12:37 +0000 (GMT)
Message-ID: <c5405999615929ba304988ebe18faf3853cc9a95.camel@linux.ibm.com>
Subject: Re: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Sagar.Biradar@microchip.com, john.g.garry@oracle.com,
        Don.Brace@microchip.com, Gilbert.Wu@microchip.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        brking@linux.vnet.ibm.com, stable@vger.kernel.org,
        Tom.White@microchip.com
Date:   Tue, 18 Apr 2023 13:12:36 -0400
In-Reply-To: <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
         <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
         <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YAL2AzIBZtojL9qpUuQrXfUj46T3iRQU
X-Proofpoint-ORIG-GUID: YAL2AzIBZtojL9qpUuQrXfUj46T3iRQU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_12,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304180143
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[I'm with Jon: your email style makes digging information out of the
emails very hard, which is why I only quote this section]
On Mon, 2023-04-10 at 21:17 +0000, Sagar.Biradar@microchip.com wrote:
> ***blk-mq already does what you want here, including handling for the
> case I mention above. It maintains a CPU -> HW queue mapping, and
> using a reply map in the LLD is the old way of doing this.
>  

> We also tried implementing the blk-mq mechanism in the driver and we
> saw command timeouts. 
> The firmware has limitation of fixed number of queues per vector and
> the blk-mq changes would saturate that limit.
> That answers the possible command timeout. 

Could we have more details on this, please?  The problem is that this
is a very fragile area of the kernel, so you rolling your own special
snowflake implementation in the driver is going to be an ongoing
maintenance problem (and the fact that you need this at all indicates
you have long tail customers who will be around for a while yet).  If
the only issue is limiting the number of queues per vector, we can look
at getting the block layer to do that.  Although I was under the
impression that you can do it yourself with the ->map_queues()
callback.  Can you say a bit about why this didn't work?

James

