Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E7B2334A0
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 16:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgG3Okm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 10:40:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49634 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgG3Okl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 10:40:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UEVjnh041154;
        Thu, 30 Jul 2020 14:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=omQ+KSFeNr5QzVD54DbuGF3jbgJUnhNVpnQ3/r7WG9Y=;
 b=DXJe+AjnLLOo+GuhAKz2j/wROv2iZtMBMELdPuW+tQvaOEpXsgR5WT2koCt/bc/41Eng
 iCK6T7ejntLXxEISPEQbTrAdJgHp+JFBAT2zXBfVO9bUdTQinJ2IYE8KSq+EfiMrWOdG
 dbfDH2Xw+8oTtkHCXQ5ZDJcSsCam5ms0wqhb//fX3Dz46g6TOlmuWxAg33EoLCSrV2Gr
 FwcjHf9bJc8mdYa1Ob+Mfuw9mp8Bz7+4NZJH7y1MUR86J9ucAdKBrM9Ar8r5XYMi7GKR
 Cgv9qMeSigmCSb5bL3bXForwMqT6/XlbXggoglc+eRIVFhNxhBBDFU7WiifkcV7TTNOL Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32hu1jv3dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 14:40:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UEcps2170441;
        Thu, 30 Jul 2020 14:40:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32hu5xg0ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 14:40:35 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06UEeXOS013061;
        Thu, 30 Jul 2020 14:40:33 GMT
Received: from dhcp-10-154-135-99.vpn.oracle.com (/10.154.135.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jul 2020 07:40:33 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.5\))
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20200730052127.GA3860556@kroah.com>
Date:   Thu, 30 Jul 2020 09:40:32 -0500
Cc:     Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8481B1B9-C9CF-442A-87BE-4A01499CF26D@oracle.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com> <20200729115119.GB2674635@kroah.com>
 <20200729115557.GA2799681@kroah.com> <20200729141607.GA7215@redhat.com>
 <851f749a-5c92-dcb1-f8e4-95b4434a1ec4@oracle.com>
 <20200730052127.GA3860556@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3445.9.5)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=3 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300107
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jul 30, 2020, at 12:21 AM, Greg KH <gregkh@linuxfoundation.org> =
wrote:
>=20
> On Wed, Jul 29, 2020 at 06:45:46PM -0500, John Donnelly wrote:
>>=20
>>=20
>> On 7/29/20 9:16 AM, Mike Snitzer wrote:
>>> On Wed, Jul 29 2020 at  7:55am -0400,
>>> Greg KH <gregkh@linuxfoundation.org> wrote:
>>>=20
>>>> On Wed, Jul 29, 2020 at 01:51:19PM +0200, Greg KH wrote:
>>>>> On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
>>>>>> This mail needs to be saent to stable@vger.kernel.org (now cc'd).
>>>>>>=20
>>>>>> Greg et al: please backport =
2df3bae9a6543e90042291707b8db0cbfbae9ee9
>>>>>=20
>>>>> Now backported, thanks.
>>>>=20
>>>> Nope, it broke the build, I need something that actually works :)
>>>>=20
>>>=20
>>> OK, I'll defer to John Donnelly to get back with you (and rest of
>>> stable@).  He is more invested due to SUSE also having this issue.  =
I
>>> can put focus to it if John cannot sort this out.
>>>=20
>>> Mike
>>>=20
>>=20
>>=20
>> Hi.
>>=20
>>=20
>> Thank you for reaching out.
>>=20
>> What specifically is broken? . If it that applying
>> 2df3bae9a6543e90042291707b8db0cbfbae9ee9 to 4.14.y is failing?
>=20
> yes, try it yourself and see!

 Hi .=20

 Yes . =20

  2df3bae9a6543e90042291707b8db0cbfbae9ee9

 Needs refactored to work in 4.14.y (now .190) as there is a conflict in =
arguments as noted in my original submittal ;-) .=20
 I also noticed there are warning to functions " defined but not used =
[-Wunused-function] =E2=80=9C  too.

 Do you want another PATCH v2 message  in a new email thread,  or can I  =
append it to this this thread ?

Please advice.

Thanks.
JD.





=20



