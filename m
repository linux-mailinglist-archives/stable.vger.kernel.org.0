Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC5D35E5F1
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 20:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhDMSGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 14:06:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43846 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhDMSGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 14:06:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DHxOtW132100;
        Tue, 13 Apr 2021 18:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=hlNJKe5ZQHqLJBRDE/GVAnsIZF7aOarhXY6k7i8Dylw=;
 b=FciRzDciVSbNwefWpUyrNgvLDwWVLtIxe63ZfSv+cnP4bZPY7TCW9kIuru74bppW7pWP
 qN2JPp+IN31FDUKJ9SLnIE6iDXmmT94GT+Zwj5y6yc41PBq/RzDgTi2lbEXn4bYcXWUj
 /b2FNdLJ3FztekbTRRm9trWusvyzt5PStNsqVtYr8oeZPxChrOlLzGQr5rmE1l5uFgtA
 ZBNqVM2klzp4t6HWY6NCxANQZCYpwzWn/NTYRWBXM+V/3bRDvDW41ADA1Zs6DfZs7/UW
 IJlZmIjegA81YsKR1yaannfx3ZUOe3/fRVlrEA0gftUvlO+052Z6yNVBHvJhroNfGJEh GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbg4h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 18:05:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DI1ivZ183168;
        Tue, 13 Apr 2021 18:05:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 37unx04dwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 18:05:37 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13DI5akD020777;
        Tue, 13 Apr 2021 18:05:36 GMT
Received: from dhcp-10-159-224-82.vpn.oracle.com (/10.159.224.82)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Apr 2021 18:05:36 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 5.4 v3 1/1] iommu/vt-d: Fix agaw for a supported 48 bit
 guest address width
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
In-Reply-To: <YHVJDM4CXINrO1KE@kroah.com>
Date:   Tue, 13 Apr 2021 11:05:34 -0700
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Camille Lu <camille.lu@hpe.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C3869E0-63C9-42D5-AAE2-D9D24011B93E@oracle.com>
References: <20210412202736.70765-1-saeed.mirzamohammadi@oracle.com>
 <YHVJDM4CXINrO1KE@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130122
X-Proofpoint-GUID: nnkPDQQoNtBu7Wr08YfCj6ThuPIZvrbx
X-Proofpoint-ORIG-GUID: nnkPDQQoNtBu7Wr08YfCj6ThuPIZvrbx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130122
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I don=E2=80=99t have any commit ID since the fix is not in mainline or =
any Linus=E2=80=99 tree yet. The driver has completely changed for newer =
stable versions (and also mainline) and the fix only applies for 5.4, =
4.19, and 4.14 stable kernels.

Thanks,
Saeed


> On Apr 13, 2021, at 12:32 AM, Greg KH <gregkh@linuxfoundation.org> =
wrote:
>=20
>=20
> On Mon, Apr 12, 2021 at 01:27:35PM -0700, Saeed Mirzamohammadi wrote:
>> The IOMMU driver calculates the guest addressability for a DMA =
request
>> based on the value of the mgaw reported from the IOMMU. However, this
>> is a fused value and as mentioned in the spec, the guest width
>> should be calculated based on the minimum of supported adjusted guest
>> address width (SAGAW) and MGAW.
>>=20
>> This is from specification:
>> "Guest addressability for a given DMA request is limited to the
>> minimum of the value reported through this field and the adjusted
>> guest address width of the corresponding page-table structure.
>> (Adjusted guest address widths supported by hardware are reported
>> through the SAGAW field)."
>>=20
>> This causes domain initialization to fail and following
>> errors appear for EHCI PCI driver:
>>=20
>> [    2.486393] ehci-pci 0000:01:00.4: EHCI Host Controller
>> [    2.486624] ehci-pci 0000:01:00.4: new USB bus registered, =
assigned bus
>> number 1
>> [    2.489127] ehci-pci 0000:01:00.4: DMAR: Allocating domain failed
>> [    2.489350] ehci-pci 0000:01:00.4: DMAR: 32bit DMA uses =
non-identity
>> mapping
>> [    2.489359] ehci-pci 0000:01:00.4: can't setup: -12
>> [    2.489531] ehci-pci 0000:01:00.4: USB bus 1 deregistered
>> [    2.490023] ehci-pci 0000:01:00.4: init 0000:01:00.4 fail, -12
>> [    2.490358] ehci-pci: probe of 0000:01:00.4 failed with error -12
>>=20
>> This issue happens when the value of the sagaw corresponds to a
>> 48-bit agaw. This fix updates the calculation of the agaw based on
>> the minimum of IOMMU's sagaw value and MGAW.
>>=20
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>> Tested-by: Camille Lu <camille.lu@hpe.com>
>> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
>=20
> What is the git commit id of this patch in Linus's tree?
>=20
> thanks,
>=20
> greg k-h

