Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D912B9C50
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 21:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgKSUy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 15:54:58 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52242 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgKSUy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 15:54:58 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJKsL7g122414;
        Thu, 19 Nov 2020 20:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=jUdxTuSHtsuS3WsA4fd2+z7O66RBMlImwnbK4D6tItg=;
 b=lJgJ0exMOfKGfTU9qWgUxdSdYpQ7NX5JU5l4WBWJenUkHxDJaa3j2YYohjmeLEOYdezl
 qxAAEJlDVNSTe45OQ9YCpmse4BssJrkQEjgi8DX3EeMVH6vZIzLDeP7rBo11d7AGWaqK
 Vqzsc0iqyPKC71ssR9QcY3jJpZ/vcus6xBma3KGXUfHRaL5HumWoF7gkwS4V/QEhY4W5
 4VSglFI4FtI9HPmrdOX6VXsxrX6su1gDEqPGxTC4OnJ5g/NARWHeyaV6SrlWCGNUwvfj
 ue32zhNoTBN3XjboQUS7Q2x1OKtA6qaNwi12imQfb+dNYsh5KhRxi5H/x8kN9aRY1lTa lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rb7s1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 20:54:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJKnjGO117244;
        Thu, 19 Nov 2020 20:52:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34uspwp9ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 20:52:15 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AJKqDZq028770;
        Thu, 19 Nov 2020 20:52:13 GMT
Received: from dhcp-10-159-251-58.vpn.oracle.com (/10.159.251.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 12:52:13 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
In-Reply-To: <CACPcB9e8p5Ayw15aOe5ZNPOa7MF3+pzPdcaZgTc_E_TZYkgD6Q@mail.gmail.com>
Date:   Thu, 19 Nov 2020 12:52:10 -0800
Cc:     John Donnelly <john.p.donnelly@oracle.com>, stable@vger.kernel.org,
        Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
        Randy Dunlap <rdunlap@infradead.org>,
        kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8F545EB3-9AA4-45AE-84D2-7C0B5CF43FF6@oracle.com>
References: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
 <CACPcB9e8p5Ayw15aOe5ZNPOa7MF3+pzPdcaZgTc_E_TZYkgD6Q@mail.gmail.com>
To:     Kairui Song <kasong@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=3 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=3 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190143
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
[I=E2=80=99m resending this email as it failed to be sent to certain =
emails.]

> And I think crashkernel=3Dauto could be used as an indicator that user
> want the kernel to control the crashkernel size, so some further work
> could be done to adjust the crashkernel more accordingly. eg. when
> memory encryption is enabled, increase the crashkernel value for the
> auto estimation, as it's known to consume more crashkernel memory.
>=20
Thanks for the suggestion! I tried to keep it simple and leave it to the =
user to change Kconfig in case a different range is needed. Based on =
experience, these ranges work well for most of the regular cases.

>=20
> But why not make it arch-independent? This crashkernel=3Dauto idea
> should simply work with every arch.

Thanks! I=E2=80=99ll be making it arch-independent in the v2 patch.

>=20
> I think this rounding may be better moved to the arch specified part
> where parse_crashkernel is called?

Thanks for the suggestion. Could you please elaborate why do we need to =
do that?

Thanks,
Saeed

