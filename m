Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117B3240714
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgHJOAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:00:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgHJOAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 10:00:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07ADucDg117610;
        Mon, 10 Aug 2020 13:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=jxr/6dOVcI4pq0GOp/J22brWX4nTzRGL+VD/w82JmDk=;
 b=dDZdwYOmngqAk3omfT2mRpCF86xH8fO78IPG34cwm5sKX5W9aJmHHmOU//sjM4kGM/X8
 +jyV67QIKsxQeasxi+ooN7UNUtDmJ+B/SXUrqHSXq8bXqt8TlMwYURRzX92JfBfpdGFM
 AS9U7YfPFc0cU7FztzbKP8DS0VRWPOZvBmN6nbhVfUY26ZFrqvrB5CNm1uJFWbxIEBiL
 CY5oVgMtuuVjd4CtF/BIV82AU2LkKQ7prEQJEkRuMcRL9Znwkzk9XGC6V10xgDundETZ
 rRDXiCzbPBX7VdwplGR38IkcLmJxoSPSkk14m0j+rOLZoy+pT1FPWN+TUnb7jqrWQ27A Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32sm0men8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Aug 2020 13:59:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07ADrEuX021588;
        Mon, 10 Aug 2020 13:57:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32t5y0x69d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Aug 2020 13:57:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07ADvvpo004148;
        Mon, 10 Aug 2020 13:57:57 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Aug 2020 13:57:57 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: Backport request: nfsd: Fix NFSv4 READ on RDMA when using readv
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200810135218.GC3491228@kroah.com>
Date:   Mon, 10 Aug 2020 09:57:56 -0400
Cc:     Timo Rothenpieler <timo@rothenpieler.org>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <22C4A9C2-5986-447C-B91E-DC2F9653A7E9@oracle.com>
References: <9cc28958-b715-5e51-e0c8-6f1821d2bfe0@rothenpieler.org>
 <20200810135218.GC3491228@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9708 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008100103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9708 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008100104
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg-

> On Aug 10, 2020, at 9:52 AM, Greg KH <gregkh@linuxfoundation.org> =
wrote:
>=20
> On Tue, Aug 04, 2020 at 10:47:26PM +0200, Timo Rothenpieler wrote:
>> Sorry if this is not the right approach to this, but I'd like to =
request a
>> backport of 412055398b9e67e07347a936fc4a6adddabe9cf4, "nfsd: Fix =
NFSv4 READ
>> on RDMA when using readv" to Linux 5.4.
>>=20
>> The patch applies cleanly and fixes a rare but severe issue with NFS =
over
>> RDMA, which I just spent several days tracking down to that patch, =
with
>> major help from linux-nfs/rdma.
>>=20
>> I have right now manually applied it to my 5.4 Kernel and can confirm =
it
>> fixes the issue.
>=20
> It's good to cc: the developers/maintainers of the patch you are =
asking
> about, to see if they object or not.
>=20
> Chuck, any objection for the above patch being added to 5.4 and maybe
> 4.19?

Since Timo applied it to 5.4 and tested it, I have no objection there.

v4.19 suffers from the same bug, but I don't have reports of anyone
having tried 4120553 on that kernel. I would say wait on that one until
someone can state that it works without regression.


--
Chuck Lever



