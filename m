Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE9226AFC1
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 23:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgIOVlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 17:41:46 -0400
Received: from mail-bn8nam12on2106.outbound.protection.outlook.com ([40.107.237.106]:50336
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728135AbgIOVc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 17:32:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clgcA8Iuj6mWO/RFrwng+7osSgYRlKBMmhfri2eqjpUrNlSCOg8JxCWTQSfhkqcAfFMR3gOQQbZcv+oOJR3oqT2vPo00qPho/kL3baOi6E/oj0fMkHTH9GGEmWvCTsXytT2aiBB6/R3PgVaoJkwVg0UJPpB+M8OZv3Ji4plZhAa14LjeI0zqfq/Qq6yN8/tVpBh5P39aHrv+vhyYOhR+8ZM/k7n29uYd6puJ8Ofhl/iV5x3f5hv+o+33obeXg02oycTOcsvVT21PWT3j2IlLHShCWnDaQhniTMbyl50QxayKCTOgIRaR40Aem0FHYi/k/JaZvoEHzGbaFbF7fTaV6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUVQl//V8ANAUi+NJzjWQtRn1mzsm7eGW59CCyPuRHo=;
 b=K96e0wQ/kyY/DRqRnaYcJGQjqSa5Vfv3CMI0OfgH4BPnSEFUsTKx9KS3LeDb9HPIpBhprF+DeMSUHJtR+xxDj9ojIxzOgwB+ZggVvZZZOiV5K7jeuJ6Uhvv7FotpPndmqYEHbBYzpNRvO0yQ0aUAeKo9ub1h8E6w2RHfLivKuoXytCpnOzoCVJf9o9/807YI2KSJbW/di2NJKqU2IhymzSla50LyBu5Fh91m704kHvtkNN/bXGikWZl26uWStCRUexNRb28FG/qObJhEdXCXIhGd+kHsEfWbx/bh0xPVFnxIGqoyCZyqXDLCmq7qfF0TAf4taW4HDmnFvZ+cEROsyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUVQl//V8ANAUi+NJzjWQtRn1mzsm7eGW59CCyPuRHo=;
 b=NAv2CS1yo+V7T/EsYvmevjwPNjTCzGshYPOO1ALvdG4GnlP9vhq/cfVSgubMkPJxY9+crHKUXLGenvN/3hyokc2lBW0gdQSkzt33CSJcVzIy6KLecYK6H+/Zdyzvg21nom/jGGkSBxi2M2SuBkW0eDEZLBKsbPUAfcjCGgD05ss=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=os.amperecomputing.com;
Received: from DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17) by
 DM6PR01MB5516.prod.exchangelabs.com (2603:10b6:5:153::22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Tue, 15 Sep 2020 21:31:15 +0000
Received: from DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b]) by DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 21:31:15 +0000
From:   "John L. Villalovos" <jlvillal@os.amperecomputing.com>
To:     stable@vger.kernel.org
Cc:     "John L. Villalovos" <jlvillal@os.amperecomputing.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 4/5] usb: don't create dma pools for HCDs with a localmem_pool
Date:   Tue, 15 Sep 2020 14:30:38 -0700
Message-Id: <20200915213039.862123-5-jlvillal@os.amperecomputing.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
References: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY4PR14CA0040.namprd14.prod.outlook.com
 (2603:10b6:903:101::26) To DM6PR01MB5802.prod.exchangelabs.com
 (2603:10b6:5:203::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (4.28.12.214) by CY4PR14CA0040.namprd14.prod.outlook.com (2603:10b6:903:101::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 21:31:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [4.28.12.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55ff969e-d5e2-4e16-9438-08d859beaca8
X-MS-TrafficTypeDiagnostic: DM6PR01MB5516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR01MB5516B4511DEB6F901942575FED200@DM6PR01MB5516.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MjPmsCcmP2ychsfL1sCi0LAlZWV1wV+X2ssWwYTEz+2eDYr/xIrPz3OB2UkJwzqtRdmgDNFKQ34HOvCFRG6a+ynBYplePfdtfcsBWxFK6Rvn+2QRh+m6PuUJ+G3xVVmuH4/G1rPAxxWL/tJvea4nh2srupi98tHAz3dtvEnNcmh2R6a5F7hLP1Cz6Br+GEMc3efz7CeHrN58FjZfrejJez2aMFBwgsg9oYNZ8c+Jx5x13Oz/1t7N5vDP0IbgOgEIwdKs6l7G2Hg80MrREOnj/dS9J4mFvExUbE/bpay/h4Tu3el9PuIlqVS9yQD6nJom/SrPF+rwpviJpnb96VfHp+cjA6OSaD2QRg3PJOKxGG5zAZhKYFTFzfej89rxgJIuY9mENejmKpojTCjzdDhhBdLFuFnMj5JZutJIgKRnG4ERX4tGMrk617Lhl945E1ntqjEJixmqpbUpbcaQ1aAY+sBb+gYqMppxArpnPoBPfLMFLcYaSMcTCjQe5JafbCG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB5802.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39850400004)(83380400001)(6512007)(8936002)(316002)(66946007)(16526019)(8676002)(4326008)(2616005)(6486002)(956004)(26005)(186003)(1076003)(54906003)(6666004)(6506007)(966005)(478600001)(5660300002)(86362001)(2906002)(66476007)(69590400008)(66556008)(52116002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9GuCbPqokVKvwknGmg39aKe3BkY9+QgZ9IgJ7pEbZv1CTH7XKDol/yHdaml00cdWLz7Ixu78al5nP/9nrloFdfdglVRK9m2+GHeXwSC1q3O2ZulhjXhlM810V2kUyLGHcbKvm8tjWdqul9vYz4VAb7Lxg8zkW3GXhIQZlldSsUg7ai+YbRBJHa/k0ke93ph8z8IAiUlVrAKm2Q2NsGLYhJUSyt3cLDoHFVpn943bYiREsNt5AZ1XWUNGdDg3bYz46arNyXAdBpPnrls426ApVYZLF8aWSCmtAMsYy++zTAcLFBakQG5jxRh7vcEDkb0+HaEQ9dfUSNHWIWuTNrg/QthmN+mJaN1nagAyidyuayWm33enpB7UO4kM+lsb+ZwJjeFSfspsqxqJ5K2egLBuRtvU6fDzMcYgXpN2KKg7PYDUCVpxdcRlrF0JTjqm8/y4JUcMT8jhaFCAo3dwthlHqO4eaKyXd0R0Lc8WnfrGEamCEQ7sYkIIA9YkBugKGi80OMpqQernsQvjdHlGVRJj0ORwlWw/GHCWnU6EsK8cDx9lHtI4DNPRma8yUm39Gpxb/4PQ2f+cJOjscTG6nA9nMLVh1QMmKMDrV32Q54SzdSoIERXD3SSrfzWefrBEwKSUz8rd+38/Zak0PIYmkTUypg==
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ff969e-d5e2-4e16-9438-08d859beaca8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB5802.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:31:15.0171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xz1gQyq4XIbKSrdxujzvPYLgNLg/9kOiZi13Xf0xkKqh+m6NU5T14ZLnxICjjw6f4aiaZul7MNddEfDiGiQcwLrBL3b+VQXJAMKvJkPDp67dlmd9J/pv9ryeWVE67kqk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5516
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit dd3ecf17ba70a70d2c9ef9ba725281b84f8eef12 upstream.

If the HCD provides a localmem pool we will never use the DMA pools, so
don't create them.

Fixes: b0310c2f09bb ("USB: use genalloc for USB HCs with local memory")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20190811080520.21712-2-hch@lst.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: John L. Villalovos <jlvillal@os.amperecomputing.com>
---
 drivers/usb/core/buffer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index d93e25aeaf96..8f1697bcc170 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -66,9 +66,9 @@ int hcd_buffer_create(struct usb_hcd *hcd)
 	char		name[16];
 	int		i, size;
 
-	if (!IS_ENABLED(CONFIG_HAS_DMA) ||
-	    (!is_device_dma_capable(hcd->self.sysdev) &&
-	     !hcd->localmem_pool))
+	if (hcd->localmem_pool ||
+	    !IS_ENABLED(CONFIG_HAS_DMA) ||
+	    !is_device_dma_capable(hcd->self.sysdev))
 		return 0;
 
 	for (i = 0; i < HCD_BUFFER_POOLS; i++) {
-- 
2.26.2

