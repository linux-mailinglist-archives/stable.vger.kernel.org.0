Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFDC445456
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 14:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhKDN6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 09:58:42 -0400
Received: from mail-dm6nam11on2127.outbound.protection.outlook.com ([40.107.223.127]:37057
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231166AbhKDN6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 09:58:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kulYD6vk/yVEq8ViRibkntqGoixmf7T+cFjMuwsQrEqy5iWlFnqQhDIn2SZCuymOVE13KIm8WIc+2iReEcRCJD1F8U4dNNq3wVkJe0Axgm8s+N3prBgYMf4UoAN06LF1Ks6IFZRtVyvq64ejVdb1/WtA3pv+dGhTcIV4UkozajiryoQQ+ksaQMhmmFXEoeMl+wvkDrRLv7OXh/oCCJ2VSW1oDL8dQmS/uQ7mfteMGClMZ9w/LOtaNq3IDIDgS/SrYviABWTihhmsbX1PvgL5o+fueQgnhHZ5dPMRkYy6v20d1BygfAW1rBGDp8/X2kNw9JIiQXrkL2+y2mO/3Kgtng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGpTztVlugx6+KA6bi6Z8df9tuP4Sd2/nFdiOxVi4oE=;
 b=Sbtg8DAOPKZgULaRcoaEnT8kyyu+Sl6hE8o28Rkh9SzK4Srp2zxxgxvmGXW9H0cSaZCPFr5SXib3IZ3my/iUF0tN5dDK6q0Jt9VFxhgi8hjeIs3YURnS8WZqmoFIOmihakLMQG3W8utsTBhsp1qCiz6+8F8O8JuCK9De8e4J9ONZVRMjcGNyInf38rho8hK1x/yF38llVXRVQYP4efjh165wsRLUGqMISpETXT4yAi1Zc31G1vbCZq4i6tN1Qyqys+SsGYxb2BokIIkyt6ByfHuMJEzun9uDGk85RGr9w1pKyUSeIpKrgBTISG/BdytxF9kBlN3PLg+uJGL2C9bZ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGpTztVlugx6+KA6bi6Z8df9tuP4Sd2/nFdiOxVi4oE=;
 b=WP7PxDSjn6JYDswZN0j1ssagkPplJwrJfUCzNWcIlz3aWuZQluMlsdjpstZGVaKJ5z08aJIzGWURM//oJwt1vNGsx2gPrXbuPUWJl/DqClkDhDwaeRS7MxMiT3Ft9QYGYh5ETr0rk895j73YMsGKU/hsyD0qfgvyNIDLCfDy3PyyRzDBzKdELzFshoJYC9BXI0fpWq7tlDiZHlIW4QJ4OnMdO4+wecmlaN6Vl+i7VfzQPiixFSd1FqWaXLc/zlx3Z/sZnf676Ufgcga8bftlactZVQ50LFWWrR1cgQD12wq4Kb4hVizoF5kmbB/+1Q606XGd682nmYtCSzEfoAbleA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH0PR01MB7107.prod.exchangelabs.com (2603:10b6:610:f1::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 13:56:00 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 13:56:00 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.14-stable 1/2] IB/qib: Use struct_size() helper
Date:   Thu,  4 Nov 2021 09:55:44 -0400
Message-Id: <1636034145-7962-2-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636034145-7962-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1636034145-7962-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0019.namprd14.prod.outlook.com
 (2603:10b6:208:23e::24) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by MN2PR14CA0019.namprd14.prod.outlook.com (2603:10b6:208:23e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 13:55:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 819abe76-2f1c-48fc-158b-08d99f9ad541
X-MS-TrafficTypeDiagnostic: CH0PR01MB7107:
X-Microsoft-Antispam-PRVS: <CH0PR01MB710711A9776F0D201B49B867F28D9@CH0PR01MB7107.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDgj8GmHZpYbeBsSg0ZM34vB97aV6aEPXh6wfCS5EUlhL84uLty7203+zyLA1k7nuOwg9kf4dIfH2qPAqjftYDlGmbOcyB8QkGBToYLHco+nfkmnJ9EIlsKseFbRWdbymx159m2ZXOQwLObL2XdE7eccMiyJU1c6G52IEEJEs4fuCPPZtMa6Nyiit5qo4J7k729tv71o13JCXeWPeeHKU0ssWkaMLt9dQqu/Aqfi6Iemu1shL/6Mh6YfNFfar8gqO84LuhTcjI2gKzPCtXU5yROSRT8iRgnCKl97sVs16/7/khxyjehJ5Dak53rBgcUk0fSmAXEiD8AuZmqWDfIWWWm6NoX/Z/72Tv8cbsG1xy/ia/sQXMp7bb6H8a3k+/n8q05v37y9T0R/F96BSV95lKnO1b9c0vFPbjH6dDQEhDoUJMu5vmWofttRmnK7Eg++dWTq/2jV2ExYYIlRCnWOI2rSnl7oLNevslVuJMaXtq5WgrUz77f9L3KcxxXwnwM86b1w2mXFiBoiK5F1GjiBVd7QvDEIoo1FlLm/qHSHiaqxy64Xb9HLBK3ig/d7qqeN4d9vIGLfnoHn4vwyKhy4eVcPuv6YyaNLJwhCSUaTGikbjz9b8qpim9v8PJ4JhPHctVNtLmymKhDgqaYUY8Z54wv1NEBXhV24kOR4XbhxV4Zaoqx1DnrUYLSAV6nxuWOzLFPzKuphFaoryxEzRC+r9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39840400004)(396003)(2616005)(956004)(6486002)(66556008)(66476007)(83380400001)(9686003)(6916009)(508600001)(66946007)(316002)(36756003)(2906002)(86362001)(26005)(8936002)(38350700002)(8676002)(4326008)(38100700002)(7696005)(52116002)(186003)(5660300002)(6666004)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OhGYtzX3Zt5lc/ilOS1Ar96zIe95xIV9yVqrSLmPQMkBTzrkMO/VH7ZHUi0p?=
 =?us-ascii?Q?7KBCjX5oZZmvdql3G7tgtA4rulS83hEB4wPqH/PAqiKCGluvlvHoTpYEbXmU?=
 =?us-ascii?Q?40wPJWtIolobbb5RuCjZFLAT2UumoSutI5UA3jFJW3Uq2p/myggTOBQTOdUP?=
 =?us-ascii?Q?U78kqVwS7Ifk+5TGKrTNNyV9KbJ2YIed5EDDwgTNd6xB+G2pvKZEcr9YxKls?=
 =?us-ascii?Q?Jipe6pCnkYr8SrP8lGBGPxijJcOdK8saLpRzFbXkGHjI/AnucUXugglYnxvL?=
 =?us-ascii?Q?jHwtWqNGJRBbJ2q6FOtRNdRv6lYQ+yC8/tDAmsMif7BzKwWFxtHT0asU50/0?=
 =?us-ascii?Q?olcGzj1LxCL2e2/BjF/vQVcczb+0PNN7FBkDEe3SDU8VZMK6ivEaUuoy6Fl7?=
 =?us-ascii?Q?ENWYLaVRYv9TJEQiDY0Lz21FR0LHGrmTeQuIRYDf2G9vBsDC7T+7z5yDG0EO?=
 =?us-ascii?Q?wllvTwew4r+i0qt+JirCJCuUxm7Di2HzT/K9n0bS2OyUDgIx+GOqJksQNFRf?=
 =?us-ascii?Q?MGOD3FWFIEdMostRJOrZtL7RZzy3zJ/KP4gjlZiDr4+8zhACNtIK8IQnxvwt?=
 =?us-ascii?Q?71yQoZSlDHPQ+8TDSVtLChYHnCSjWF4C1899yQ3iYHWzIYLW/XM/u7I8CaU3?=
 =?us-ascii?Q?tqkdfZJyPQ71v/cij3Zr99QQ3nDtimUKcw9so7I8XsrAukWIN1j9HLYFgPZc?=
 =?us-ascii?Q?yHt+KGNBV+JWJMPIOhkYTMJS8Kb/RqEbGCpgYhAHQpDSNQ5I8rlkw+CnLmFE?=
 =?us-ascii?Q?74oOdOgrJcYWtxZc4SWLvEDj4fnr8Bf0Mldzque94uPlb0Xg4r2XkbaVzUHA?=
 =?us-ascii?Q?4K3xFhzX4MMkB+1KoIKIxcejGasvbX7WN3kcesj3FvLY99DdVXJM8L/F/IS5?=
 =?us-ascii?Q?zIt381Y2JUXGF1Pb07hO2ymrx2Y0N/Dni6q/w1k/lyDawHfvHPRy131PXUfB?=
 =?us-ascii?Q?LnHd5Sj9+QtcykD2JGgJ7w3Cxhj8zY8oHiFGj7Cfit2oyMzBpQ/k4IOqff8r?=
 =?us-ascii?Q?/MrL70GUP1McLtjUvU2iRnABYpvy2qJyCs+eDirRTKKGgLZwX3fuwVxLgt5E?=
 =?us-ascii?Q?6+EfR9dI3BhljErdFtgPcmcnxIbVtWBERNz3Mu9gqtVjOMGmgEYwq+upT26n?=
 =?us-ascii?Q?lGQAjXEnj/gGKRc0GuIbt/Mo1nZBO1CYdwVZ8EsKgwvXIDiJ9UTdN7YBloK8?=
 =?us-ascii?Q?SfK7IckhGgXWa49jBKOW/JLLxxCB+sxif4aZtBHdE7vhzHpFsQ9iXOju/TJH?=
 =?us-ascii?Q?IqkEo0et2sRJLRo63zcUEjmCIZwVai+SNISUGd/s0kyfHMnPwRWrB2NyrG04?=
 =?us-ascii?Q?knph6smpcPYqwHj125g/jtkipnQ2HRraEtrC8/vAEpYhz85fXKoWTJoN8UE4?=
 =?us-ascii?Q?sqmhORykaZctf1y6XhAoylXXIvij5fmKjYvc2Ibr1fHZ2AH5np5fSxUPEdGD?=
 =?us-ascii?Q?E/9vUiwKQmnnJs5gSdU497ANNy8x1zd+KOBYqW1c7hkFrukKsNos29UcKDW4?=
 =?us-ascii?Q?wZ/Dym/Gh5DWEy73EnLQf61jVwezH2UtMzO8cDYiHwickKyHYYnplBCmRDdx?=
 =?us-ascii?Q?e62cv4i3BhdE2r8RGdLrqC7Pl1KQwxV9y3O2Amv++T7NyeZYSzNdkEu28jbT?=
 =?us-ascii?Q?QFmySgXIIcNKwyba4a2UU3AiIzuS3MucxuZ7OVD/dNTvLhvEHaWu8o85uaWz?=
 =?us-ascii?Q?AoXHwSkPxvAgmkLdZmTMWs6qr6iRBHizSqMS96mTuAjpuMnYXCi2WFmvy1m1?=
 =?us-ascii?Q?5Cq4HqD5Zg=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 819abe76-2f1c-48fc-158b-08d99f9ad541
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 13:56:00.2990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srWP3Vd5FHn8mTT5wscWbg17Mpkvi6G63kriEiqH71qLGEbYxmS+41vKTxEzqxy0VhiD7jKaG3He5/6zXhyAPpvni538ztIB5Pzn+I7xiyg3002IUkdIsydQjR+QwHd5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

upstream commit 829ca44ecf60e9b6f83d0161a6ef10c1304c5060.

[Apply to 4.14.x]

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
- Needed to include linux/overflow.h

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 926f3c8..ffb4257 100644
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

