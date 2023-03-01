Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557606A76E3
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCAWkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCAWkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:40:00 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC5F37716
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:39:59 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MdtjD028283;
        Wed, 1 Mar 2023 14:39:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=GEdTJBzsnLwgk6kDXjwQYbccUao4mWFwQzSE+ECdt1o=;
 b=s8bm6XjfsEVqAZGZvw2ju0XxZXi2tzG0SQYGn9ekfKyuDhY97JnMz2XJLnOeH4HWWy7z
 Kjx8tqQEOZ9vexwW4KTi8WyI6vGWLCxwrLE+YpzJ9NyhIieWQwnIsRtkWmUsWlTEQLxt
 X5eFPmdZMdvBiychMPeUoD6EbTI4nQWJ3yrjL7Tp61QLIU+gIov8/hKKnEh+iIcUbED3
 /PQ3JpU5PcA9dN6bzHrJqcdhS2i+1rk+hVGDPaoJEl8w65gItozTe2FBoUnAIMcO24XJ
 6lWxsxdxtkUvRTHlq3T3FH9zMbndavkKX7Fi0hB2If4g5szJOc+bR+ekCkA+g0LQvHl6 6g== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:39:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oy2Bk0AOYFQ4epaKJAOrxmczBEIp1RqwXbsWAopSGJG1H0//GDDS6W8+n80VrghO+6M1IOKjcWSG/yQLOBZQq5qZQBifrJzjtg7Fb8kqm704qzJV5/zSsp5yBlorBjcTs/YuQVNjD6ddUXria3FKFW+FFw8MaMwXfGmSotRtH7fX1Vr4kjnvfZh23JA323WnxHnaywgvgiCAygquxmXstru/2w3IUVOKpb/1nAFF4DDRo5ZG9/KJrDxUbqWgZWqBjX3V3HwCJcUMj42ai7J5kYTntP3qf/wn7IBv5Cy0ZFKtaXxME+uKH8nBDRuHWPUx9BRnVXU94g2KXJeoGD3y9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEdTJBzsnLwgk6kDXjwQYbccUao4mWFwQzSE+ECdt1o=;
 b=gU1yNigiL06CJ1hMcYqfbKwjeJK1BiqwCTz+6k7MIkM2T+6ku3zuAZsYFiqxh9IP0KdBu9P8s9uSdyqhnBIscx4G3YokcG3YfixKQHuBtp08YKcF0SG7ezaK1/hJF95MCxkq1RMPOsFVOhe1SUxAn0sjya6UcgfkzKQLYbwUi8oGPi+CpoXP1fogkpFX6FtiDq8qVtApIBYbruJuuKzxPMzf/U905WI6OVpUeu6ssh6zcdUToBXU4ig9HAihXvyePJPVGQcOWyzQIDThCRXssd2JV7OXO98Vb9tmZ/lnRFwIatX0VgTkAMFg2jc14a+4ECgSHB1mWN8redr8cKNxCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CH0PR11MB5300.namprd11.prod.outlook.com (2603:10b6:610:bf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 22:39:52 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:39:52 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 6.1 2/2] HID: asus: use spinlock to safely schedule workers
Date:   Thu,  2 Mar 2023 00:38:53 +0200
Message-Id: <20230301223853.28466-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301223853.28466-1-stefan.ghinea@windriver.com>
References: <20230301223853.28466-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0091.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::20) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|CH0PR11MB5300:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d37ed8a-6286-4667-7f17-08db1aa5df44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txechsYAPYH0KleQUJriBWEUVDJxl46ZVEolJnD7CLXNOI+TdGHXOJQ1IUATc/b7IqXGaXg4RvY6M7RrrVl7SO7nm09i0mFAtGUMOa3HgHY+0EONtaKrK1nvVyALSpkBrlq70GCEtPuwoTNVX3oPUVt9PO1Xe34/4/EGJten8U2KRMYs/umfv6eKfdXuWGScrJppt3HlWsxHPUGDWKf9JVqBnmhXey9K3lLHgQaA0tgoNsRdNrPpibgi1I5NKmutT4rIyK+t0cY8P4PMkzWL6xfMLOMVChlZwS30QB3YBnBpRVVUo49OGUsvusza69PQ12fgAdssLsyrLORZuZZinysFpR1UQigtUGachMJqJ0AdOVEXhL4G6+IArJJOxOjst+ScVP/YZQfHJLpGcXwgGhv5aBmvj4YmOlkA3Iv8LQ3Q/cR7BYhYRYAfq1Oea7y2y9AUYSbbU+JioEYcW8YpYKx46ientROQ2O+X4yEgfp/TnerYtDGEUmDg7ufmKCLvrNJaYihpIsnARDkl1XX0kiSTRpFfynuY6gbCSrrDNtvwkuiKTmIfKdz3PgXLAmhh0NM39b4hBqgS8rkNFBLn+JwciswOMW3hgpcSJfFVkbubgU7/mSh9XPXFl/M09/8MG2hZTuaR7S8RpVppWifRQRp1otRktn9mE9DZbkzl7DHSl9GCGxGe1ZlzmpwDRs/3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39850400004)(136003)(396003)(366004)(376002)(346002)(451199018)(66899018)(83380400001)(66946007)(107886003)(36756003)(38350700002)(38100700002)(8936002)(5660300002)(478600001)(86362001)(2616005)(186003)(26005)(6512007)(1076003)(6486002)(966005)(6506007)(8676002)(66476007)(66556008)(2906002)(44832011)(6916009)(52116002)(316002)(4326008)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y/2DAPaWBIbJtMjzsjaRaJkD3iQoc8vkJje18kj1CGXSKxExTkyXBTL8BMIA?=
 =?us-ascii?Q?TOCPavVCKMT4JZa9EHnV710B6UcGVBZK3V1TJ19r2Ijzo19yAvfAqHIpUIfB?=
 =?us-ascii?Q?zJvJ119NdtDCvHxseW8+hy9RGkQcuJIgltuX6ireAgNSQfVkfGqn/gqBEBPM?=
 =?us-ascii?Q?K+sgsIkgmUxf6N0JTmupVodYdDEpKZ+TK6jSfyKGb+SN3y4gDJtI87NoX2x+?=
 =?us-ascii?Q?pDdipEzR0CKTMgHXwcapldqjQuwQmW5dwGYwyHH4jjwwLsJnB8RJ2fXjBila?=
 =?us-ascii?Q?PjK5i94W49TZmc0kuJmAFBkfjcjOxZmqxneig+fV8fhj8r3vNxTWRCLhqX1K?=
 =?us-ascii?Q?OgLpw8GkE/BSjqTIGcrcXDg+1rVxRh/stXZ9ieWqyCsV3DBAqjjlKvVsZL6j?=
 =?us-ascii?Q?/EsWaLKMS6xetuOSQBVgB8t53ZAWyq5Nkrdery53PqvikdkEPvRioQuR30ac?=
 =?us-ascii?Q?WLvARGCSYHgHPc73orQX5Nm3hIRpgaaOFLX8qxBg7lyeQp/JnErCA8+m4dI3?=
 =?us-ascii?Q?oXe6fnKVwvxjMu1Jfe/Z/4S7gd/soRgNtA7+Oes542mqQauI3jIPl2u3wq42?=
 =?us-ascii?Q?zFsmV9qarEFpTVNvP2NeWjaN4mKNFCotvlu9Mp4vu0GdhE8Fs1uwpAfDU3oa?=
 =?us-ascii?Q?R2qdNuWKNkswDxVtgHQfuRdyW1ZvQeJr2VKWLFeoD/dYBABl1da/JAm8/QE4?=
 =?us-ascii?Q?hZyqcWt0+dz6wtFZ/z4fI39DMDBXTXzFAP8Y4//osRtyRsKlV4kyMxmV5Pyk?=
 =?us-ascii?Q?t4pMMN9xuvBh9heFAufLK+BA9Tk4ZEdejVYufnO8usBZipOmatosusg6iOTJ?=
 =?us-ascii?Q?ngwub/kG0KJhVH1qejH+a6mc4x6kbh1Q3gCQozk2xoEqTLYAnyLb7AiLm60a?=
 =?us-ascii?Q?7SWo6/pbt8norTPUpBqAeTifSf4kC10mGcb1WVG2fsGjxVgw3u44zOP5DCKo?=
 =?us-ascii?Q?FEqjgqaCcZl3hjTMu4YPfuWgGdl2dw57hpjYCoVKY+44pGP5lHrzcbRa8qcv?=
 =?us-ascii?Q?BS5vnc3iLhkfRHIFzhOJsNLgD5dBcptD/h8BkKbFGJAXX5nDpnRa7nrLW6uL?=
 =?us-ascii?Q?58Qm6gPgYkKSt7CTe/Lx7AJX0NAWD4oqM8KvdgvHssX/NNcHzAF+0XHRtndm?=
 =?us-ascii?Q?jfEZBBFKoaMZQlC7uq/+uRXj1yQe1+KFsf437D8WorHobDlJ3c+wOXd1UDSr?=
 =?us-ascii?Q?RTA1fqywNTDPyXO2w/8HTv14JLv+ZbQunq2wvZjw8iRoTw4nUpt4t9r4RTNM?=
 =?us-ascii?Q?bdTdoM+/6A8BdADLaW5ZV9Zzu6Jc6Q2p7sJFf3150chDp4so3jAX5I6D6G7D?=
 =?us-ascii?Q?hVkWKzg0m+BZRMvo0nNk9EFo9+y+QKHx0cQP/oe6FtjhkXk6DHchKqQIbJ10?=
 =?us-ascii?Q?BKLtaSvQEgQ0ypNjuaEgvoAira6mUGaBj0OowdeeogoAnHDiCwBUIdBODUt5?=
 =?us-ascii?Q?+I1VF9nl3eGL/HZaor5l/tUhgTYI/nINg5zs84ykDkP91jjku/ki/Wd4/7WR?=
 =?us-ascii?Q?dzgplnlvNoIVA8tUfDdCspNNYnY5YaTxzSp/GKvcB4QdUFp6q0L1rxyQ4GOo?=
 =?us-ascii?Q?rjo3GYnWN04ocihbI7jZTvJspYP4XpoW3sxgn6npHAAgn7rEjrhj849rLXcZ?=
 =?us-ascii?Q?knVUf7XBASBa+HR4bupGYMQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d37ed8a-6286-4667-7f17-08db1aa5df44
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:39:52.3110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZI48qqUWYMQqWk7/7+gb6ay3i0hZdBW3W5D4HGram+cZe7Y8IcBwhc1biCRel+vNRy3M8CgY7vw51O+/Te9Vmne2awpzVkg7EEidDP2UnHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5300
X-Proofpoint-GUID: 1wzJIDUkxpFpZgPY9IhpLT3bpaRvtxil
X-Proofpoint-ORIG-GUID: 1wzJIDUkxpFpZgPY9IhpLT3bpaRvtxil
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303010181
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

commit 4ab3a086d10eeec1424f2e8a968827a6336203df upstream

Use spinlocks to deal with workers introducing a wrapper
asus_schedule_work(), and several spinlock checks.
Otherwise, asus_kbd_backlight_set() may schedule led->work after the
structure has been freed, causing a use-after-free.

Fixes: af22a610bc38 ("HID: asus: support backlight on USB keyboards")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230125-hid-unregister-leds-v4-5-7860c5763c38@diag.uniroma1.it
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/hid/hid-asus.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 9f767baf39fb..d1094bb1aa42 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -491,6 +491,16 @@ static int rog_nkey_led_init(struct hid_device *hdev)
 	return ret;
 }
 
+static void asus_schedule_work(struct asus_kbd_leds *led)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&led->lock, flags);
+	if (!led->removed)
+		schedule_work(&led->work);
+	spin_unlock_irqrestore(&led->lock, flags);
+}
+
 static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
@@ -502,7 +512,7 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 	led->brightness = brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
 
-	schedule_work(&led->work);
+	asus_schedule_work(led);
 }
 
 static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
@@ -526,9 +536,6 @@ static void asus_kbd_backlight_work(struct work_struct *work)
 	int ret;
 	unsigned long flags;
 
-	if (led->removed)
-		return;
-
 	spin_lock_irqsave(&led->lock, flags);
 	buf[4] = led->brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
-- 
2.39.1

