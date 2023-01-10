Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF086641DB
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjAJNb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 08:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbjAJNbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 08:31:24 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADEF2DFC;
        Tue, 10 Jan 2023 05:31:22 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ADSZnA004886;
        Tue, 10 Jan 2023 13:31:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : in-reply-to : references : content-type : mime-version :
 date : content-transfer-encoding; s=pp1;
 bh=xX5m8bo/3BUD7Bq5HVkHmC7vfLm/Cytq5WIdDbNPmE8=;
 b=jS8t1Mag8I06GZkrmXb7fp5xbXRnkprahxx5iod9GMAwu3XaUl05DOnhpZ3dia7na60+
 NbHqmgnDFg/ZIsSoe5JIKPtLEL4p/Qxk38SHiZfOOIyXm0z1KsQIqQH26alYoFVle+61
 r3IMzbRZhGiiEZwFSSh8XsmgvmXWKVyLCqi3MDNn97J7a7FjEDkJVS3OmwpGeRY7x7Ze
 a3tus1bWAZwYhG6h98Z2bVYNKpCA7wCxxVMjthCnShgqjKENJFu+g4kwFF22Y+jivZLF
 pElFJQXPSTgRyqfwOUkUmX92eUvYJPvNFdFYnyLvdA95G5OSxk3qnRPcYJLST5aLplwC 4w== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n18xer2f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 13:31:13 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ACbKm0017075;
        Tue, 10 Jan 2023 13:31:12 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3my0c7sw2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 13:31:12 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30ADVBOs36700536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 13:31:11 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F386858052;
        Tue, 10 Jan 2023 13:31:10 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 877815804E;
        Tue, 10 Jan 2023 13:31:10 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.108.101])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 13:31:10 +0000 (GMT)
Message-ID: <4b867a8508e9da63d4dfa276f89f3f636d4e4e4d.camel@linux.ibm.com>
Subject: Re: [PATCH v6 0/3] ima: Fix IMA mishandling of LSM based rule
 during
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        GUO Zihua <guozihua@huawei.com>
Cc:     stable@vger.kernel.org, paul@paul-moore.com,
        linux-integrity@vger.kernel.org, luhuaxin1@huawei.com
In-Reply-To: <Y7a45tx4tvV6hDuC@kroah.com>
References: <20230105062312.14325-1-guozihua@huawei.com>
         <Y7a45tx4tvV6hDuC@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Date:   Tue, 10 Jan 2023 08:30:55 -0500
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cW7TWUqPsBK56VnlNOfvQk-sDK0O-av-
X-Proofpoint-ORIG-GUID: cW7TWUqPsBK56VnlNOfvQk-sDK0O-av-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_04,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2023-01-05 at 12:47 +0100, Greg KH wrote:
> On Thu, Jan 05, 2023 at 02:23:09PM +0800, GUO Zihua wrote:
> > Backports the following three patches to fix the issue of IMA mishandling
> > LSM based rule during LSM policy update, causing a file to match an
> > unexpected rule.
> > 
> > v6:
> >   Removed the redundent i in ima_free_rule().
> 
> Given the huge numbers of revisions in this series, I suggest working
> together with the relevant subsystem maintainers to get a final,
> working, agreed-apon version before submitting it again.

There was one minor change to v6, which is addressed in v7.  Paul has
reviewed the LSM/SELinux pieces.  I'd appreciate v7 of this patch set
be applied to stable 4.19.

FYI, commit c7423dbdbc9e ("ima: Handle -ESTALE returned by
ima_filter_rule_match()") has already been backported to other stable
branches.
-- 
thanks,

Mimi

