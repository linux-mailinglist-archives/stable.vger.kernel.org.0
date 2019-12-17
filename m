Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40831233FA
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 18:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfLQRzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 12:55:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21856 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726722AbfLQRzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 12:55:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576605351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=M7e6SsR0adMoPhT0GmsplLfMKmkYiVgsu5hzgKJZohY=;
        b=AhuUgZJhEzimekP0pmoSt80awz8sdQ/lEXsAsWG7Ci69BS/l8qJfZZH68DuR+L4qGZaadl
        qQv8I0ek3QECHFTxSjf3yyJvDfUnMeem2sNVYZM+55jUJi9mlE0N3wRwqrIuz6JfHyAYcI
        Wwi/lpfcbv3Re4YuUpK3Jw5zj68PKrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-L6si89IqOXGqVPyM0K9y6A-1; Tue, 17 Dec 2019 12:55:49 -0500
X-MC-Unique: L6si89IqOXGqVPyM0K9y6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26415107ACC5;
        Tue, 17 Dec 2019 17:55:48 +0000 (UTC)
Received: from cantor.redhat.com (ovpn-116-112.phx2.redhat.com [10.3.116.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9C542657B;
        Tue, 17 Dec 2019 17:55:47 +0000 (UTC)
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [RFC PATCH] iommu/vt-d: avoid panic in __dmar_remove_one_dev_info
Date:   Tue, 17 Dec 2019 10:55:42 -0700
Message-Id: <20191217175542.22187-1-jsnitsel@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In addition to checking for a null pointer, verify that
info does not have the value DEFER_DEVICE_DOMAIN_INFO or
DUMMY_DEVICE_DOMAIN_INFO. If info has one of those values
__dmar_remove_one_dev_info will panic when trying to access
a member of the device_domain_info struct.

    [    1.464241] BUG: unable to handle kernel NULL pointer dereference =
at 000000000000004e
    [    1.464241] PGD 0 P4D 0
    [    1.464241] Oops: 0000 [#1] SMP PTI
    [    1.464241] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W     =
   --------- -  - 4.18.0-160.el8.x86_64 #1
    [    1.464241] Hardware name: HP ProLiant DL360 Gen9/ProLiant DL360 G=
en9, BIOS P89 07/21/2019
    [    1.464241] RIP: 0010:__dmar_remove_one_dev_info+0x27/0x250
    [    1.464241] Code: 00 00 00 0f 1f 44 00 00 8b 05 35 ec 75 01 41 56 =
41 55 41 54 55 53 85 c0 0f 84 99 01 00 00 48 85 ff 0f 84 92 01 00 00 48 8=
9 fb <4c> 8b 67 50 48 8b 6f 58 $
    [    1.464241] RSP: 0000:ffffc900000dfd10 EFLAGS: 00010082
    [    1.464241] RAX: 0000000000000001 RBX: fffffffffffffffe RCX: 00000=
00000000000
    [    1.464241] RDX: 0000000000000001 RSI: 0000000000000004 RDI: fffff=
ffffffffffe
    [    1.464241] RBP: ffff88ec7a72f368 R08: 0000000000000457 R09: 00000=
00000000039
    [    1.464241] R10: 0000000000000000 R11: ffffc900000dfa58 R12: ffff8=
8ec7a0eec20
    [    1.464241] R13: ffff88ec6fd0eab0 R14: ffffffff81eae980 R15: 00000=
00000000000
    [    1.464241] FS:  0000000000000000(0000) GS:ffff88ec7a600000(0000) =
knlGS:0000000000000000
    [    1.464241] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [    1.464241] CR2: 000000000000004e CR3: 0000006c7900a001 C 00000000=
001606b0
    [    1.464241] Call Trace:
    [    1.464241]  dmar_remove_one_dev_info.isra.68+0x27/0x40
    [    1.464241]  intel_iommu_add_device+0x124/0x180
    [    1.464241]  ? iommu_probe_device+0x40/0x40
    [    1.464241]  add_iommu_group+0xa/0x20
    [    1.464241]  bus_for_each_dev+0x77/0xc0
    [    1.464241]  ? down_write+0xe/0x40
    [    1.464241]  bus_set_iommu+0x85/0xc0
    [    1.464241]  intel_iommu_init+0x4b4/0x777
    [    1.464241]  ? e820__memblock_setup+0x63/0x63
    [    1.464241]  ? do_early_param+0x91/0x91
    [    1.464241]  pci_iommu_init+0x19/0x45
    [    1.464241]  do_one_initcall+0x46/0x1c3
    [    1.464241]  ? do_early_param+0x91/0x91
    [    1.464241]  kernel_init_freeable+0x1af/0x258
    [    1.464241]  ? rest_init+0xaa/0xaa
    [    1.464241]  kernel_init+0xa/0x107
    [    1.464241]  ret_from_fork+0x35/0x40
    [    1.464241] Modules linked in:
    [    1.464241] CR2: 000000000000004e
    [    1.464241] ---[ end trace 0927d2ba8b8032b5 ]---

Cc: Joerg Roedel <jroedel@suse.de>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org # v5.3+
Cc: iommu@lists.linux-foundation.org
Fixes: ae23bfb68f28 ("iommu/vt-d: Detach domain before using a private on=
e")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 drivers/iommu/intel-iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0c8d81f56a30..e42a09794fa2 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5163,7 +5163,8 @@ static void dmar_remove_one_dev_info(struct device =
*dev)
=20
 	spin_lock_irqsave(&device_domain_lock, flags);
 	info =3D dev->archdata.iommu;
-	if (info)
+	if (info && info !=3D DEFER_DEVICE_DOMAIN_INFO
+	    && info !=3D DUMMY_DEVICE_DOMAIN_INFO)
 		__dmar_remove_one_dev_info(info);
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
--=20
2.24.0

