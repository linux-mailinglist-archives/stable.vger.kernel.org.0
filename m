Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9BD656A1D
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 12:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiL0L44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 06:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiL0L4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 06:56:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26762191;
        Tue, 27 Dec 2022 03:56:28 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BRAug9p015465;
        Tue, 27 Dec 2022 11:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=D8Dmx1UxuS+JHTxv5lC60zrzyi7pxK0+1j1ZUQBGI+s=;
 b=cZIyMnbgRM8ill5SmM3x9C23RqRUDIWzIjD6q8bV1hMzjZAY0V9PqJtqhjxe67C1hS83
 ivw1VylxITSIC0UwRmlSf74w+n4sSzNm7gwR7iUoTcksb35S9hvnah5xgS9NwHt6RWHz
 7IIvZ/J19rLpm/oqpGJUiuey6HP/xS2iMqfrHLRrHrjljmtnl2+yMz8VdZ3/09cPNMms
 tDkfr/hE9K4j1UYvvP/z8jrjB00QTu6xlfiTaEQ2x6sDgj1hVpVwamgazpidzFNDlE9d
 CChx/DB4f8coDrsdQj/2CroC4dUdWXxN68w3V2edxhOaS3yzMFbsm/b+m6D0C1OVu/Qh Yw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mqyd9gwpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Dec 2022 11:56:19 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BRBIBda013133;
        Tue, 27 Dec 2022 11:56:18 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3mns27rumj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Dec 2022 11:56:17 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BRBuHOC31326674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Dec 2022 11:56:17 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAA6B58054;
        Tue, 27 Dec 2022 11:56:16 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E03D858058;
        Tue, 27 Dec 2022 11:56:15 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.23.56])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 27 Dec 2022 11:56:15 +0000 (GMT)
Message-ID: <d65e2d46bf41e3d58c0fa18bd274faf20dadb523.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] ima: Handle -ESTALE returned by
 ima_filter_rule_match()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        GUO Zihua <guozihua@huawei.com>
Cc:     stable@vger.kernel.org, paul@paul-moore.com,
        linux-integrity@vger.kernel.org, luhuaxin1@huawei.com
Date:   Tue, 27 Dec 2022 06:56:15 -0500
In-Reply-To: <Y6qgqO/LJ/wHUk5x@kroah.com>
References: <20221227014729.4799-1-guozihua@huawei.com>
         <20221227014729.4799-3-guozihua@huawei.com> <Y6qgqO/LJ/wHUk5x@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pS52XCwEjMORToRoUGn0RngLWm0ogdc-
X-Proofpoint-ORIG-GUID: pS52XCwEjMORToRoUGn0RngLWm0ogdc-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-27_08,2022-12-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxscore=0 clxscore=1011 spamscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212270091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-12-27 at 08:37 +0100, Greg KH wrote:
> On Tue, Dec 27, 2022 at 09:47:29AM +0800, GUO Zihua wrote:
> > [ Upstream commit c7423dbdbc9ecef7fff5239d144cad4b9887f4de ]
> 
> For obvious reasons we can not only take this patch (from 6.2-rc1) into
> 4.19.y as that would cause people who upgrade from 4.19.y to a newer
> stable kernel to have a regression.
> 
> Please submit backports for all stable kernels if you wish to see this
> in older ones to prevent problems like this from happening.

Sasha has already queued the original commit and the dependencies for
the 6.1, 6.0, and 5.15 stable kernels.  Those kernels all had the
call_lsm_notifier() to call_blocking_lsm_notifier() change.  Prior to
5.3, the change to the blocking notifier would need to be backported as
well.  This version of the backport still needs to be reviewed.

thanks,

Mimi

> 
> But also, why are you still on 4.19.y?  What is wrong with 5.4.y at this
> point in time?  If we dropped support for 4.19.y in January, what would
> that cause to happen for your systems?
> 
> thanks,
> 
> greg k-h
> 

