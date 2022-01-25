Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DB149ADE4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 09:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449688AbiAYITQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 03:19:16 -0500
Received: from mail-db8eur05on2106.outbound.protection.outlook.com ([40.107.20.106]:40449
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1449308AbiAYIRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 03:17:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR9jFwQaLyelMncKi80ae0kKPwrGgZUjbsle7qVfQI+Cs/3jUFyLX2iSBV9V9jAFGUnu5Pq7c6uhbM3ZHofQQJW8u4TO8FXuqvlWUUJl5D4uzRkMfJ2Iee3WF6GEfMVCz++5SOX7OEj64YqhX2xdEC9GSEYdWXtSpGWwa0bX5DKMptAVQgtmcyYRtohFRVrgPPHFIGcQTQZBPHrdSVB35sN119sjTdCWhnqp+gfN1/L+ihHNnfg3bF/MbDs0yZFjLk4DzowT9bY5wIvzJCKISKXK+a0ghpAM2ua82YhEvpE3/VX8S9EAidXl2ItWvhGarAKLpmkgeX5ItqRhzhL9XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whVvU1ebmTXM7amqvOY/ClpLpQyMQD7jtoiNX2DxdY4=;
 b=ClL9UXrw3UGzXlCWLUVwd4CSl37TFQJr9Sqe4AR46pz8MHhWrmNXtCSciEicoIMGD+KnlVnLZwu6KlfsTVRXxv+hwRSr2VkSGjp44CH3rvXix00mTYLPVCZUg0AiNjHSuSM+sPYIslgAJO0RHcdVyFbWspvgXJAfo8x7xPzMbvZzNAICAXDv3h1F3BNqAZRCmPlVObXldQiUE2CE6Rwv9XvovXfxUgUBIXzITWTB6NMKCwU3n3uVEykzq6/3aaDIUqxbLu4rUDJ2OCpqPjpJj8CHv/U5WbRtLpOwlGwIhrZ8uUmfZtNtvw2bSWXvLKZgmt8PQ038UgUPm8k5iAlr6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.66) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whVvU1ebmTXM7amqvOY/ClpLpQyMQD7jtoiNX2DxdY4=;
 b=YhGUEu2BBtVqefj0cHupfLpCwE+VU1ME2Y2ZID/lOLffrWdqAtAES2JmKkh7MfLptzTFFs5q7ZdXre+DPC2uSRL9L6Ue9hsZvLspVZon8kxSa9MBekJ/Mc3blDHtd0v8ArE7LvDSML/JbfANU00UA5oIv7snFIs40yn60Z4M2A0=
Received: from AM6PR05CA0016.eurprd05.prod.outlook.com (2603:10a6:20b:2e::29)
 by DB6PR07MB3253.eurprd07.prod.outlook.com (2603:10a6:6:21::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 08:17:09 +0000
Received: from VE1EUR02FT039.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:2e:cafe::f9) by AM6PR05CA0016.outlook.office365.com
 (2603:10a6:20b:2e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.19 via Frontend
 Transport; Tue, 25 Jan 2022 08:17:09 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.66)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.66 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.66; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.66) by
 VE1EUR02FT039.mail.protection.outlook.com (10.152.13.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 08:17:08 +0000
Received: from localhost.de (192.168.54.129) by mta.arri.de (192.168.100.104)
 with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 25 Jan 2022 09:17:04
 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Han Xu <han.xu@nxp.com>, Miquel Raynal <miquel.raynal@bootlin.com>
CC:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Christian Eggers <ceggers@arri.de>, <stable@vger.kernel.org>
Subject: [PATCH] mtd: rawnand: gpmi: don't leak PM reference in error path
Date:   Tue, 25 Jan 2022 09:16:19 +0100
Message-ID: <20220125081619.6286-1-ceggers@arri.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.54.129]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9efce90d-7912-471f-806f-08d9dfdb14db
X-MS-TrafficTypeDiagnostic: DB6PR07MB3253:EE_
X-Microsoft-Antispam-PRVS: <DB6PR07MB3253F78F03CA449D6CC3BA0DBF5F9@DB6PR07MB3253.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/9ra//hyg84142ZE0cBucf1FEzBeA+Bbg+iB+ZM8W3Y4O09JTaUzyrRR6AwgtnJTpLiokFjSadPEozgtQdAHUpVPCzPRCGLICLhoqh9LtaeD8rThBb9OjqaNNK/QIOS/kvjT9HgS8p7pp2XH7PYWvDv6dUwOM8mrMLdGXTeezTomJlHQs0BkGpv5B6z2era0eBeugD0b0rF+Lk850mEikNslkTuGbbQaMc90w0OFn4+hKyuXGH2cEC/fR7MniqoCPeAJJMNFOaQ0B5rgwcyqN6Lyb++DcJqX94CSlskhBgHwRhMvRt01Ja1EBM2OyVT0nsIWuHG6AMBff+F5Ftjxoy0HBe40IgPpGa62SzT1E/FGxW1iHMOuVPD45bRq7rHLndQFItJsmaPIMQnA6a4tVYDFhqLmr8JqX+n9tjON0o4OM6g5rKlCMNZKuGz9DlMRQEgwmLbN5LEG9P8rHnzdZH8rBD4tS3H6U1C7R7wsnBozMRJFUZLKwUrhiYhS1s7n7sB6V8IvS45QJ21CQMle1KOceqhANYsh4AGFeBnZU12bEDwxYI6QMWZyltUMrebvu7y8fuTgYXWZPjkpVSIJh8hBrtyWP21hKc03N5Q4mHsRiTTth6zyS5KVTlKAvtuar5SaDzqkhKD04APEqAt1SsYv36eB/NyRQMZadMw1ihvxtG5baQZAJT1V8zh+t90dTl9Jt5zfM7tdkvEaKC/oQ==
X-Forefront-Antispam-Report: CIP:217.111.95.66;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(110136005)(54906003)(26005)(16526019)(2616005)(6666004)(316002)(47076005)(83380400001)(36860700001)(508600001)(2906002)(40460700003)(36756003)(1076003)(82310400004)(426003)(336012)(8936002)(356005)(8676002)(4326008)(70206006)(86362001)(81166007)(5660300002)(186003)(70586007)(36900700001)(20210929001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 08:17:08.7897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9efce90d-7912-471f-806f-08d9dfdb14db
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.66];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR02FT039.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR07MB3253
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If gpmi_nfc_apply_timings() fails, the PM runtime usage counter must be
dropped.

Reported-by: Pavel Machek <pavel@denx.de>
Fixes: f53d4c109a66 ("mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 1b64c5a5140d..ded4df473928 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -2285,7 +2285,7 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 		this->hw.must_apply_timings = false;
 		ret = gpmi_nfc_apply_timings(this);
 		if (ret)
-			return ret;
+			goto out_pm;
 	}
 
 	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);
@@ -2414,6 +2414,7 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 
 	this->bch = false;
 
+out_pm:
 	pm_runtime_mark_last_busy(this->dev);
 	pm_runtime_put_autosuspend(this->dev);
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

