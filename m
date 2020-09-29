Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C207227D9BF
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 23:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgI2VGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 17:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbgI2VGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 17:06:12 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052F0C061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 14:06:11 -0700 (PDT)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 08TL0xKo021731;
        Tue, 29 Sep 2020 22:06:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=jan2016.eng;
 bh=Akmpk6dAx2xbbTQRdChpr7bjYHZHho3FysaagPyfY5E=;
 b=IIi2ZpsXgPNtzMaguX695Jp0ZHAuQGX2IkeBqsVJ5iza9x6orUYcmg6kEikJ1WxYedzl
 /UP4+F1giybg6Sj+W9GSyKJcK0Uid5boy20cvvlxo2jm0S1x/5NP8BzKU/5PXZG1mc9M
 YPtc53R0NgrS8lFe+hAPv7V92AytzB3kJYxgqXGoerm3eWECtx9usVun7wQFRQ28AJiI
 AWctTDjNnKR+aRB7MojxR3TkZXWFfiISR2CFu4GWvXCyjWZF6f59UvxjD1snRE+FsToE
 IaG47qoxhCaLg1ijn7djhFeOfk2lidxXjv7Ij0CKFzyZx9Bl3W+vr5SPMYY8DNdIqUeK 5Q== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 33stqm5w02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 22:06:11 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 08TL5mZ1027619;
        Tue, 29 Sep 2020 17:06:10 -0400
Received: from email.msg.corp.akamai.com ([172.27.165.118])
        by prod-mail-ppoint3.akamai.com with ESMTP id 33t0yxtnrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 17:06:10 -0400
Received: from ustx2ex-dag1mb6.msg.corp.akamai.com (172.27.165.124) by
 ustx2ex-dag1mb2.msg.corp.akamai.com (172.27.165.120) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 29 Sep 2020 16:06:09 -0500
Received: from ustx2ex-dag1mb6.msg.corp.akamai.com ([172.27.165.124]) by
 ustx2ex-dag1mb6.msg.corp.akamai.com ([172.27.165.124]) with mapi id
 15.00.1497.006; Tue, 29 Sep 2020 16:06:09 -0500
From:   "Banerjee, Debabrata" <dbanerje@akamai.com>
To:     "'stable@vger.kernel.org'" <stable@vger.kernel.org>
CC:     'Konstantin Khlebnikov' <khlebnikov@yandex-team.ru>
Subject: block/diskstats: more accurate approximation of io_ticks for slow
 disks
Thread-Topic: block/diskstats: more accurate approximation of io_ticks for
 slow disks
Thread-Index: AdaWo1DS0JdD8FofSbOj6tZpu0wINg==
Date:   Tue, 29 Sep 2020 21:06:09 +0000
Message-ID: <5556dc903145475bbe9fc5fa7d116a05@ustx2ex-dag1mb6.msg.corp.akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.28.122.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=846
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290179
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit: 2b8bd423614c595540eaadcfbc702afe8e155e50

Please apply to linux-5.4.y. Without this fix, disk utilization reporting i=
s
unusable, especially on spinning disks.

Thanks,
Deb

