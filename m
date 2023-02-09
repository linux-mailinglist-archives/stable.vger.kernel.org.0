Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A84068FBFB
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 01:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBIA2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 19:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBIA2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 19:28:44 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2123.outbound.protection.outlook.com [40.107.100.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999511E5F5;
        Wed,  8 Feb 2023 16:28:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gvx00PVpJcEpgf/9I9FW3qbtsLTmI+oYQwLXAe70n5Y5Y7CfQC9sFxzg0nqCOk7IO0TA398YPXKTgH+c/hwhtin4vFaULQzvHuaRn407b0IkDqybW33a7Xfnhm7k2hbCx2KG4Gmu0/ivtii8DJgZwgfxy/5t+2319p3S+wvCqL7RNa24y1eFLHcXeMXGgqTQlfkdckyi/7MPEfA60wJfTjAtZU9Ysu2nfMvm8QYCjFBprHD6U2sVhgHQItsgChge1w/gXJ711UsTcQdpom3A/iPseBs03v51nuVwP/R/U2IpHAYHb61+LPd75rLhNKxd3NSs+Cbm/oGDFUMEsxJrNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwIoYF3jsNMsL422ZxZgDHc+rw7lvKu+tOw0tbm5tJA=;
 b=aRgFZXgBb3I2mJ5Ed8U+XUDdkCW+xikoGA/SP3gGOyYevVurMxK3mNSJGJk63v2LjD+zDiogBtuR455ARh6eZD1W6G57Jz90dWCcYsZtKVWpqt+6fdyFRGNnIDiEJ1QMuQfZPtyRUKSfjgu5E9Dv6sob3Gv+arIIOHXtoeb0Xnu6pTdn4hUB8puLvwQ9l/H+lF1+lyUV8UN90fPVQPZSwoTsBPFZybPwEvlKRVsdPgRUZIkhBGrdL0SH8CiJLAZvgTF9tVw6Jslc4TdMBg3mze5Njejklk56343xcXDsQqbx+6BdVwTZwb76/XFfcbWBjkb1tgZTUwLBBC9fpMpNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwIoYF3jsNMsL422ZxZgDHc+rw7lvKu+tOw0tbm5tJA=;
 b=b/swWV8cBrCzXtVR25gpPg83R8jAJVcvNibtM2m9v/oHMAd+/t2Tb/svoSR8GcjIab1loajwRWZr7q57GE46rfw3QDmdfWLPsaPT09kvbbuwe28id8g5PBuFbx6TrXKJL0uA+hyUUFJu3TJQ+42MQsAcg/Z6lBCcgN93PFeAWog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ0PR01MB7432.prod.exchangelabs.com (2603:10b6:a03:3d3::16) by
 BN7PR01MB3747.prod.exchangelabs.com (2603:10b6:406:85::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.17; Thu, 9 Feb 2023 00:28:38 +0000
Received: from SJ0PR01MB7432.prod.exchangelabs.com
 ([fe80::5208:e5ea:6ab3:19b5]) by SJ0PR01MB7432.prod.exchangelabs.com
 ([fe80::5208:e5ea:6ab3:19b5%9]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 00:28:37 +0000
From:   Darren Hart <darren@os.amperecomputing.com>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     stable@vger.kernel.org, linux-efi@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@gmail.com>,
        Justin He <Justin.He@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap() on eMAG and Altra Max machines
Date:   Wed,  8 Feb 2023 16:28:21 -0800
Message-Id: <2ab9645789707f31fd37c49435e476d4b5c38a0a.1675901828.git.darren@os.amperecomputing.com>
X-Mailer: git-send-email 2.34.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0045.namprd14.prod.outlook.com
 (2603:10b6:610:56::25) To SJ0PR01MB7432.prod.exchangelabs.com
 (2603:10b6:a03:3d3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR01MB7432:EE_|BN7PR01MB3747:EE_
X-MS-Office365-Filtering-Correlation-Id: 0814d5cd-d7ff-4b7b-983e-08db0a349592
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BnhLTiGwzEntsegU7ueJEPMbrmsCe5OEhj/uvo7HVbuzQ0PQbo8yBJFMCWmkqugjQl3OzbiUmSFEejWeZ+Abb/JjxlP1wbt3qBQjviUtfOArDHj0dpmzpJbdX4QgzRSdzXW3mKBV9nHWRmMLyqI4kMjJQQjnzClK5GZW3aBp/CUJy6nmuIvehAyhhvPuUzconBrAho9hwTlDA/Nkk1ww+zm7JrFv7QnFlg/LPUwrG8/2er8mm8+N+6IDiropPLlYodqOAssdSYXeLgP0trNk0R+keKZBP7QBvDhj0U6vImw78ODcMdii8mVSByBdS9NY0evJILnr8mG47LiMnNzVZ57FZU0/GIHEotRgTOCPOaJtjmGl9R3JrvadsHpTanhJc0iHmXL9pDDYJbAs6l8xFsXNz/ZcFYQ5r9Yu2ZLAYBO3E+nFiDWiShpMFEZOHO6tD3e96NI7whNwNp66GnO8xC04lh0W05ePpHuY/1f6xXlNlApgHo0b/3L8c5akqx3u5ErxEOqkeBUqbpCTX0pX5+xfgUH0StJmwNn8vMAIE4BUEV0Do8ABi5/vvqUWF6UlEzI5DIo/zc362S0Zq/pZCmPyfJ1NEqNZD8ERogkU7s0QB8IP0l+5x7hWSVABk/KnurGHJH7uOb5zCl+Yq1RVo0g9ZWEKli9KfpULuC+Q+ZDBTohTPD/gWbdOOh/6H191K2frkxleUjopzOPybsElQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR01MB7432.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39850400004)(346002)(366004)(376002)(451199018)(66476007)(6916009)(4326008)(66946007)(8676002)(316002)(38350700002)(38100700002)(66556008)(83380400001)(54906003)(86362001)(5660300002)(6486002)(478600001)(6506007)(2906002)(6512007)(26005)(186003)(6666004)(41300700001)(8936002)(2616005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pYnpVmhMuug9lGXZ0/8sH7ZZFCqBMBluGXYT5eMxi+yjzSyGo1FEdzR+l3J+?=
 =?us-ascii?Q?CrtgOAEYfmaZOnrZVhmllITIYmMlz+TBok2TGG+Bh16P5nzDaSakhJYe9GiD?=
 =?us-ascii?Q?ydoMWSpSP3TMyrqxEhu2+dG8H3CgcuWKtjs3rhD74yFrDDdhcs6QRHJPH9la?=
 =?us-ascii?Q?Y7mWG9dW1gBGmEH10OPE7DCl2ZcY0Xi9fA5dOFN7DM6INkhm4WhU9luJIHYx?=
 =?us-ascii?Q?7dloZH+CsF7EK448Ek+Z/WlNt14O8Zis9r/vv3+CYMXl4nWgmLaoZcc93R5b?=
 =?us-ascii?Q?cfn5n8zAoq+S80dJMfA6RH7qL0yCxoN7gktVgRCiZIkvHkqhlJ5uriTPhO4J?=
 =?us-ascii?Q?ux4jagXfJYxFSlqavKF9RZe+0aUwgy146a6z8IJ8Foim4kL9YjNSCNhyakhp?=
 =?us-ascii?Q?p3EEGVbZ2x19836wdhzPuceHLmFuCtNOxfI27wHJujGYaq1FIb1JBtwMW7Sq?=
 =?us-ascii?Q?szCj3FDvCFlI1KpPx8D7RQvVuXMZg5+Tub58BURGvD3fG0gLVKQbvDZMbNwE?=
 =?us-ascii?Q?RIvFgLGLmDULIiNEs14uO0pWyqYcxaUMRbwOFccTLP2NzTlZ2v5+ppptUawI?=
 =?us-ascii?Q?tZNwWAZ8f0Aqpz+wXxfy7dcZh10Y1RXnn9qEeqx3hJwpB8Q8+uV+LXIhNSp1?=
 =?us-ascii?Q?gwKeV3+27i4by16GiGAh6Fh9NSQuwsBfx+0LOrGHoheHaRSsKr0jmH4nlR9t?=
 =?us-ascii?Q?l2OtPKpTBmlZ0Vv9hzL3+pIx8bLzbNHq2Zs1Zkg9q5ps1GNUNssdS/VIuc3L?=
 =?us-ascii?Q?0wTv6AxfxeewdTUHD8XtuD05Cjrxjhyei2BQWKWPyWSztAjVDt3kPLM49Kwa?=
 =?us-ascii?Q?BMpFVwrTJY11de+16aQNBMXtgIOKobtJWNbZnVhyjUMMsKCEObEJWD8L7PWz?=
 =?us-ascii?Q?t3W71/3DE8BRIq4Ydx3jhOnHzWYUaZ9r1Rj75qVwEhKAxKOLMhEtvypJSDyw?=
 =?us-ascii?Q?9UV8+6TN7zXbaDC4EyZL0sptvHO1x/ybzerTNpfXXlOskfDRjqGsDM522hKO?=
 =?us-ascii?Q?igsmmP56f0nUBXeEk9FFICCljdRnVJpfr4c96QioNpMHWARTPLBZNSiBOm6+?=
 =?us-ascii?Q?WivBRdddfI48OwVnmisrVPg2Bi1NIYvJPa2aTMgBsbfII3YfidElKJ7VJPKP?=
 =?us-ascii?Q?6TvyVgQV4VVCxxGW25h47Mt/vvhOjVcI9jhmsnZkG40M4nbnDqjMQn/eT25t?=
 =?us-ascii?Q?fUmjrC7W3HUFHoVlFokYC/WvrrD+Dtw9Te0Ou27HqliyL3vuljLoyVDPtHlC?=
 =?us-ascii?Q?ptHbkepAj+UIgR5CtYRG54yXYz35FSGb8w9eGj4IRpoxwz4nmiWvtlwNuztR?=
 =?us-ascii?Q?tzjb4jL8ivjf0JmNGVI16uZd42PssemqhBoNBvAbhBljulpllYV66OKAZPA8?=
 =?us-ascii?Q?D7WkTujTrHzlOQAqA+OzvLcs49SCtAw+hIefR/UmjOE37AMKQRo8kIBRwcFT?=
 =?us-ascii?Q?YscLL6rcTZHGE2KNOsIpQY1m3hlKMpJS+co5LDFlBg6y2CO1DJLUk6C6BXu3?=
 =?us-ascii?Q?7s6eN7i/o+QJ3JoFhqFPKhiY6+rT8EXaoS3BwDDhnA5K2WAJtOR1bsptylMD?=
 =?us-ascii?Q?EBUPPe0t1VnZ/sO5Al8u3vmQOeL7f3UyDIg5mzC4WLwk7Iv5xRm6Ztf6OqiG?=
 =?us-ascii?Q?+nAWGyYtlicA6EPx/9NkDY4=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0814d5cd-d7ff-4b7b-983e-08db0a349592
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR01MB7432.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 00:28:36.9702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kpnh8q8FJFTrkEZu6BpqrwHZDy7JpFNjeu4NIgFk8BVy9w3j6MGxJgkCM23uPZL1eCMADZonG6/3rCJS3hpyP2y7e+KKcHa79QfZ2BE/CXJeuVX7cOq/jQIOGjJoEkcq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR01MB3747
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
on Altra machines") identifies the Altra family via the family field in
the type#1 SMBIOS record. eMAG and Altra Max machines are similarly
affected but not detected with the strict strcmp test.

The type1_family smbios string is not an entirely reliable means of
identifying systems with this issue as OEMs can, and do, use their own
strings for these fields. However, until we have a better solution,
capture the bulk of these systems by adding strcmp matching for "eMAG"
and "Altra Max".

Fixes: 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap() on Altra machines")
Cc: <stable@vger.kernel.org> # 6.1.x
Cc: <linux-efi@vger.kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
Cc: Justin He <Justin.He@arm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
---
V1 -> V2: include eMAG

 drivers/firmware/efi/libstub/arm64.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index ff2d18c42ee7..4501652e11ab 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -19,10 +19,13 @@ static bool system_needs_vamap(void)
 	const u8 *type1_family = efi_get_smbios_string(1, family);
 
 	/*
-	 * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
-	 * has not been called prior.
+	 * Ampere eMAG, Altra, and Altra Max machines crash in SetTime() if
+	 * SetVirtualAddressMap() has not been called prior.
 	 */
-	if (!type1_family || strcmp(type1_family, "Altra"))
+	if (!type1_family || (
+	    strcmp(type1_family, "eMAG") &&
+	    strcmp(type1_family, "Altra") &&
+	    strcmp(type1_family, "Altra Max")))
 		return false;
 
 	efi_warn("Working around broken SetVirtualAddressMap()\n");
-- 
2.34.3

