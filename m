Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4965F3CCD81
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 07:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhGSFnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 01:43:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhGSFns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 01:43:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J5YFTo070227;
        Mon, 19 Jul 2021 01:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dGVLtPh3jOfLC4XymPX19eIG8AqQgTvPQWz4eU/54mA=;
 b=Kcoca/SBRbKun2Ixq9GRd6N3tAx0pOgHDEfrKqHafvpIRVyaM19OSCRtvAqeWLvZgF0Y
 CcVR2WpVmJ5XwatCzwxfrV/lZR9GCb8IK+FQGtNLfsv53vlZ99K7qZTxgkReYaICxRc5
 NXrdJViz7jQVjHQy9p+XgDXFv+kvRDgqwLM0u03XpKrZGxPARdsD3+/dsIPevBvUISRt
 B05odeAP/JEUF+9vG8/QzABg7tq8az+pTzyyjDd9WPRlHpfxjdoH5+5X4hZD2kB50/Td
 rotliaedNbBnnmRbVc3l0+H/SfOZT8t++/vQaz5Cg1WPbk/qT1jMgm6AWzrTXid/HZHY nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w2wc8qjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 01:40:28 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16J5Z5gC074147;
        Mon, 19 Jul 2021 01:40:28 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w2wc8qhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 01:40:27 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16J5ZCET018490;
        Mon, 19 Jul 2021 05:40:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 39vng705ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 05:40:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16J5eNTC23790050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 05:40:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D83474C05A;
        Mon, 19 Jul 2021 05:40:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D9FE4C044;
        Mon, 19 Jul 2021 05:40:22 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 19 Jul 2021 05:40:22 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Daniel =?utf-8?Q?D=C3=ADaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        linux- stable <stable@vger.kernel.org>, hca@linux.ibm.com
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
References: <20210715182551.731989182@linuxfoundation.org>
        <CAEUSe7_+8fQZ=1+jcxJVTRw0DYttGmR-aBdobZ0GWYQi3Vg97w@mail.gmail.com>
Date:   Mon, 19 Jul 2021 07:40:21 +0200
In-Reply-To: <CAEUSe7_+8fQZ=1+jcxJVTRw0DYttGmR-aBdobZ0GWYQi3Vg97w@mail.gmail.com>
        ("Daniel =?utf-8?Q?D=C3=ADaz=22's?= message of "Thu, 15 Jul 2021 16:49:16
 -0500")
Message-ID: <yt9dim16lv3u.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
Content-Type: text/plain; charset=utf-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9jWOTP-Qx5D9E2G-ckx07jKytJQrLSnz
X-Proofpoint-GUID: 9CUIsM1Oyv-FXuSttjzlVDObI941Empa
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_01:2021-07-16,2021-07-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190032
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

Daniel D=C3=ADaz <daniel.diaz@linaro.org> writes:

> Hello!
>
> On Thu, 15 Jul 2021 at 13:56, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> This is the start of the stable review cycle for the 5.12.18 release.
>> There are 242 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch=
-5.12.18-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git linux-5.12.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Build regressions have been found on this release candidate (and on 5.13-=
rc).
>
> ## Regressions (compared to v5.12.17)
> * s390, build
>   - clang-10-allnoconfig
>   - clang-10-defconfig
>   - clang-10-tinyconfig
>   - clang-11-allnoconfig
>   - clang-11-defconfig
>   - clang-11-tinyconfig
>   - clang-12-allnoconfig
>   - clang-12-defconfig
>   - clang-12-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-defconfig
>   - gcc-8-tinyconfig
>   - gcc-9-allnoconfig
>   - gcc-9-defconfig
>   - gcc-9-tinyconfig
>   - gcc-10-allnoconfig
>   - gcc-10-defconfig
>   - gcc-10-tinyconfig
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> [...]
>> Sven Schnelle <svens@linux.ibm.com>
>>     s390/signal: switch to using vdso for sigreturn and syscall restart
> [...]
>
> Our bisections pointed to this commit. Reverting it made the build pass a=
gain.

If https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/142=
8532107
is the logfile for this problem, than i see the following in the log:

make --silent --keep-going --jobs=3D8 O=3D/home/tuxbuild/.cache/tuxmake/bui=
lds/current ARCH=3Ds390 CROSS_COMPILE=3Ds390x-linux-gnu- 'CC=3Dsccache s390=
x-linux-gnu-gcc' 'HOSTCC=3Dsccache gcc'
/bin/sh: 1: /builds/linux/arch/s390/kernel/vdso64/gen_vdso_offsets.sh: Perm=
ission denied

However, in the patch this script is 755, and other architecture are
using this for a while now - can you check what the permission are when
you're trying to build the kernel?

Thanks
Sven
