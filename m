Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7232913AB9A
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 14:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgANN7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 08:59:53 -0500
Received: from mail-vi1eur05on2101.outbound.protection.outlook.com ([40.107.21.101]:3745
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727285AbgANN7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 08:59:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSyG36ZQDrxyHiDm5k5bR9jJCp3f4PZNJ1TWRmqsIZtLBqYJt+PqFhnsbCqmL3XMm6SOnIWWitm/OQuO3LSWVso1V+GrdWVzjaCyqQEDLJw/G9yiLM1xSCPTh+isx89Jt3aiTDuKW53RJqpedbjo5rwu7rLI3KKe6D7TnhGcjpBCtiFkeQHXQJom7niGWAqIdIgr++GD/aqm+1dYqmd3Dt/ewPD6X2NKVvVGCb20fSTjXm/Ie7CG4M5j7EGo66Qm2cm9wfWuyi9aBuQTNiXDus1OWObJTdgulFYj+riT5usixY/UpwYb62ypdlir/sj/ILnu13Av/Q5SPuVHjk0zqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DWqM+nIiyToc6tqulDetCnmws2igtNY24BaqWBt1SI=;
 b=b37tlS+1CzKqfMm3VmaNwuHo3K2QlM7p7l5DtpqsyZvSa3dp5CUXsWxaSteu6i1wGkZAIMii90xCW+5RIGuHPHBfWz3PwSBQlYDLhOTAzg4xqN4an4wcRiWHN5wPgua8I5tXgGyaioASG9n7+hZjrCwGTitBtZW9fOdvgoeIfAJdWRxJSCa524fAAPZkzu/rjaJ3bZpZJdRFtUrSFUrcKpcmQFe6yN2HI9zthMmJTdMvR1WiTr4Bw6sCW6402AVB2LiPRxWjZGYlWpLJIbHtDACcYL+HEwz/TrtW2H8BETK3T+gmySGbeRk5kC51BH6ZGmO2ib5NQYtK5VqwlHAK+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DWqM+nIiyToc6tqulDetCnmws2igtNY24BaqWBt1SI=;
 b=m3SLeKrZXAVExsVsROuysx3KfKg1Z3FJSfY+Jfrr6Mzxj9eHLXPkijXT4xT5Gn3Bpg02iyfoCcjpYvEp1gG7ROLXH0t2zWh0bWqm96SHKDSUE2mzua/NBHch7g/207MNTHM0LwLWz0UxfkKscVohL7Wbf90gTRCW6Ajgtg9JsdY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB3358.eurprd07.prod.outlook.com (10.175.243.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.10; Tue, 14 Jan 2020 13:59:49 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e%2]) with mapi id 15.20.2644.015; Tue, 14 Jan 2020
 13:59:49 +0000
From:   Alexander X Sverdlin <alexander.sverdlin@nokia.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] rapidio/mport_cdev: Fix race in mport_cdev_release()
Date:   Tue, 14 Jan 2020 14:59:36 +0100
Message-Id: <20200114135936.4800-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.24.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR05CA0132.eurprd05.prod.outlook.com
 (2603:10a6:7:28::19) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
MIME-Version: 1.0
Received: from ulegcpsvdell.emea.nsn-net.net (131.228.32.181) by HE1PR05CA0132.eurprd05.prod.outlook.com (2603:10a6:7:28::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.11 via Frontend Transport; Tue, 14 Jan 2020 13:59:48 +0000
X-Mailer: git-send-email 2.24.0
X-Originating-IP: [131.228.32.181]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 816ee973-7eaa-472b-dcff-08d798fa050b
X-MS-TrafficTypeDiagnostic: VI1PR07MB3358:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB335819C0E3D121C7ADB4C25A88340@VI1PR07MB3358.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 028256169F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(199004)(189003)(6666004)(66946007)(66556008)(2616005)(54906003)(86362001)(66476007)(956004)(52116002)(16526019)(5660300002)(316002)(186003)(26005)(6506007)(8936002)(6916009)(6512007)(2906002)(4326008)(478600001)(81166006)(81156014)(8676002)(6486002)(1076003)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB3358;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZW9kXgHlWt/586W4qWlTNBacK8bDEHpNHo1+9jgZaP8cqd4TLXeiJje6dN7Mczxf27CRuuOQHEtbsqW7MCCYC8HwxuP6AkaWWwF6k36SakgOFhySJABMSe6YDrtLZPRAP3Z0J+0dPoyoKk9h6+ErASIT7nlO/EA4ne1rIzwkjMvAQRnO56XoMRqC98JYKUvXbYAGV/nVOkpqa2CJf9DxvEyE6FZacezRjV4kPNHUhELxJ8KObXQOMtL8hQnYNVpZt2nZzH4eHGCHTUdvzinjJ5+obCFwrT2tTHkk+KbdB5cdYnTzoAFEIqLi3SFq+mkEtAJY1F00wsJInwAHQaRtQLA2/8drD9UPXOcEXwaWWKdA2CIFObQVWsMLC+gdnERSzZRsXpxE5qKQY3HPvdzbezSS1FqNBtKQyuvhsmIsMxDGxVF3cZ7et2mVpNTmkvB
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816ee973-7eaa-472b-dcff-08d798fa050b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2020 13:59:49.1843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eEskwZo2e8GBdTdIMliI2sOYsAl/kff3tHRD/W9DZUawNI/onQp+KjacKyUFC1+35dzv47jeYDKngOpbubEBWtZ3tPkhNrBRoq2o1RJsVPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB3358
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

While get_dma_channel() is protected against concurrent calls, there is a
race against kref_put() in mport_cdev_release():

CPU0                                        CPU1

get_dma_channel()
 kref_init(&priv->md->dma_ref);
 ...
mport_cdev_release_dma()
 kref_put(&md->dma_ref,
          mport_release_def_dma);
                                            get_dma_channel()
                                             if (priv->md->dma_chan) {
                                              ...
                                              kref_get(&priv->md->dma_ref);
  mport_release_def_dma()
   md->dma_chan = NULL;

which may appear like this:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 12057 at .../linux/include/linux/kref.h:46 rio_dma_transfer.isra.12+0x8e0/0xbe8 [rio_mport_cdev]
 ...
CPU: 1 PID: 12057 Comm: ... Tainted: G           O    4.9.109-... #1
Stack : ...

Call Trace:
[<ffffffff80140040>] show_stack+0x90/0xb0
[<ffffffff803eeeb8>] dump_stack+0x88/0xc0
[<ffffffff80159670>] __warn+0x108/0x120
[<ffffffffc0541df0>] rio_dma_transfer.isra.12+0x8e0/0xbe8 [rio_mport_cdev]
[<ffffffffc05426fc>] mport_cdev_ioctl+0x604/0x2988 [rio_mport_cdev]
[<ffffffff802881e8>] do_vfs_ioctl+0xb8/0x780
[<ffffffff80288938>] SyS_ioctl+0x88/0xc0
[<ffffffff80146ae8>] syscall_common+0x34/0x58
---[ end trace 78842d4915cfc502 ]---

Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 8155f59..a6276dc 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1980,6 +1980,7 @@ static void mport_cdev_release_dma(struct file *filp)
 			current->comm, task_pid_nr(current), wret);
 	}
 
+	mutex_lock(&priv->dma_lock);
 	if (priv->dmach != priv->md->dma_chan) {
 		rmcd_debug(EXIT, "Release DMA channel for filp=%p %s(%d)",
 			   filp, current->comm, task_pid_nr(current));
@@ -1990,6 +1991,7 @@ static void mport_cdev_release_dma(struct file *filp)
 	}
 
 	priv->dmach = NULL;
+	mutex_unlock(&priv->dma_lock);
 }
 #else
 #define mport_cdev_release_dma(priv) do {} while (0)
-- 
2.4.6

