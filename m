Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B41DEE3F
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 15:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfJUNq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 09:46:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41660 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbfJUNqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 09:46:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LDSu0p179215;
        Mon, 21 Oct 2019 13:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : content-type :
 content-transfer-encoding : mime-version : date : subject : cc : to :
 message-id; s=corp-2019-08-05;
 bh=Cy8Dlu67CBjukbNmy8R9+NMFhKiiEygsg17vJuV+4Us=;
 b=ChN7EQdkUOAeqbySmaqCDG3/tX6MfpeWYZuyClNoSQY0KwiLvuQtO0obr/WAdLRUjcxW
 DTZXeMB7WUUJXvOgVfH6rVfwRrvhUgsjAgTRd2nbui4i3fKA+elOEQlQoQWERsvj8PgW
 Nca0KvfV3TPzdiRe937BtbD4qI4YEpcekAXSR3dff1d0LagctRZ2lptBP0RgO0XL51cR
 WSVDH2Zj+Qzu3u4O2PutoDEbuOWoj8632OyxsV1A65Y6Vh8Qi8UmOucWC0+KduPKNrxt
 D4it9s1cix+DoxU2u23dR8W+VtvlvUd544kuXeT8z9XoMcSFJ9Png/IMgIajWwOZBGya dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqtepfrps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 13:46:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LDSIWp133273;
        Mon, 21 Oct 2019 13:46:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vsakb5hm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 13:46:50 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9LDknxw014832;
        Mon, 21 Oct 2019 13:46:49 GMT
Received: from dhcp-10-154-105-47.vpn.oracle.com (/10.154.105.47)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 06:46:49 -0700
From:   John Donnelly <john.p.donnelly@oracle.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Date:   Mon, 21 Oct 2019 08:46:46 -0500
Subject: [PATCH v2 ] iommu/vt-d: Fix panic after kexec -p for kdump
Cc:     joro@8bytes.org, Lu Baolu <baolu.lu@linux.intel.com>,
        stable@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Message-Id: <0A14CFDC-E2E3-4FB2-B41A-B7BD3F82A975@oracle.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9416 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=857
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9416 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=941 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210130
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This cures a panic on restart after a kexec -p operation on 5.3 and 5.4 =
kernels.

Fixes: 8af46c784ecfe ("iommu/vt-d: Implement is_attach_deferred iommu =
ops entry")

The underlying state of the iommu registers (iommu->flags &
VTD_FLAG_TRANS_PRE_ENABLED) on a restart results in a domain being =
marked as
"DEFER_DEVICE_DOMAIN_INFO" that produces an Oops in identity_mapping().

[   43.654737] BUG: kernel NULL pointer dereference, address:
0000000000000056
[   43.655720] #PF: supervisor read access in kernel mode
[   43.655720] #PF: error_code(0x0000) - not-present page
[   43.655720] PGD 0 P4D 0
[   43.655720] Oops: 0000 [#1] SMP PTI
[   43.655720] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
5.3.2-1940.el8uek.x86_64 #1
[   43.655720] Hardware name: Oracle Corporation ORACLE SERVER
X5-2/ASM,MOTHERBOARD,1U, BIOS 30140300 09/20/2018
[   43.655720] RIP: 0010:iommu_need_mapping+0x29/0xd0
[   43.655720] Code: 00 0f 1f 44 00 00 48 8b 97 70 02 00 00 48 83 fa ff
74 53 48 8d 4a ff b8 01 00 00 00 48 83 f9 fd 76 01 c3 48 8b 35 7f 58 e0
01 <48> 39 72 58 75 f2 55 48 89 e5 41 54 53 48 8b 87 28 02 00 00 4c 8b
[   43.655720] RSP: 0018:ffffc9000001b9b0 EFLAGS: 00010246
[   43.655720] RAX: 0000000000000001 RBX: 0000000000001000 RCX:
fffffffffffffffd
[   43.655720] RDX: fffffffffffffffe RSI: ffff8880719b8000 RDI:
ffff8880477460b0
[   43.655720] RBP: ffffc9000001b9e8 R08: 0000000000000000 R09:
ffff888047c01700
[   43.655720] R10: 00002194036fc692 R11: 0000000000000000 R12:
0000000000000000
[   43.655720] R13: ffff8880477460b0 R14: 0000000000000cc0 R15:
ffff888072d2b558
[   43.655720] FS:  0000000000000000(0000) GS:ffff888071c00000(0000)
knlGS:0000000000000000
[   43.655720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.655720] CR2: 0000000000000056 CR3: 000000007440a002 CR4:
00000000001606b0
[   43.655720] Call Trace:
[   43.655720]  ? intel_alloc_coherent+0x2a/0x180
[   43.655720]  ? __schedule+0x2c2/0x650
[   43.655720]  dma_alloc_attrs+0x8c/0xd0
[   43.655720]  dma_pool_alloc+0xdf/0x200
[   43.655720]  ehci_qh_alloc+0x58/0x130
[   43.655720]  ehci_setup+0x287/0x7ba
[   43.655720]  ? _dev_info+0x6c/0x83
[   43.655720]  ehci_pci_setup+0x91/0x436
[   43.655720]  usb_add_hcd.cold.48+0x1d4/0x754
[   43.655720]  usb_hcd_pci_probe+0x2bc/0x3f0
[   43.655720]  ehci_pci_probe+0x39/0x40
[   43.655720]  local_pci_probe+0x47/0x80
[   43.655720]  pci_device_probe+0xff/0x1b0
[   43.655720]  really_probe+0xf5/0x3a0
[   43.655720]  driver_probe_device+0xbb/0x100
[   43.655720]  device_driver_attach+0x58/0x60
[   43.655720]  __driver_attach+0x8f/0x150
[   43.655720]  ? device_driver_attach+0x60/0x60
[   43.655720]  bus_for_each_dev+0x74/0xb0
[   43.655720]  driver_attach+0x1e/0x20
[   43.655720]  bus_add_driver+0x151/0x1f0
[   43.655720]  ? ehci_hcd_init+0xb2/0xb2
[   43.655720]  ? do_early_param+0x95/0x95
[   43.655720]  driver_register+0x70/0xc0
[   43.655720]  ? ehci_hcd_init+0xb2/0xb2
[   43.655720]  __pci_register_driver+0x57/0x60
[   43.655720]  ehci_pci_init+0x6a/0x6c
[   43.655720]  do_one_initcall+0x4a/0x1fa
[   43.655720]  ? do_early_param+0x95/0x95
[   43.655720]  kernel_init_freeable+0x1bd/0x262
[   43.655720]  ? rest_init+0xb0/0xb0
[   43.655720]  kernel_init+0xe/0x110
[   43.655720]  ret_from_fork+0x24/0x50
=20

Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>


---
 drivers/iommu/intel-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c4e0e4a9ee9e..f83a9a302f8e 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2783,7 +2783,7 @@ static int identity_mapping(struct device *dev)
 	struct device_domain_info *info;
=20
 	info =3D dev->archdata.iommu;
-	if (info && info !=3D DUMMY_DEVICE_DOMAIN_INFO)
+	if (info && info !=3D DUMMY_DEVICE_DOMAIN_INFO && info !=3D =
DEFER_DEVICE_DOMAIN_INFO)
 		return (info->domain =3D=3D si_domain);
=20
 	return 0;
--=20
2.20.1=
