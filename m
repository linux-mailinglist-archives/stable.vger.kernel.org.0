Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7487F445644
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 16:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhKDP0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:26:25 -0400
Received: from mail-bn8nam08on2101.outbound.protection.outlook.com ([40.107.100.101]:21537
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231283AbhKDP0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:26:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVJbji2cWYH/h1dluO+BCVdjYP/yKNe0WI53QflJByjSKx9cMc6ASU6UKshmOVCpwo8Hw8mV606wIeiRxk62BovPIy7wNLa5VTh70X8gxbq19x1NYJe3uNHaICM9TpPTxa+MMRycqcHKh3AZ6tVFCbn/y21oBZvK5eRyMGuy5t0eydK4IFyIa2vYCDNew6mx7nNbVCUIng9WWprIE1aJsoMIwRoOFvPe2khOqD6qfpDXL83H5gqQNGf5B6rAfE3kEjHOgCcLyjY0gWAugESC+EgOjKnC19n9d+ZeuS6p0w7Lb9JEHhL6emU06e9TEkIvZ9v/1x4FPXyiq7epnUXVtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dov9bT6osIFT3vlrbvXm6FygaGFhd9kwnbAF+vmUPik=;
 b=k1N2QaPUBmRiydy1k6QxP5BnxkydS1U0xjMIZ4gcTV6OL+lHECQOc84CbsfoIys6pcmbRATsQyVDmKm33jq5FlHJ92Ghr6nAf0YYYaNt4l+U+mbtwvmXDee5QKJNhDahcBEDkIRZ58d84447aay1aGZpov/O7UPZnwqw+7r6QzSle2QpzwsjebchWzgEI1V6k4wlAs7zhfugvnOv/HeWdl2PdZUBj73YNMPUFuezogen+Zf/RENylYVt8yJpIXq7SVK3K75q1sSvL4EfSrbXx8K34IgIkWiCacfkUp7MFXQ6419hYSVyBfxB01O0CXUJI1aqAbVLk76sviN001R4Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dov9bT6osIFT3vlrbvXm6FygaGFhd9kwnbAF+vmUPik=;
 b=eEFReEtBsmGRAWXrAEW8AefP3ww/cx/CjWeg25K7THeMkJuJDsmkVPuDlaCXhmY5xYGSyjIw3vJbGjTD83i0zboS+sxPEE+gkXr9Ant4Notv1tOZZ5liLjG0zpYPAdasldkiUQlEND4y8ioTzgQY+iNNTTa8oNVxAWPYUGIDH+HMo8lDMLNXlBRB7RELjLuBZxxdJBXXC8A9Nn0DHbZHa4vKM5o1X95q9+me5KCVJ3JRaB/JgF+UqpOQ7CClKk6gXevLWp+RuU6XKdwXTn+OVzAQAWO4YLOTwoZgstqoE3nVpOSvHsu1S2Gi4/vXREEa3hwsGB7y/1ThDiIkvT22jA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH2PR01MB5767.prod.exchangelabs.com (2603:10b6:610:44::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Thu, 4 Nov 2021 15:23:41 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 15:23:41 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.9-stable v2 1/2] IB/qib: Use struct_size() helper
Date:   Thu,  4 Nov 2021 11:23:35 -0400
Message-Id: <1636039416-138753-2-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636039416-138753-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1636039416-138753-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0011.prod.exchangelabs.com (2603:10b6:208:71::24)
 To CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by BL0PR01CA0011.prod.exchangelabs.com (2603:10b6:208:71::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 15:23:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2cbd15a-d125-45ac-95e9-08d99fa714cc
X-MS-TrafficTypeDiagnostic: CH2PR01MB5767:
X-Microsoft-Antispam-PRVS: <CH2PR01MB57673CDE43905B8AF0B72B6DF28D9@CH2PR01MB5767.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KHecnaTi+rHo+vmOiBd3FVtj2TGhYfmGlwrWlBqVfYRZlZjMWVbIcFi+Z4AcGtzl6/VNqIqiq/IGctExYhxrFBFlhsKTPBxQjP86pBBRxhus6xJJ+qcYMGA0SIiD+51JDN0nmPU1CFJ2qOp/bUyCXhTk/W/B7OD2VamiBjE6lk/DJnWgiS08qxqUYRKGJFfV9MtCzI4yKbdPOVzdfOv2iNZdgzeXDgiiJLy5nCjEIpSkPcMjbI4icEgiXHStFpsB80a6s0bhUYjx+6bk8N6zp23Bj3IQNhuErBWoU1OA6ULpLBYwBP9Y4NlpaeN08ki4iMkrJmf++BG6sYH+Kj+kWMf8CmWz0v73PpecC6gJKMSO16v6cMmXLgjqgRwKlvl1JwJ9Y6E6MWnLLxHOTQ+Vfd3Z9Fslgylb5N83cM7xPfhdLQTMAvDtj4WeLxoHVByEFD+coOR9SI3ii64DoBMcYbTB3VWhpt9z4aysmvuX/Gfdzkb8/O3dTaWB4wForTRqz/KLcyn0KKAV0F898Lz0+/In+6OXUyZ2vFqUTRZO/PmCH1Ly+X7aTmLJiSuO8tPiq6NeteN/bLPy3S93gkeoHqf2H7D72yj3oUrAkOMpB8DU4SpLsm/KLC1yWIatz3e4r0+t9asXXboCpGWYX/XjJDFQOujg03Wb6HWUzILPJ9blGweP4BpgPFjHHUF9jcEZV4GFpqgFEpKbfzpvK/X7iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39840400004)(396003)(376002)(366004)(136003)(5660300002)(2616005)(66476007)(186003)(6916009)(8676002)(2906002)(66556008)(38100700002)(38350700002)(83380400001)(54906003)(6486002)(6666004)(956004)(66946007)(52116002)(7696005)(9686003)(316002)(36756003)(86362001)(26005)(8936002)(4326008)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rfC56gBjpvbX6TN3cGBtSv4CPQXIw+/833T5qtqMp1TkGcoiSBVmdSr5dIBV?=
 =?us-ascii?Q?a4grS2XSDFNxJOszjkMt4KHzqN24Utn1/QisUVkm5zspeWXXUBYyKkqI6Vgz?=
 =?us-ascii?Q?7QV/DPsnbT3sApmW6lgmq6Nb/vDYDB1Fu7o5Be/ltDs7oonrSZ7dxRS91ti7?=
 =?us-ascii?Q?8z31E+zDQkO9N9FwGK/KHtABD267DlBwo6TYukJACiFg2h5oIHXbLJX7uqFV?=
 =?us-ascii?Q?OChclXAMpyhhPJ/OfMY8pf4Tzl34UBC/V0oFje7/OVXmyoh5fTJTqTyq+U6p?=
 =?us-ascii?Q?v56FAxgUoZjHph9T8MdC2B+ap7i6gRj1gD69t+dKiYzw2jO6ri3A+LHsOurd?=
 =?us-ascii?Q?gz1M9Wg8FPP4M00MaDy5qWPp+UgUmL4leL9E9XJNhKFvztml6k/aTUE82+2Y?=
 =?us-ascii?Q?sPElVIZ8BNre9J6lTZkPk1xI6eWUaAgKnIFLSo5DAVkgza/uJ1Ha8XXmh0wk?=
 =?us-ascii?Q?YwM7ZR8t5jS9DnIioQWKR4MVSMF4yFYLZZQdqqyK+rAYY1EEgo2OGxOVm0FD?=
 =?us-ascii?Q?WUlNjycyCubjT5eIiIg+kzFF+6Y+pPK16T9N6bXn5t3mwyHWpnD64I4OFlso?=
 =?us-ascii?Q?g17ZqUTfTZ2eb+QAc1tVnOREQQcIW1YA0KjOXK8fh+y7z7DZQQ9/R4A8Wvak?=
 =?us-ascii?Q?TcqiK/sf0D/ix3Kx0Ho7l+tjluRFzltG+0kx64qmtGB1S9WJoOJZkXGPck9Q?=
 =?us-ascii?Q?a6tgWFlBevPSavHyPtLdA8EqfOHegAr98W/bwpJS97L2XoUhDNMn0/SN78Hd?=
 =?us-ascii?Q?Cs0EMXyjPjtUszfqNs632MQ2GzuOfb2NdSbH0D27hgHPRlUjEJmUW3+b/tfW?=
 =?us-ascii?Q?pAFy6BZXzvbCU14eu1IZ1AGBiq9Xwlvc3n3wwpLDn1bz4hdmGAzWCRsFBlRo?=
 =?us-ascii?Q?OqWpjauW40v/t6/V6TY1wR/C+lHEcvFi9AQV1t387R5WyI38nUW1xflmuo1t?=
 =?us-ascii?Q?3Esqj2VOnDyu52f82mOXSj+B6eFYT0dXzzPj3iyth9kfj5AbELbZ7odeZnbg?=
 =?us-ascii?Q?ZHRpbi/0wGvbN17T52Zwp7aLFvCVYdrdFxTiCpRqcdx5ZX8Yzdjv0nolyPMw?=
 =?us-ascii?Q?sS9+37eM5f23PCS0eNI+8v32WrywqJQgxsvzNXm0jj6Ht4Z/OUzMSHkoUF1o?=
 =?us-ascii?Q?h/NBvpE1wwMov7qDlBpfz3umNRftBOnYxEPPWkLPSA/6Y9GJCp01JNntzxVS?=
 =?us-ascii?Q?H74qkrm17NcnNTIfUt+xc8jxD2BqN1a6FZofCCdv7k5PjeUzJlm1cFLt+JRb?=
 =?us-ascii?Q?UoDWBFk8j2BXaw2DxGqPS3kS55PC/MG+QbBXtrePegKWOw5s6J1ix8uAO/3b?=
 =?us-ascii?Q?78oOV3tknFfHwEZ1BJrvlPLZbk0cOr7btxORGXNhs8W78XEYkvaYKEw7KcCz?=
 =?us-ascii?Q?iajrNXppvK2VOWXzQnj19oAOIbQCwFraQEtxWHKtSwLtjZp816NvFsFrgSU/?=
 =?us-ascii?Q?pD4OdRC/s189uD9lmuNja0PDE9qBOdCc8T2WTafK7Z3ubvASzOkYs49fAAsN?=
 =?us-ascii?Q?LVRCVx41pioUWemf72txJk/2wGqyy7N3fzsUTtYBkSDEEY6idY7BbJTpsUTB?=
 =?us-ascii?Q?F3kkn25d612XvGeBwPfGMzmGMF2eAOvfp7bfh2DMl5Kc6533n5tcLcaBdgU3?=
 =?us-ascii?Q?fW3AIP7VIXd0bANs5qjVTg9RzdWVMvjiM2gX036HLPUbNwbTenVH4RNDhn9X?=
 =?us-ascii?Q?8jb8Sj8GuGa+zApaRZ6Lu6Rong6yB/vdq3oDqtP5KHA9bXC5I/8OyQyp5lio?=
 =?us-ascii?Q?DWx4QEaxEA=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2cbd15a-d125-45ac-95e9-08d99fa714cc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 15:23:40.9521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+HEubjcrAevBYhszja5zmAhyaFobPBBy/cBespgvmlFDypr4UhOAxF0P2EyhLuv7iy0ATbetCkbUUgFXO+5m+zcRkQQTARj3DbZFrI/Iew+0gWkb/hPN1b3V86q43o7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB5767
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Upstream commit 829ca44ecf60e9b6f83d0161a6ef10c1304c5060.

[Apply to 4.9.x]

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace the following form:

sizeof(*pkt) + sizeof(pkt->addr[0])*n

with:

struct_size(pkt, addr, n)

Also, notice that variable size is unnecessary, hence it is removed.

This code was detected with the help of Coccinelle.

Backport notes:
- required include of linux/overflow.h

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
changes from v1:
Correct signed off for Mike Marciniszyn
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 3e0677c..deef6ff 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -41,6 +41,7 @@
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
+#include <linux/overflow.h>
 
 #include "qib.h"
 #include "qib_user_sdma.h"
@@ -908,10 +909,11 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		}
 
 		if (frag_size) {
-			int pktsize, tidsmsize, n;
+			int tidsmsize, n;
+			size_t pktsize;
 
 			n = npages*((2*PAGE_SIZE/frag_size)+1);
-			pktsize = sizeof(*pkt) + sizeof(pkt->addr[0])*n;
+			pktsize = struct_size(pkt, addr, n);
 
 			/*
 			 * Determine if this is tid-sdma or just sdma.
-- 
1.8.3.1

