Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF4F49DF83
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 11:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiA0Keh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 05:34:37 -0500
Received: from mail-eopbgr70091.outbound.protection.outlook.com ([40.107.7.91]:49987
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235153AbiA0Keg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jan 2022 05:34:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzxe/U6bvriVO5ztzvqbk2XIUjbuNq4jGX6GEQTq7hzrg96erTa2lEgA9cxR3zjN/3EGk2S+D3oz+Tzy1ZG/xW2VUJH1mhMa1p+kMRKMM723w6wFOx2EQV4cckKZ1pMappQ8xdssxG77MAqnq0orEZDzm+rM1DvwHMRM9NNrw4gYu0/C1qYeBIscTNbIOM8Q3LLZ6hd58w0kwGVTnFojd4TUA2TOcNZiFRrXOHWJypS4zyTRPPu35CIe11y4kmsCeqolev5D5Rj0j48/jgzXxXiUG5HVRLyZ6FOzFqidisMgzxULlKb82GKUviMXFnmWR1v2GHFjDZzdDXtw7hD//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IBm+VmPWv6s2gnfFH/grOFE/YdzAbyKU/4pz/8jEwc=;
 b=UiF/snSn5z4/OiwE0e5EurX2xaeVDnR5s2IN++J3AKmpDb0uzZVj1djchnJk1rGh0TpVP3w0uaEd2CKNwkog/zR1nDAVphwDb4tK6u3P4nIQiscJwJF/JZ2iXkVPignVfT0tbuG9X5QfT0hIAgUHjllueTz4OjeUGWzpo0nrBnxSshSVZF3BF/J0tJHPGaoCNb8+K//35BFZDqnS8QdvD4PpCKd9NLWQHnvyLeDFvvUNhpLf2TPATuFUFLjpJGmX44lVAGF/+9oxpL0j5sINg3sxDya3qDUJLcaufei0OKPph31CtFL//yn88B4NnlVqH+XiZdPIW/SMRIHvSB2Rmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=leica-geosystems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IBm+VmPWv6s2gnfFH/grOFE/YdzAbyKU/4pz/8jEwc=;
 b=V64U1iyRXnqLfDzq9TDPkn7+O+onPGq2dE8Pt5RuDg28alc/Wz2HgIJ3d+3R/fF7Lg88b6T6ptimMLLKnyp9fiAa2U0qim2gskQ7wsdaj6TzlgM5qiH3TG5z8dYV+X64FFrNpeNAf2e9eArrKSjEnBhbOMEWKvGUB5v4mG4KanU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=leica-geosystems.com;
Received: from AM5PR06MB3089.eurprd06.prod.outlook.com (2603:10a6:206:8::10)
 by VI1PR06MB3040.eurprd06.prod.outlook.com (2603:10a6:802:c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 27 Jan
 2022 10:34:34 +0000
Received: from AM5PR06MB3089.eurprd06.prod.outlook.com
 ([fe80::183e:382:8817:4f49]) by AM5PR06MB3089.eurprd06.prod.outlook.com
 ([fe80::183e:382:8817:4f49%6]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 10:34:34 +0000
From:   Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Tim Harvey <tharvey@gateworks.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Subject: [PATCH 5.4.y] mmc: sdhci-esdhc-imx: disable CMDQ support
Date:   Thu, 27 Jan 2022 11:34:16 +0100
Message-Id: <20220127103416.53-1-andrey.zhizhikin@leica-geosystems.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0192.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::16) To AM5PR06MB3089.eurprd06.prod.outlook.com
 (2603:10a6:206:8::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 766e0b4b-8530-459e-b7b1-08d9e1809c29
X-MS-TrafficTypeDiagnostic: VI1PR06MB3040:EE_
X-Microsoft-Antispam-PRVS: <VI1PR06MB3040EF921BCED2057657A27CA6219@VI1PR06MB3040.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F5LCVskEbmvZcTatBCQCAC3hW1+mo5CPgh+YgEwSpKA6S+DSesOrXgJcnriF1Lxmh9NErkPevzCUoYqrbgaACgdHq6VdN9fJRTZHI1Jf6+9XXphx3BmBDrdAlzZ+eIeGUc6xO35ii/JgwXLfz3bpuBOideQcYifZ4rowcVvtmKyZuTMcrl3pmYTWlIX2Li3awueDVLVfaf5SnnDiQI6DzmO8TTPKe1fTTAAnzutDvbaTUVTNcM1awMB67sg6NnemCR/7jJ2mZS8Qc95MW78gSK+XDAjWVvazbzPs0ZbiT/hRA5HeZKo83GCXmXixuqIjyqG/+IrAhQ3C2lCsCtF7jMhijkjW2EuNr3/348segv/l46Ty693e+kXjUHtcHhMiQlTSYe1KQspKO9oqciwJ7T/qTDxbQvN/p9a4hFj94/z8xfHCSHXHZu+XZGCqxYF1s4s4lG1WE8Y0/kIST1GDtuIfxmlGPVRUNJ9SKA4jetFIzRHm5gzQHHfHHLtRgoROSTdE0adV4gl/rTTv6bh6AOlch5tqq5DGDCH+YuZwxVpisLBiWLSjHRzAF4rRN6cUWOy6VUYq3x9BSDu0UxuDBsOO2u2EkQlr0NFWXcoyX0BDvWRjN3sebqTzf/qIj8p33Hy56Eo4r4++6CwzYVPsOn8AjuYFrO03PwgBcMcmVr19vY2Ju+6ER8VWXWuyMBhMipDxtXNWj65y7iUJFkiFiCAdjvpC4o5S+RYU0ZWtOC3KqraUy/lyc02OYPq+GQbDosZVGxzw7g+iPm+eEFyKMKyk2L6MW/O+pSY1ed7Mf4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR06MB3089.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(66556008)(6486002)(508600001)(316002)(44832011)(4326008)(38350700002)(54906003)(2906002)(66476007)(38100700002)(83380400001)(1076003)(5660300002)(6512007)(6916009)(26005)(966005)(2616005)(66946007)(107886003)(186003)(52116002)(86362001)(36756003)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mLDnAlHwpcRxS7RPFTqJqrMPbLQ5wH9C5R+IFfArUNwv5c1zkKjmqESOSazs?=
 =?us-ascii?Q?+s0jA5bWNAtF0gPsWEKS9gt21GMLNod8/2cetS7wQa8hLzkQXfy706mpo+O6?=
 =?us-ascii?Q?HkMIYGp/7Ni3nDDNKxcwH/8xB/nmr4zKyncIjowrAngxVdQr88LJlh05nqbZ?=
 =?us-ascii?Q?QOa9hFC2oFfKJiiIQIIwYX+dSIOoIKQdv6gLiSITnykmIyMJeL0ZXwbgYziU?=
 =?us-ascii?Q?V9j3OKkEiWIagmANTfg6J2/BBAPL+TXPck1Nd+C91h0oSUWKP/FLDGa2LkT3?=
 =?us-ascii?Q?SQJMMDRACynuCHW535SCGTC4YCh/z0hzIcmk4l+TutyRh5tVw4tbY9CX/lJD?=
 =?us-ascii?Q?94gkOuiz/TVsd+otowx3Bmn3yfFGL0OxPuMdyHQ4Ej9vuVaaEkA0hH/jEWNZ?=
 =?us-ascii?Q?7S22UCtVgUrQw2aJIb0iKxEFSpuy9fZwg1MbhWCKM/UsvbQ8X05LfqLAXHVu?=
 =?us-ascii?Q?OhZ2iSbmGvX5nSGBQKYjrTkANrleeJwUs4dAiF5wovI4C61PM3+bi6ltJf8S?=
 =?us-ascii?Q?HjAOjqOKTgCTiww4MOYKE7RrPcR/xV/D/8V9MrIjQNDkW/hcnD4ueRANC0wo?=
 =?us-ascii?Q?eAbTprPbCAYh3ExBAtrCM4UCI0tMUajJ9qWv4EiaF98BJEIct+6b5xXWwN98?=
 =?us-ascii?Q?BNIpDd0d8q1KzOI0FHEABXVBQ7ZT3RT7LNn1GDdiZTC1oSFaGiyMqs+L3Ogf?=
 =?us-ascii?Q?x4qdqIbCVW/5kFmW7YIXKZzO/ZIjJ1+mQwuS4rIO4R2nyuuXRBsnOgosP7a+?=
 =?us-ascii?Q?gTLc6TRyMrf/64PHVCcJ844zOETRdE15YrJcFyY2BzU1gZo6/XUTk4uMAWv/?=
 =?us-ascii?Q?ZQrd1yjiCd02arW1MFilg/kgcaD9eql6x6t8XOsegL4H/amoviRWO1Z6j34d?=
 =?us-ascii?Q?SbiOte9vGrhAivs1tzfidS6oYiTAdhaivAgZuod+kmjFshAb+LzhxziGEau9?=
 =?us-ascii?Q?IDTKt2c7wI6Q+tDMDSaaCO4QUik0REn/5lLbrIQngXmzcNZsF23skMDEA4nZ?=
 =?us-ascii?Q?TBs9KKNewd4Te7jxaLeBY+mWneM3zfMblbOSsL0obpUl/C2xj+oz9rIrJcLU?=
 =?us-ascii?Q?hnI0hXK1GHCXkCN2LRX5XAFJeksCBoYeZPJoDRmmJjPtvKL4eTlx0rCw0QrY?=
 =?us-ascii?Q?IuJXzQVZaOHEjL0xqvbI6tu55GsH4kl/THTsfe+W3v5vfMn6Xhl3329zXH0F?=
 =?us-ascii?Q?RGlVuW3B6og6+v8I2wv8b6rn3RlYQMWVNXcPzk1b34eyi0vdf3Jy0w72mflv?=
 =?us-ascii?Q?1S9iIMwfwxnK6kJC47Yt/kDE/LY1TeT6gWoO5DL1uPC0GP1LuG6i+5+t7gai?=
 =?us-ascii?Q?VcfBDLKg3Go3E7m6XFerHogf7LiWNqX2qJtH7C6CVcgWn3oifADiaEsXVfHt?=
 =?us-ascii?Q?I1SsL12sDXRL3wNArYvnmopYveJjEzDw0YnH6MmHPq5kSsFkaGErMr7QJzMW?=
 =?us-ascii?Q?M19WFgLRw4S1c6rJWcMe2nFXPSOi2q129q/YcXdcmrI7cd0ccPOIEmgRCOBu?=
 =?us-ascii?Q?hjpDVS01JuPYkYzgJB0qie6+P9+tVDBP59Fpv6eO/WEFKZAuzKplRTsJ1jyo?=
 =?us-ascii?Q?cBts7HH1ga9r03SR6R5jKS/u69scD0gh0tiJj+9UfCweksvjLlh+D2WYPKxS?=
 =?us-ascii?Q?gfW2RVOgcrQ8mWeBnUMvzpTVgHmV+zs9Q9UU63PXGZXB3/+YBFiO1wtArbR1?=
 =?us-ascii?Q?qeVb+3pdJYsqM9aPxK9JFJDpdg8=3D?=
X-OriginatorOrg: leica-geosystems.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766e0b4b-8530-459e-b7b1-08d9e1809c29
X-MS-Exchange-CrossTenant-AuthSource: AM5PR06MB3089.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 10:34:34.2772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQ7iOARihVK54lAuUbXYxUml9phkYXwspuQEM4pUaMwNchf0jvH+G40JLOVrR9vVSXRrXBLPSvtKDLrc/NjFbp7WUeQBDV95cHGZqO5XGnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB3040
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

commit adab993c25191b839b415781bdc7173a77315240 upstream.

On IMX SoC's which support CMDQ the following can occur during high a
high cpu load:

mmc2: cqhci: ============ CQHCI REGISTER DUMP ===========
mmc2: cqhci: Caps:      0x0000310a | Version:  0x00000510
mmc2: cqhci: Config:    0x00001001 | Control:  0x00000000
mmc2: cqhci: Int stat:  0x00000000 | Int enab: 0x00000006
mmc2: cqhci: Int sig:   0x00000006 | Int Coal: 0x00000000
mmc2: cqhci: TDL base:  0x8003f000 | TDL up32: 0x00000000
mmc2: cqhci: Doorbell:  0xbf01dfff | TCN:      0x00000000
mmc2: cqhci: Dev queue: 0x00000000 | Dev Pend: 0x08000000
mmc2: cqhci: Task clr:  0x00000000 | SSC1:     0x00011000
mmc2: cqhci: SSC2:      0x00000001 | DCMD rsp: 0x00000800
mmc2: cqhci: RED mask:  0xfdf9a080 | TERRI:    0x00000000
mmc2: cqhci: Resp idx:  0x0000000d | Resp arg: 0x00000000
mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
mmc2: sdhci: Sys addr:  0x7c722000 | Version:  0x00000002
mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000020
mmc2: sdhci: Argument:  0x00018000 | Trn mode: 0x00000023
mmc2: sdhci: Present:   0x01f88008 | Host ctl: 0x00000030
mmc2: sdhci: Power:     0x00000002 | Blk gap:  0x00000080
mmc2: sdhci: Wake-up:   0x00000008 | Clock:    0x0000000f
mmc2: sdhci: Timeout:   0x0000008f | Int stat: 0x00000000
mmc2: sdhci: Int enab:  0x107f4000 | Sig enab: 0x107f4000
mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000502
mmc2: sdhci: Caps:      0x07eb0000 | Caps_1:   0x8000b407
mmc2: sdhci: Cmd:       0x00000d1a | Max curr: 0x00ffffff
mmc2: sdhci: Resp[0]:   0x00000000 | Resp[1]:  0xffc003ff
mmc2: sdhci: Resp[2]:   0x328f5903 | Resp[3]:  0x00d07f01
mmc2: sdhci: Host ctl2: 0x00000088
mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr: 0xfe179020
mmc2: sdhci-esdhc-imx: ========= ESDHC IMX DEBUG STATUS DUMP ====
mmc2: sdhci-esdhc-imx: cmd debug status:  0x2120
mmc2: sdhci-esdhc-imx: data debug status:  0x2200
mmc2: sdhci-esdhc-imx: trans debug status:  0x2300
mmc2: sdhci-esdhc-imx: dma debug status:  0x2400
mmc2: sdhci-esdhc-imx: adma debug status:  0x2510
mmc2: sdhci-esdhc-imx: fifo debug status:  0x2680
mmc2: sdhci-esdhc-imx: async fifo debug status:  0x2750
mmc2: sdhci: ============================================

For now, disable CMDQ support on the imx8qm/imx8qxp/imx8mm until the
issue is found and resolved.

Fixes: bb6e358169bf6 ("mmc: sdhci-esdhc-imx: add CMDQ support")
Fixes: cde5e8e9ff146 ("mmc: sdhci-esdhc-imx: Add an new esdhc_soc_data for i.MX8MM")
Cc: stable@vger.kernel.org # 5.4.y
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20211103165415.2016-1-tharvey@gateworks.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 2c01e2ebef7a..d97c19ef7583 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -218,8 +218,7 @@ static struct esdhc_soc_data usdhc_imx7ulp_data = {
 static struct esdhc_soc_data usdhc_imx8qxp_data = {
 	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
-			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
-			| ESDHC_FLAG_CQHCI,
+			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES,
 };
 
 struct pltfm_imx_data {

base-commit: 4aa2e7393e140f434c469bffe478e11cb9c55ed8
-- 
2.34.1

