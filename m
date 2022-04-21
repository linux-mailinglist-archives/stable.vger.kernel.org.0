Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FFC509DAB
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388375AbiDUK2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388517AbiDUK1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:27:45 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C1AB91
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:24:55 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9s7K5014742;
        Thu, 21 Apr 2022 10:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=li5BqRBlHCcxy0zk42kvSA4oTRQEwUPjgW1sz7Tf+lE=;
 b=iihBI28HW42S/fvNWyK3QIR8JLPiaI2v1ItoCMnFA3z9ThvH2T+zZaoL9icGBNyWKvJ3
 2xGQ/SV65xF1clkZaGFTxsgf46OaDG/CpT9rwqPfk8iu+aNL6xkA3kKWDAXTEnDEj28v
 JxomKtczKIa22d5jmacvge2Ef/LWNQHnqRnGAdtwaSCzlBdfvFRwiuKpCT8MN2eI/KJi
 2i2M9wizbzaLPpJwpss3aEFODfiKrRgTZxyKNXLnK8IKxvgF9uKR4qpwdAWxVENgV3y6
 KAbA2e8rPnwi4fUHHCOUwyD4lsoNVfGZtnf4KKGMMJGaecIEffQe6Mc/LyfCOy1K6xEa UQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpqn3qr3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:24:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+uxfa00vtGBFi/+YbcGMMWw+8NIudLnIJL0O+ZbBbZSde1zS88SgwPMkM789bA7ywcNg2vpXcA4/+wGgFhs7ojAhw3KdvEL/VzKvM+nsvZbO4tViWPQAHeZPJX2GuYa79QSm3LXFs8psBxGz0xo5hmHZ7SC6+tCXjrq2hJW/I4RUltcwucAU9eawblq3irvVfNmZrcpkOFcHnKrr100fXf/z11inBnnOeG2vfyHZKkGaLjg+X4ePuhbRz06VY4OFnXty//3ksQLmU3FzRqnGEhn4Qnc/l6nY4AyeW+lxAHp5st0h3jcwVhG5zIPyqdQ8K+niKO3/q6Y7hn52HvYBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=li5BqRBlHCcxy0zk42kvSA4oTRQEwUPjgW1sz7Tf+lE=;
 b=NrZnQ8M3FkOTyMOmnIDyajKaPGbgY7gSC3v6Gr1DSJokIP4gwprzTCAgg71ZF03kcXWMZqUu0BzcVA1+Lm8ZUnDeDDr6T/iIv8xv8jsFSENeVXvEx2ybWycKtOXNJIvpOLxpZA/WEPOGWXmhD8V+1AtmUGx7wy90nB5lIupgJb6rb6VZtDT5RP5EpBO+9vWmxPX/lv33mzhc6AHkSjw3ppZQfdftvubu5idMEc8ROqoVEsriXmVU923agyjeBYd/mg+7v8SIorIM5Z5feMyGWhAhRgHnCw0pZcRgvUO/sGnnVUK9TO1UhAC5AlyVnx9KoU2DlC/+tQbfSjzIR8pMxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 10:24:48 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:24:48 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 2/8] ax25: fix reference count leaks of ax25_dev
Date:   Thu, 21 Apr 2022 13:24:16 +0300
Message-Id: <20220421102422.1206656-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
References: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0092.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 336d8e58-a5fa-4f27-212b-08da23812996
X-MS-TrafficTypeDiagnostic: SN6PR11MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB264071204831FE7E5874C137FEF49@SN6PR11MB2640.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/UViwDsNnzUPW3zqyf9Thv5jj3kRWzQnU4INFYA7ktiend42QzTzo8FeA+E5D/pZCFMfNv+xhi8LWRqx0W0fBdjP0Rj7z4deZvVdhWSNs5qaQfzu/hDw4I4fVrUX/q3Y3DWMLN3k7eVbNPkvX8RvIpi8ATjKs3tAyE9+36WY8g2Gas4ulS6vnT/iQDCagaY2kU7kzHkC/7D4rGlKNCe/PmdypWjehIxD/udQzVV8T42zoFeusRbT5sDxyozymTAgIqmmWHp/7RsW7QdZf1bLIefC8A5R2K4z9xODyytf7aszmNhcRwh6qDt4tbPz5O0jGRsKo8jSM595ADplOFaNiBGlQnvGm/JJP/2bhoWQXzokR07KepWcDmzHnbUt9YV+1/9hn/H68etCKeoU+I//mLjxFZIJdMM5os1e/9roUCtZ0QyVRwP4pgG/J2k8KkXxSUUXceBk1mmqGtSwrFzLzCMzOvlCkzx+JbdaWoiCaYS0ZHbuRssaPcu+hFQl1LCcSCzIQrRaVPARs3VXgCwpew686YFEk5/7VyRvEC6C6i8bQOPriYT0B6tIWe9OKFyGoyNcMIaBEyxxmZ8K7O990cTkgZeGa9X7klHIcjEZKpOHKhfkZOU4ALd4d/8bRWyJmvaANIzOp8AiiaAJlotkC6wteGSnX2kKvgYbZGds/ecu1vPGIeuKEZMe23jNMg6S9M/YCslu8hI9nnDZy+F29qOflkeKYtzj1e1kNLu04NYgmQrG7CoYeUdalQSBj7TXclCM0HgziGzGglmbRx73Ehk7WMZZAM1WdjG7ONulTc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(66946007)(36756003)(83380400001)(8676002)(44832011)(2906002)(4326008)(6916009)(5660300002)(6486002)(6512007)(8936002)(107886003)(66476007)(508600001)(966005)(6666004)(66556008)(86362001)(54906003)(1076003)(2616005)(186003)(26005)(52116002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4T48+kcKSto2iTLmuWMIYqVUmX0ptJEiYlTUSbiQVopQ5/4E1uf39lNv8CPW?=
 =?us-ascii?Q?d4IsaXGG76eyOKP9IihxcGveWEjogBRASr022Fxv4YrMk402gJVvUMfFD1/f?=
 =?us-ascii?Q?nhi4mBJScZAWG4Wk88pGlyv9aly3PFKCkiyUn0NtTYPDFDHo070xSqbUotFf?=
 =?us-ascii?Q?AEP/fwkhRC7BmitUijDH4XRbhtV3Vc2lY7rPBJf00vR+lgfFnWqgNjVaGIWR?=
 =?us-ascii?Q?GWd6UVEJkwwHToR2/b194k6HoE39GEkni7ov+KqPrDMrFcRK/ez2xQzDB5kc?=
 =?us-ascii?Q?ET9jvOZ6iJlsNN7YzviOQ7cvvpBY/FvX4jh6G6+j6pSaeMyTj8LB6S6DAATq?=
 =?us-ascii?Q?ot9c+TN+KJHlBElC24PUoYEobwKl41keaS4mztY3Kb4YL9NCFXLgWOfxxc4L?=
 =?us-ascii?Q?Kb1zD72cZGM5Adsogj7fUacDatWc3ZHPVg0EKLCjNsmtYuBZdQ8eY2rMI7ZA?=
 =?us-ascii?Q?toxUiJ3g+2DOayU3BumBPplFoQLcn/DHm7NE38grUaO1xraBmYvC+nsdmEai?=
 =?us-ascii?Q?HjE/BMxQl3BWQJ3AL7WC6wtIV/7RJ9ZOiu9R3Gz3rgq1QV9tirVlWApLAVgy?=
 =?us-ascii?Q?SE6WDppnjsxusU0k95q0mWNLo95b4QRK1DqThPSf03L/Dtg2H63WvLEZXMBU?=
 =?us-ascii?Q?UtslnBz3C4GCO/pIGl3NoXPJYBnBWJHahAsg2JZdfGGvyoMlW46wgUfnQRg1?=
 =?us-ascii?Q?pAOYBnQbHAoQ1McFOn8WHHibhkgavX4/rkEAHRauePCeDRd6fzssod2pesXP?=
 =?us-ascii?Q?gvGvgAxtgVxEYEHifcVb064lHqWdTEcA+ICmMysIOsUM65VHH4JaUeEeDehD?=
 =?us-ascii?Q?zKPGaGuIeUSLah6GZrWgIEOciJ1Dt+UKGtRKlcAajSehGazIoKzJVwT5lBKP?=
 =?us-ascii?Q?pVl5RJJGQglFa7zOWwslsnL/WpLGTJktDI3YUbUfIBuQB90VDoVhT2qEaHft?=
 =?us-ascii?Q?C6XG2YtpzdpIkpCarAFoDh0yNwu3rdlL2088KUx1uYkxUGWDHNIWLwEqFb1X?=
 =?us-ascii?Q?wve9gwl9DU7MmgivIq0k6P6ge7EzYS33CKFUH3EEmiM2Z+hmIbxU8JWDxgKu?=
 =?us-ascii?Q?90p8WY3tdeRu8fMNOY1uSPeFJXVqmlP+H1RIv3a33dGvjRlvEMTEv0cqL2wu?=
 =?us-ascii?Q?g4rWpDvrxa15ltJcEMdKClzKOluwDARU1WQ//TYopf0FeNVcOyip1O02M3dw?=
 =?us-ascii?Q?mWbDwD4DQFD55MxzXbWr7Vm6YMpJQzBjGAIivV1E4c044CfUnXu16kFD1yKO?=
 =?us-ascii?Q?F8Z0uDwC2kZ/xOH8vkjmM0eGIx6eM7PalQAv4xwP/xWsehXqFgyL3gIaRko6?=
 =?us-ascii?Q?VhG1oj7gtHnIKBgdyXwiS7o6LcGVNnd42zmoXb6g8vxywpWXaQSo4r/dbZEt?=
 =?us-ascii?Q?dQIfU1ojzXwgnAEbN15ogh2JNuE/vtnHfrWrGPXVHyryA1csyrRNkUabsIz5?=
 =?us-ascii?Q?WMMokuJmV9Jv4OvMUQQAm0yoDmpAckWjwOtBu79Orxfan24va6XbNP6Nn2Zq?=
 =?us-ascii?Q?jRokZqT0IcsIdkwnbq62sECBtTdNTomQKnxzquN4TBBgjJHKn4/wGuiSI7UD?=
 =?us-ascii?Q?ektkxaPy814qDi2jUC0bQB69cKWwsofltjMeusoahF0voHHeE4RuR6D6rz0y?=
 =?us-ascii?Q?NXvK8sm1uBeP+wpaesvdvG3Zt21Kyo/N29preF4dEVxjvLqzO0eoKCqLw1yl?=
 =?us-ascii?Q?CujClox9XAzqDx2EYahNplMJb9xiQuE+Qi7k6V54wOA7UU3E8VnuIqraBRkW?=
 =?us-ascii?Q?zEyViETtQm70HqPaG6NJTPsDUwXr4Qc=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 336d8e58-a5fa-4f27-212b-08da23812996
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:24:48.2898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZM/ohI9YCKom48wnygkmV6AHqQejwUAmqBIIEFxot8BLDLNqzZM9dqB6kiUmxoK4JyAzw7gEZEVIFy6v21Ngz+a5V8p3N47InhRAbFCvKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
X-Proofpoint-GUID: rTv9Qagg480yqZlKG2qRlxlI7VN1Q2tQ
X-Proofpoint-ORIG-GUID: rTv9Qagg480yqZlKG2qRlxlI7VN1Q2tQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1011 suspectscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210057
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 87563a043cef044fed5db7967a75741cc16ad2b1 upstream.

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev
to avoid UAF bugs") introduces refcount into ax25_dev, but there
are reference leak paths in ax25_ctl_ioctl(), ax25_fwd_ioctl(),
ax25_rt_add(), ax25_rt_del() and ax25_rt_opt().

This patch uses ax25_dev_put() and adjusts the position of
ax25_addr_ax25dev() to fix reference cout leaks of ax25_dev.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220203150811.42256-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[OP: backport to 4.19: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/net/ax25.h    |  8 +++++---
 net/ax25/af_ax25.c    | 12 ++++++++----
 net/ax25/ax25_dev.c   | 24 +++++++++++++++++-------
 net/ax25/ax25_route.c | 16 +++++++++++-----
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index d81bfb674906..aadff553e4b7 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -291,10 +291,12 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
-#define ax25_dev_hold(__ax25_dev) \
-	refcount_inc(&((__ax25_dev)->refcount))
+static inline void ax25_dev_hold(ax25_dev *ax25_dev)
+{
+	refcount_inc(&ax25_dev->refcount);
+}
 
-static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+static inline void ax25_dev_put(ax25_dev *ax25_dev)
 {
 	if (refcount_dec_and_test(&ax25_dev->refcount)) {
 		kfree(ax25_dev);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 56776e2997a5..f605549fd25a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -369,21 +369,25 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
 		return -EFAULT;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
-		return -ENODEV;
-
 	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
 	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
+	if (!ax25_dev)
+		return -ENODEV;
+
 	digi.ndigi = ax25_ctl.digi_count;
 	for (k = 0; k < digi.ndigi; k++)
 		digi.calls[k] = ax25_ctl.digi_addr[k];
 
-	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
+	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
+	if (!ax25) {
+		ax25_dev_put(ax25_dev);
 		return -ENOTCONN;
+	}
 
 	switch (ax25_ctl.cmd) {
 	case AX25_KILL:
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 76d105390706..55a611f7239b 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -88,8 +88,8 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
-	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -118,8 +118,8 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
-		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
+		ax25_dev_put(ax25_dev);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
 		ax25_dev_put(ax25_dev);
@@ -129,8 +129,8 @@ void ax25_dev_device_down(struct net_device *dev)
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
-			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
+			ax25_dev_put(ax25_dev);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
 			ax25_dev_put(ax25_dev);
@@ -153,25 +153,35 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 
 	switch (cmd) {
 	case SIOCAX25ADDFWD:
-		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
+		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
+		if (!fwd_dev) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
-		if (ax25_dev->forward != NULL)
+		}
+		if (ax25_dev->forward) {
+			ax25_dev_put(fwd_dev);
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = fwd_dev->dev;
 		ax25_dev_put(fwd_dev);
+		ax25_dev_put(ax25_dev);
 		break;
 
 	case SIOCAX25DELFWD:
-		if (ax25_dev->forward == NULL)
+		if (!ax25_dev->forward) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = NULL;
+		ax25_dev_put(ax25_dev);
 		break;
 
 	default:
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
 	}
 
-	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index cd380767245c..8f81de88f006 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -78,11 +78,13 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_dev *ax25_dev;
 	int i;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
-		return -EINVAL;
 	if (route->digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (!ax25_dev)
+		return -EINVAL;
+
 	write_lock_bh(&ax25_route_lock);
 
 	ax25_rt = ax25_route_list;
@@ -94,6 +96,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -104,6 +107,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -111,6 +115,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -119,11 +124,11 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
-	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
 			kfree(ax25_rt);
+			ax25_dev_put(ax25_dev);
 			return -ENOMEM;
 		}
 		ax25_rt->digipeat->lastrepeat = -1;
@@ -136,6 +141,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -176,8 +182,8 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -219,8 +225,8 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 
-- 
2.25.1

