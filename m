Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F302B9BE3
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 21:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgKSUR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 15:17:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38406 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgKSUR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 15:17:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJKDtl4126955;
        Thu, 19 Nov 2020 20:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=exJiYbKDaQ+mS7WeA5ZmXfOrJdrDQ6I1VDXprbdJi44=;
 b=igDCXO+nPk312wyV7avhl10cwoTCb0ddqYiqv/EZ2IQbz6n6oyVNvbz1wgLx8wUPyoyp
 zfnK/wDkwHWvEjmNW4TLWMEf95getD69GOpc8VouJDEbkQkRd4HP/2nbNuwJZ5hlmfND
 5PKyPhKcNdJY5qHPb0KKAL+bKbaxdsz3E5/y0TaKrCn94Xdkv1nB4cwICqsAxdhWMsLQ
 /eDUXeVreRK5HmqRLcPfpF9Oij1vkvx9/MwxWjaHqLUZQSF6YClG7HqhAMSXgG8H1DQ/
 syVhB8P+0YKlsTR+6Dl+QjLumRNT1B8Vs0SbN1a3viYI3Y2LbfBdsAVeiLOgp98wic1u 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34t7vnffdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 20:16:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJKAeDD152540;
        Thu, 19 Nov 2020 20:16:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34ts60fvtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 20:16:35 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AJKGPHH029775;
        Thu, 19 Nov 2020 20:16:25 GMT
Received: from dhcp-10-159-251-58.vpn.oracle.com (/10.159.251.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 12:16:24 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
In-Reply-To: <7f9e6b63-1727-379b-55b7-9ad2bbdb2e5b@infradead.org>
Date:   Thu, 19 Nov 2020 12:16:21 -0800
Cc:     John Donnelly <john.p.donnelly@oracle.com>, stable@vger.kernel.org,
        Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Vinod Koul <vkoul@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Anson Huang <Anson.Huang@nxp.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?utf-8?Q?Diego_Elio_Petten=C3=B2?= <flameeyes@flameeyes.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <353AE355-18C6-41DD-869B-F93CBE1271BC@oracle.com>
References: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
 <7f9e6b63-1727-379b-55b7-9ad2bbdb2e5b@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=3 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190139
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>=20
>> @@ -1135,6 +1135,30 @@ config CRASH_DUMP
>>=20
>> 	  For more details see Documentation/admin-guide/kdump/kdump.rst
>>=20
>> +if CRASH_DUMP
>> +
>> +config CRASH_AUTO_STR
>> +        string "Memory reserved for crash kernel"
>=20
> use tab instead of spaces above.
>=20

Thanks, Randy. I=E2=80=99ll be fixing the them in the v2. I=E2=80=99ll =
be removing the =E2=80=98CC: stable=E2=80=99 as well.

Saeed

