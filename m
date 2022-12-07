Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743266458CD
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 12:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLGLUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 06:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiLGLUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 06:20:12 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2044.outbound.protection.outlook.com [40.107.6.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D81750D5E
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 03:20:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxK6CF6mpBFQcZjjjCcJ+QIMiF2Rm52KYac5QF27Mcg9xfC82vgtFz52SR0PrCkkhn1H3VpxaTeWsIaXpOOWrdneCmzR8Cod2MxwCimECxw/pbuuw/sQ5T6dwlOwdDFVXY3Ql7w/CBwL1/ki4Pzww5ldJTT+5n8H1EiTO457fEGW6Ct6ZQsFT8PMeq9PTuykygv4ihR87eLaXyVC2APoeZKnymilg536RVpWKg83VxTo1OID2m0S/Fb4DRKffuQBMJ2N0kecyA6kZbkPn97Ms8J1zWKuE0BrZA18+Jp0ZEI7/koR3a9PvIzk2htbigbbMvorNIPICHaEt/KwNUNz+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pr9K92IymxhiGhl9LtnyXoiMVVI9xTsdUNWv5m11pTM=;
 b=anZbWpux4ymYbjwgnetabCjXS6bFRoAmOoKrhXeQQhFllhEWUHm0+0sYWkr25ZgxS46S6vc0ZjDkBA9hV1vjSxXzKlXA9wP3PGgjso7EnGh0rTHO6DbcE2JOolzIj6KPJyPrVvku15ROSOrl7vDuaxGPIjF8P7uMMCBb5AQccaEo1gJuTeNOmqTkIsRqwJx6i2++8/mdOhGZH8dj6RtT8sdvwSrrYxIh/3CpkCrBU9/2yWNaYV22VzOez+Fu3/1nOPD4wHClacq14IqUAEZGXlYg7hU2Fd3dVUwjHR/vy9tjkzNuE3UsMxCMPHBuTND3d+TQMSxXDb9siA+FIJCjog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pr9K92IymxhiGhl9LtnyXoiMVVI9xTsdUNWv5m11pTM=;
 b=G4Dzkuo3eJMz+uGJMOf7wSSYn8EbolypiZdMVnt9HkhK/f1vImGqIFhJSpxWUdgJ4dOAfMKA7YG4hN5w7MnJH78T8jSNekU+qWueZjhMwOwmHYh0+fqJP3Z627RD/wxr+WLaP1NQIASM+R156KXVYgKni/L6F/OGliOhiwvCRaE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM8PR04MB7297.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Wed, 7 Dec
 2022 11:20:01 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::8966:68e3:9b91:a6e9]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::8966:68e3:9b91:a6e9%8]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 11:20:01 +0000
From:   "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     vladimir.oltean@nxp.com
Cc:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing()
Date:   Wed,  7 Dec 2022 13:19:53 +0200
Message-Id: <20221207111953.28473-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0116.eurprd04.prod.outlook.com
 (2603:10a6:208:55::21) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AM8PR04MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: b6074373-72b7-46f5-48b3-08dad844fb0a
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8ky8but/31urFrvuhBwHBXpluEPErU+pffqcsmWHRjM0p+szb6XsreNza/e4g5UwWCJvZTxaUFyLKDyUWsFPirdRtNmMH0QTTNRN9mPh95dU6xc1oou8b926PBdczA+6tN+Gq/jjUSCPXipniDl3jU3XJ/y9V42pk0fA2Q4ey+5L1zahCb0eNhPImvdv30oFmxonIU1eNx43F1ngV1uIQesBwKvs2I8dd0YQdNCLJ85eKpcO+yihUSjtOnKbo0wAWMtFwH5bmd6jhCmRoKRgfGl3ljPM8vW7pcaczq8OscgAqhyhc4pFsqplXb6tVDEqujwxhpKbYMzMBUcI3nQbvR1XZG0s2Bc8z8k9PuMgGlShFbUXHjnPVDIsfgpitPknZp7O92RXK9lYi1nGe2JyG9Sp5hJeSRfOfOzU78upNbKegKWzHM/u8n5VYbvgOro+InlqcKLIbGQAeZDKQVR2lrQEyJe4WZdmaZ0Tx2eR0VuEKQWQxymEMudU5fIzShUCkzbd+bdWX6o+Bx6gUDQvtE6GDwry4wv5OP2v2HOQ85sHvZt1Wt0f67jQ4OmnaChjObEclUEDyyGEs9wNaYHbHpiK4SJ+39r19fEC42sNGSA+lrqcDd4W22lk9DxWrePXNAYT0EtAQD0loulDOR5Cu8a3YS5NYfkbpooO/MSE1c1/wHhrFPPdGr0bpJbZWOgSnTC/ONuZQBTrvzLRpKl4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199015)(38100700002)(86362001)(41300700001)(38350700002)(8936002)(2906002)(5660300002)(4326008)(83380400001)(478600001)(6486002)(316002)(66476007)(66946007)(2616005)(66556008)(8676002)(34206002)(26005)(1076003)(6666004)(52116002)(6512007)(186003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/YTRD9WW/rifBvzw5IYiAJTEMvMkzmdc8XhHRB9gFW/HAaQooBWzKRCOGLtC?=
 =?us-ascii?Q?BPZadTEWVyp4ETIxAS6zAJr08lNGSN2yU/EuNq/bReeLeKtvkwmTezIPEauD?=
 =?us-ascii?Q?3X4UhIEx5P+B5JP5TKgiYw1nhCcjCqk1TgXZK0Rdtv/bdhdv6WObQpTMJaMc?=
 =?us-ascii?Q?uupjcw8Tb29mWE1JRMz09FWGgH1AhsBK80XgOmWCFCGnsc7YXbcpE20RV2YC?=
 =?us-ascii?Q?LOxNTT4XyiBmhq4/deETZgBGXMh5f8a0N6LUusFtOMXRJfEUblqVte7Crjsd?=
 =?us-ascii?Q?AF3GTgC/8a5C9CaESaSCAo3x0VuhRhoPKf0SxVe9YI7fY3dN3dpMXEsm8PQt?=
 =?us-ascii?Q?ZyPcivzFmHjVy1xOa4WDfH90b34B25phUo+35padaLb9IqrJ4jZNmJTTikRQ?=
 =?us-ascii?Q?1mg7S+aYU2LzZybC9xtKFtsdrf2Nuf6gzdqJxicS4lDm3CscaaSUTF98dnTg?=
 =?us-ascii?Q?ci+5Zv3VsLY/M/pchwBtc423DKsCoL+zqHqPEhrrb+PGo7dp0f0IOK6PDlle?=
 =?us-ascii?Q?L+uy0Bv88yJ/ufB/InxW7c73HwiYzsIK203i1dwOgu7q2isgJA5F/4e7F29a?=
 =?us-ascii?Q?PAnqffTG08PZFcLUvo+64/cBVUDAIRLvHC3aERMBeQU8UdAHC+zBJuBPsfuY?=
 =?us-ascii?Q?LAGH5ocLkkTuA7jm/FM3KWWN5PxnHV73hR4YPIUQLWsrLPTVL8Y1JztHDytV?=
 =?us-ascii?Q?mipgq3eKd0BMYba60iiiPFBUWxO0FLhDfgjbG/L2Mmk6uXGmyW+tmLIgyqmY?=
 =?us-ascii?Q?Gyge+HAwnuWP5t3GyNw+TJihAl/kpoMPm3/zQW6MsNVXh/FJlREzUhdeOndg?=
 =?us-ascii?Q?JFX3GhQPX46IYHshikfMz1SInyalTefynpe1arHlLBIB5VosNr8pbUiVrDLx?=
 =?us-ascii?Q?1ImVDw7h2/Mz0i+0PuoIJCOeCqn8MTPPhFQ7AX+nwVFCvr0qZdIsmav3yagM?=
 =?us-ascii?Q?9xOFl6Z2bwoKXZJImTAJ7IQKw2s/n2CQlIcdQaEiogiOpuWfKkFDO6x+MrcM?=
 =?us-ascii?Q?S8q8qrQ90RN3IZZjl5Lcrqt28ei9wFOcNS4dCKPphM0kqfWOL70XnMK3K3x6?=
 =?us-ascii?Q?p7KuknJ8p/EG4YyD0S7xM29q+W1U6AAuN9s9cJ+MBgpXyqm1v1ow6LxAkqoa?=
 =?us-ascii?Q?8yQWvQtShm/bYeDtb9IN7HjpFmtKwbuGoAtE+pjU6d9R6FTggTxAO47H9j9D?=
 =?us-ascii?Q?HNmwNO8LYl0Z4uXVbTxxzQ7AhTPSqYlGXVeNIA4bJyNdAReGG0JWIyRDIpv5?=
 =?us-ascii?Q?MeVa+Jq8IS0HYghHTJX/qJSEWl25tXYcPFUZ6Gvm8NCcRbh7/ZM+IEVwjRUc?=
 =?us-ascii?Q?bOFAzPnNOxqKalCZpnX+jxXfPdLMzxdwOfP5xfMNk8E+EQ03Ek8zyPnYK46h?=
 =?us-ascii?Q?2nP257gpFNImgH6dYDn2egMPXj1EvV2gyzuolEoN327CO7dBvrFEfjaIhp6w?=
 =?us-ascii?Q?sguAkVR6CD3XgJKbM1Vx4NM9/t752sbPiZw6so0rFuCGQGQgc+1Khr8BiA80?=
 =?us-ascii?Q?GOu1m1bYDtOgFOO1PMEw5Q6ffR+wV/H+qrhXZ93NZH2dokfpZKz/VQ8KLKdV?=
 =?us-ascii?Q?la/AG2Tr/lEUy81J1jvb15tZfilWgvh4kq3/8x/o8Se6kz2D+GnhDdXwRasR?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6074373-72b7-46f5-48b3-08dad844fb0a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 11:20:01.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SD9nDqq87huFBFPmpEg9ze+2MnDow8t1xe88eLvnrNO3Te8GdGMb3N8LVpSn4C2F2f0CyXLL+ZlktqMcXt1svOTX2rwuMBEwd5EW4eYfKVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7297
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SJA1105 family has 45 L2 policing table entries
(SJA1105_MAX_L2_POLICING_COUNT) and SJA1110 has 110
(SJA1110_MAX_L2_POLICING_COUNT). Keeping the table structure but
accounting for the difference in port count (5 in SJA1105 vs 10 in
SJA1110) does not fully explain the difference. Rather, the SJA1110 also
has L2 ingress policers for multicast traffic. If a packet is classified
as multicast, it will be processed by the policer index 99 + SRCPORT.

The sja1105_init_l2_policing() function initializes all L2 policers such
that they don't interfere with normal packet reception by default. To have
a common code between SJA1105 and SJA1110, the index of the multicast
policer for the port is calculated because it's an index that is out of
bounds for SJA1105 but in bounds for SJA1110, and a bounds check is
performed.

The code fails to do the proper thing when determining what to do with the
multicast policer of port 0 on SJA1105 (ds->num_ports = 5). The "mcast"
index will be equal to 45, which is also equal to
table->ops->max_entry_count (SJA1105_MAX_L2_POLICING_COUNT). So it passes
through the check. But at the same time, SJA1105 doesn't have multicast
policers. So the code programs the SHARINDX field of an out-of-bounds
element in the L2 Policing table of the static config.

The comparison between index 45 and 45 entries should have determined the
code to not access this policer index on SJA1105, since its memory wasn't
even allocated.

With enough bad luck, the out-of-bounds write could even overwrite other
valid kernel data, but in this case, the issue was detected using KASAN.

Kernel log:

sja1105 spi5.0: Probed switch chip: SJA1105Q
==================================================================
BUG: KASAN: slab-out-of-bounds in sja1105_setup+0x1cbc/0x2340
Write of size 8 at addr ffffff880bd57708 by task kworker/u8:0/8
...
Workqueue: events_unbound deferred_probe_work_func
Call trace:
...
sja1105_setup+0x1cbc/0x2340
dsa_register_switch+0x1284/0x18d0
sja1105_probe+0x748/0x840
...
Allocated by task 8:
...
sja1105_setup+0x1bcc/0x2340
dsa_register_switch+0x1284/0x18d0
sja1105_probe+0x748/0x840
...

Fixes: 38fbe91f2287 ("net: dsa: sja1105: configure the multicast policers, if present")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 412666111b0c..b70dcf32a26d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1038,7 +1038,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 
 		policing[bcast].sharindx = port;
 		/* Only SJA1110 has multicast policers */
-		if (mcast <= table->ops->max_entry_count)
+		if (mcast < table->ops->max_entry_count)
 			policing[mcast].sharindx = port;
 	}
 
-- 
2.34.1

