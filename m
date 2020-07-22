Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7503C228E63
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 05:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbgGVDGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 23:06:53 -0400
Received: from mail-am6eur05hn2233.outbound.protection.outlook.com ([52.100.174.233]:42144
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731781AbgGVDGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 23:06:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LH0CPMzPRILDa86H5PjwRKF8tCsnX8r2YQTCfxu3pvNH+Fe8hs6bRpoW+K2vjXcHK9blk1ka+uMPbnzOEccxcyv2voTeSsMRJDrZhd9D1r2B+Z30Nkv/+h8rtVSeW8j/p9gKtjDjgP9EXs73NEMI4p33S+ezaoFShewdvFUknnwuR3EgoW6a1cqVtw0LUdJn+OjBUAhUelXBpR14FfPsp+b3Zl12xZGlUpvWHksuoUHC2kgC56vlDjB+9eC+0BLXs3YCVyNJUBhZh2+gyto3XbReygNoEDIjmypYjM0bCpVsa561FEt3pSSSRpDMzdIJ3L0snzvO5uKjyaQgAySlMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9dPd3C84+AH3ZrR6EwW8gSEEcu4EEl12599QsWdbmQ=;
 b=SP+Hs4twF2pGWICrVE9CPMd5BPdhnvolGEmeeXSi2RkA6ok0ivarIG9niQUs6+25S3jz5IudnuWMYq8JDPFWO1FZs4Kb05avSTQGid/Ek5AW3A1mfwuUAeHlO2j3dPUYm/GD7qnQEn812PVsxNdQ7K+puJNo+sI1r5XhxdDCxS2kXzHV75k6ZhdFebyXmx34nKbCSbvYJwTPRXAm+PLtltG4arQkCjUto+GC3lkguL7gAdemCFQf+7FpnE1k7xAA2v9G3x0vUZydaACqmpcbA49pmgV5YYxWKVmHd3LB6H1z6AyVlknvhb1aChLHxIHvoUAosrVtaa8A6PBlJq1uxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9dPd3C84+AH3ZrR6EwW8gSEEcu4EEl12599QsWdbmQ=;
 b=Y9/FGulpWEMkYvUAeeqVS1TMa+SlEY4dX3lCd/8311tRHZly3dekRPu2NtpfXXHjRsG4y+g5r8HGSuNdqDI7qj4aQf+31TzqWjrMvCdaNMmEKrF88sRxSELyfixatqbOLQvm+xTJPJ5rDzso1+wUcgctfm3SrPAzhl9/dcsolpk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM5PR0402MB2738.eurprd04.prod.outlook.com (2603:10a6:203:97::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Wed, 22 Jul
 2020 03:06:48 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3195.027; Wed, 22 Jul 2020
 03:06:48 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, jun.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/1] usb: cdns3: gadget: always zeroed TRB buffer when enable endpoint
Date:   Wed, 22 Jul 2020 11:06:19 +0800
Message-Id: <20200722030619.14344-1-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0220.apcprd06.prod.outlook.com
 (2603:1096:4:68::28) To AM7PR04MB7157.eurprd04.prod.outlook.com
 (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.67) by SG2PR06CA0220.apcprd06.prod.outlook.com (2603:1096:4:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.19 via Frontend Transport; Wed, 22 Jul 2020 03:06:45 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fdb8dc71-2ea4-42d9-c8d4-08d82dec4618
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2738:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0402MB27388FB32910ED82579DDC158B790@AM5PR0402MB2738.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HS9KfxJMJ0TWMRizFOR2vyQXzXfDI5VJUDpiSwDTcm0Z4FYkkfK+JYx4UaWfihOEgB0n9zgd1fwZqVVbbaCvISOYWaLeMXTC7AEKPxZvC+1qL2irHOU9nhWB47d+wb+wU3jkApDgHxOxocu1XUGh9crO6nfBedksJ/HYCg1O0ySgVUhanXxB9tYkQlUet3unKx6QYC2zQbteJdKgkG7iHvPNs/1BJBjBVsXKAAXYGiWm17vps5Y6A9QVTqtY24TpbUzXHAYJbdVITu3+dPX5fPWuLIR3E7kuDHN2K/C7xA+Z7RQxzaVCswd9jm+AubTl84rPhGgDBG4hOneu61aUv3FbDGQoVuk6DlpVPjSZp+b/2MLsl76GHtcA/RVXsnntleKZI2W8slBFwR1GawFIXZfxDA1BdkS3MoSBQZjMFIWA3FIpHZOy1mSPpmFxnoRsbwbde4WvWJamqv9qXHYcx/3jTqJ7AOJbqaZcrlnMBR7VY/A1ZVp/msXyc10szOZV4zQtDbG9IrIgy9DK5rUnQ9b9eTsskF0NKzj7aH93Owmchen+82ge/mvnQTA4B1ETPq10CwSoEYHfGkTcia9PTGlkNCa6XhcmV9aUcfEcJa0X1gMrmtTGYWYlMzRSfgRiUIPMmq9LF1dCM3EVCxbqVUwZrnM0IMMOuICbVbKYWJ288xgtvjI67ck/e69Z3sPKF4XrrSXoGMF6qvb2H4qyGWnN5O0ABqI1lrrHYuaWgvs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(6486002)(6512007)(26005)(186003)(44832011)(86362001)(956004)(2616005)(16526019)(2906002)(54906003)(8676002)(4326008)(8936002)(6506007)(478600001)(52116002)(316002)(66476007)(66946007)(66556008)(6666004)(1076003)(83380400001)(36756003)(5660300002)(46570200004)(414714003)(473944003);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: FPwqMncedDQqH9hSbTZOKdAhuV4+nRH6bmYVhS9q3blqfB6bXonKslBKXTPHPJwJUZN9RpVvLlp6XH/PRQOBKYDcHyQsPhFalRjFcrvn7Ra5EVTqvt6wkPI3HDQqTheabBxVYyqkbwkdSWRFAfue+o4oiDyNUOn/uYm18BHZquik432q7voXsB6SKwfdknxzNmJW5MMnnPm/yfGFZkFakWZrXkRim3iKCxjm9CxjWp4Vt54YdXqQVAcd8t9pWVy5l9JNFDEJB423usv7CY3EjqxIJTeAHQjk4jeknO89aGD0dclC7gXa8kONEH1B/+IsZuKNeGGDnHAU4B/pyE7Rxpv6aeg+f3yJ3RC1JeYKrcNKGoNc/2VyZavK3yto6Ccf9NEQZfTcHg5T4Uh2KtMKMH2FpUDzcX4n/lvi8OSDnIbFtLlSigNOKQnGtQVd/Whm+vziwXVcpfxDOSyLNKAQEXOVoxdEPamk2JpWWsDWE36qdp5XCH+lj8jSJwscJMJM
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb8dc71-2ea4-42d9-c8d4-08d82dec4618
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7157.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 03:06:48.5890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XeKafjRsrzlUQcd4w8fkzHXVmOZBPokE+fhSqO0FLh0FPCUlsn1YNILFtHWvq5BSFsd9s5fw7bnHmEzLxvRQwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2738
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During the endpoint dequeue operation, it changes dequeued TRB
as link TRB, when the endpoint is disabled and re-reabled, the
DMA fetches the TRB before the link TRB, after it handles current
TRB, the DMA pointer will advance to the TRB after link TRB,
but enqueue and dequene variables don't know it due to no hardware
interrupt at the time, when the next TRB is added to link TRB
position, the DMA will not handle this TRB due to its pointer
is already at the next TRB. See the trace log like below:

file-storage-675   [001] d..1    86.585657: usb_ep_queue: ep0: req 00000000df9b3a4f length 0/0 sgs 0/0 stream 0 zsI status 0 --> 0
file-storage-675   [001] d..1    86.585663: cdns3_ep_queue: ep1out: req: 000000002ebce364, req buff 00000000f5bc96b4, length: 0/1024 zsi, status: -115, trb: [start:0, end:0: virt addr (null)], flags:0 SID: 0
file-storage-675   [001] d..1    86.585671: cdns3_prepare_trb: ep1out: trb 000000007f770303, dma buf: 0xbd195800, size: 1024, burst: 128 ctrl: 0x00000425 (C=1, T=0, ISP, IOC, Normal) SID:0 LAST_SID:0
file-storage-675   [001] d..1    86.585676: cdns3_ring:
            Ring contents for ep1out:
            Ring deq index: 0, trb: 000000007f770303 (virt), 0xc4003000 (dma)
            Ring enq index: 1, trb: 0000000049c1ba21 (virt), 0xc400300c (dma)
            free trbs: 38, CCS=1, PCS=1
            @0x00000000c4003000 bd195800 80020400 00000425
            @0x00000000c400300c c4003018 80020400 00001811
            @0x00000000c4003018 bcfcc000 0000001f 00000426
            @0x00000000c4003024 bcfce800 0000001f 00000426

	    ...

 irq/144-5b13000-698   [000] d...    87.619286: usb_gadget_giveback_request: ep1in: req 0000000031b832eb length 13/13 sgs 0/0 stream 0 zsI status 0 --> 0
    file-storage-675   [001] d..1    87.619287: cdns3_ep_queue: ep1out: req: 000000002ebce364, req buff 00000000f5bc96b4, length: 0/1024 zsi, status: -115, trb: [start:0, end:0: virt addr 0x80020400c400300c], flags:0 SID: 0
    file-storage-675   [001] d..1    87.619294: cdns3_prepare_trb: ep1out: trb 0000000049c1ba21, dma buf: 0xbd198000, size: 1024, burst: 128 ctrl: 0x00000425 (C=1, T=0, ISP, IOC, Normal) SID:0 LAST_SID:0
    file-storage-675   [001] d..1    87.619297: cdns3_ring:
                Ring contents for ep1out:
                Ring deq index: 1, trb: 0000000049c1ba21 (virt), 0xc400300c (dma)
                Ring enq index: 2, trb: 0000000059b34b67 (virt), 0xc4003018 (dma)
                free trbs: 38, CCS=1, PCS=1
                @0x00000000c4003000 bd195800 0000001f 00000427
                @0x00000000c400300c bd198000 80020400 00000425
                @0x00000000c4003018 bcfcc000 0000001f 00000426
                @0x00000000c4003024 bcfce800 0000001f 00000426
		...

    file-storage-675   [001] d..1    87.619305: cdns3_doorbell_epx: ep1out, ep_trbaddr c4003018
    file-storage-675   [001] ....    87.619308: usb_ep_queue: ep1out: req 000000002ebce364 length 0/1024 sgs 0/0 stream 0 zsI status -115 --> 0
 irq/144-5b13000-698   [000] d..1    87.619315: cdns3_epx_irq: IRQ for ep1out: 01000c80 TRBERR , ep_traddr: c4003018 ep_last_sid: 00000000 use_streams: 0
 irq/144-5b13000-698   [000] d..1    87.619395: cdns3_usb_irq: IRQ 00000008 = Hot Reset

Fixes: f616c3bda47e ("usb: cdns3: Fix dequeue implementation")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 542a7baf3da8..8384b86363fd 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -242,9 +242,10 @@ int cdns3_allocate_trb_pool(struct cdns3_endpoint *priv_ep)
 			return -ENOMEM;
 
 		priv_ep->alloc_ring_size = ring_size;
-		memset(priv_ep->trb_pool, 0, ring_size);
 	}
 
+	memset(priv_ep->trb_pool, 0, ring_size);
+
 	priv_ep->num_trbs = num_trbs;
 
 	if (!priv_ep->num)
-- 
2.17.1

