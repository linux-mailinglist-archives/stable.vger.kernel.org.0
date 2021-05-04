Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F024372F31
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 19:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhEDRtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 13:49:52 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:58177
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231959AbhEDRtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 13:49:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJkregKztfn8vYyU0HZy3ooSo+pjDr3G9/COWHfM4X2vkdpaG7Y87hkUL5rH45rt0C8oYa5Tt8IKhkORXsCHim2TygkRL/Z0FMcCIZq8Y17rXqyUy4x89vCtld03fE0ZFJHsFJzhBNJSkxRVQX+rA1WSssreFHmVjWIw4zb7jbq8nkSfM1pDlKBDRn/k9RylHYCuiTTYOfmQf9pUNkB7Ta7lcKvlYZDq9Ni3t+IWmAmiWcV91NgqxYmQxGWe5rXJX/YPO+hE5n6BeUnZ6YwF/lVu+mJFN0NKshj/zIxFGvscl8CkjOxiQVWJ6x2tB5tZYvT1nfXPzCTEFTen+lHdFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRNOiCEMgFUijmFNOyob22PGIttd602OVu1SEJeZldI=;
 b=iRvg6FV/YgDk2w17FawS7E0G8hW4MIX/ELZb9ySCh38Myr0RIBs87ryxEAFWcEXZc7qfEpFW4pIMkF9FuH9/EGi2lGzQmI6Ss6q1628s2h0QQ6IjigUIje2qSHz9PUeUpgSklA1v9FwL+Env6G66jE/QrxqqVPax0LGrKO0li55AiKVq4ugScrPuX3NyEJQ6OB1fDBSjof7+2SMGIe9nLqiHBb7Pp+Mzk/RlDBKxLqA1h1neJePYjCbdc5yilftEj0xrAcl/AeCjL8PwvIWm0Q1UmyYWA8kuvFdQtZCFdef0OYP1Ev3X4XUb65d2a/RO2t2lT1W9iDrW6LTwW7TQtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRNOiCEMgFUijmFNOyob22PGIttd602OVu1SEJeZldI=;
 b=p5j01bm+twR/6lpmzBEqnKN8henFDwanEfBK3h7xYF1uJgHTS8eTodu3WIh8KvMOVP4PV4O7k2gWyTW4IAeYtOtjdIQ4dlyql3IInUwFtgU2brxGVbKuucp2GfL+Lt9QCUE1x8SPbN8LP3enwHchKPaB7moRaR7k+11GvH4Lm84=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3108.namprd12.prod.outlook.com (2603:10b6:408:40::20)
 by BN8PR12MB4770.namprd12.prod.outlook.com (2603:10b6:408:a1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Tue, 4 May
 2021 17:48:51 +0000
Received: from BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::418b:8ea0:dc4b:d211]) by BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::418b:8ea0:dc4b:d211%6]) with mapi id 15.20.4065.039; Tue, 4 May 2021
 17:48:51 +0000
From:   Yazen Ghannam <Yazen.Ghannam@amd.com>
To:     linux-edac@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, tony.luck@intel.com, x86@kernel.org,
        Smita.KoralahalliChannabasappa@amd.com,
        Yazen Ghannam <yazen.ghannam@amd.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] x86/MCE: Don't call kill_me_now() directly
Date:   Tue,  4 May 2021 17:47:12 +0000
Message-Id: <20210504174712.27675-3-Yazen.Ghannam@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210504174712.27675-1-Yazen.Ghannam@amd.com>
References: <20210504174712.27675-1-Yazen.Ghannam@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.184.1]
X-ClientProxiedBy: BN6PR18CA0013.namprd18.prod.outlook.com
 (2603:10b6:404:121::23) To BN8PR12MB3108.namprd12.prod.outlook.com
 (2603:10b6:408:40::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ethanolx80b6host.amd.com (165.204.184.1) by BN6PR18CA0013.namprd18.prod.outlook.com (2603:10b6:404:121::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 17:48:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 513a4c69-e0dd-4e93-a0bf-08d90f24e0af
X-MS-TrafficTypeDiagnostic: BN8PR12MB4770:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB4770E4AA3582C5D94A4C1426F85A9@BN8PR12MB4770.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:478;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3/hCEVkSyOtYLpRoMLg9Hwv6BQ8WBMd5Q9XtDJnAbcV2g8LYGyzCEeDWqAueNJhTMGkyVybYbgeiuAZmLUVa6Lft2e450QY3pd3REW5O9HosZPyag2MLkRBl03OQKecdk5Cgh8c4cZFghtof8isZaphehQ8YbLYLKBTNEJfdyzs5xMhNU1KbwY4WNhuVL6t6Ofl5zXlgMGnIPXGmzVcHqYYCAXHwrIcvhiU6x7ShKh540pP5lr+t+FYSxTEiM5KBV7XPg8q+l5Wx6qnQiqCYcQvUf1vQNBJ9I9MuSVWMj8jlvLkNHRYE/sOphauWw+31lRpKSZnISstTN4AbwIcLjc1gR8nXWMyV5I3T+brn3B3eDU3hVnNbNf1e/mttPMFV1+haQXxwPXxeGc7mDqET99QjrGoiqfs5H4YfjpborpaIn1ZUINixc5pvC1wxEevCX5HqAdYAQ9i01g3P+O/6AP9dnRzcT8N1Lg4tmQvhEfft34IOUSPaNJ2gW1Tzor0Ps323N+ho/b3+Y9fxzukVT1yE6sIlpb3WV/qejqkdvo0WgFrqgPQqumB3fFDw1VyOJJjWZK/2qGJE1agUB6b7SKycbZVQebK50DQOzfOXKRgbFAKQkOZTHiREd6AcwchPdg/c8eANASQX1FF3wX3oqZFSSza8C5jQ3Efnz+Tezc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3108.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(2616005)(8676002)(186003)(478600001)(956004)(316002)(16526019)(4326008)(8936002)(6486002)(66946007)(38350700002)(38100700002)(83380400001)(7696005)(1076003)(86362001)(6666004)(2906002)(66556008)(6916009)(36756003)(5660300002)(26005)(52116002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7YTIeKyRjrxuhQz8F0/iGPA2PwMu4kstOOq4GHKn9PM8VhzxKu8zVp2xFDXK?=
 =?us-ascii?Q?IndBsxA7yVAOkgYadADj0G6/w03f5xowdOY/w83IEdjZOdtTf07xNfVX3e4t?=
 =?us-ascii?Q?ny05uwiW/W93J28aCJ4ECmmaNzfeCcxOJAZRqdZJrCTnx9nuWvQXEXhYohL/?=
 =?us-ascii?Q?Nm7xw1GAsJLAMOJuR+WnQ2t8C5SKZUGe6twFEgCMQ9MKGbnUUJJtpxrOdeVX?=
 =?us-ascii?Q?Y6nldR9uzd3ApWjxIlo0MpPyaJ6pE/az5YCWvsJ1hlq0SmDHGtKUKUJ3vU0j?=
 =?us-ascii?Q?v3Y8DnjU7aeLTPcwVWZhay/i4ovcq3vmz4ybtHvMzg5irveSNPsYtLblnQQq?=
 =?us-ascii?Q?a9nZ4QAAwMCHkjvuGSvH/IpvTne8da7mhfFCBHLKPA+A/gEtfwWlHlQ4X37a?=
 =?us-ascii?Q?e77nDHIA61uU2+MWak4GjvSczUdXTFVM28+kH+giRdbszZaeVwKeXI5BTL9o?=
 =?us-ascii?Q?2XVljvzRTVz3KHscTUPfwIMylvV0wK36UWMQksgaNF60fFwkxrA01+el9gIu?=
 =?us-ascii?Q?xS1tVEIt3aNwmmieFJYdHiDaelnjEz9PhJHAhkx8qIf+zzkAekAqIKocG5dV?=
 =?us-ascii?Q?1YnxXKguITK8BWE+cF+NkI14KjG6gkPnhVF9R3SxPbcGjqYe/+eQPJ6sRV3K?=
 =?us-ascii?Q?41CujoPOVXgrSvWp3aMHm2E65XHne8SsJOVXdsNU5QDbivw98mpAuzisy8co?=
 =?us-ascii?Q?Ge+utzGDENqkHWp1XmUmUDpi0aEAJU1eCZ1RjkHB71fQjqZZ7U9QZlwfbQNa?=
 =?us-ascii?Q?xp+31k2qRIgj+txRX9dQ4LDyesYqRC8f3s7UMo4saDzOECkcARGtSlq5Rknw?=
 =?us-ascii?Q?K3lUgKQrwZEFGdQvuXhTGYIaxiy1p53sririPKRhq3ncaZylLci45Y3130QU?=
 =?us-ascii?Q?h0nMuwW/2y4gA7tr0p79n1pBrazC3gdotS2gdjJkRbG8bmjy8v2kb4EMcM0e?=
 =?us-ascii?Q?3JqwaGaQho03zzMt6mLdMmwprrG8Qm9wcYMaxU6a3z9Buu2bvgIRGbScAfUA?=
 =?us-ascii?Q?mvpOi7Ckq1Nu4rN/+eU7kSQfFu19jkc9rAqGH7Ie990dYnXrISSxTx0KRFRQ?=
 =?us-ascii?Q?HTsIMiVmknKjGyv0drse8GaTZF9lhe46xBrmL7KB51BYp1bSGG2OuEU3h94b?=
 =?us-ascii?Q?8nPA5PKd33w7YL85Xz/XSiJsWigQUdOqH4VRycLRZjXIxLEEIdpDlhJzwXCX?=
 =?us-ascii?Q?7wQoEkG1ByQdRT+rbIQ29U47+6AzqrEnAKKBbbmA++3mI/FswxQxMjqTm/az?=
 =?us-ascii?Q?SrKtO4Nw1OqeKQqH/2o/H0x3NKZ2YHpuXw5iFy+3N0uwaf64F4V2WX0fRN9H?=
 =?us-ascii?Q?HFTg26Mnbq4Xt7h+LPEAfDLg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 513a4c69-e0dd-4e93-a0bf-08d90f24e0af
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3108.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 17:48:51.4020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HJ2xCwMzuFKF2fWwrJ42kxWFvxh3xnCOwkCxOnB2QpgocdLiMHYXJghjWWDWsv3ukvHd6QFwNTKtDuUlbjDEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4770
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

Always call kill_me_maybe() in order to attempt memory recovery. This
ensures that any memory associated with the error is properly marked as
poison.

This is needed for errors that occur on memory, but that do not have
MCG_STATUS[RIPV] set. One example is data poison consumption through the
instruction fetch units on AMD Zen-based systems.

The MF_MUST_KILL flag is passed to memory_failure() when
MCG_STATUS[RIPV] is not set. So the associated process will still be
killed.

Cc: <stable@vger.kernel.org>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
---
 arch/x86/kernel/cpu/mce/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 308fb644b94a..9040d45ed997 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1285,10 +1285,7 @@ static void queue_task_work(struct mce *m, int kill_current_task)
 	current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
 	current->mce_whole_page = whole_page(m);
 
-	if (kill_current_task)
-		current->mce_kill_me.func = kill_me_now;
-	else
-		current->mce_kill_me.func = kill_me_maybe;
+	current->mce_kill_me.func = kill_me_maybe;
 
 	task_work_add(current, &current->mce_kill_me, TWA_RESUME);
 }
-- 
2.25.1

