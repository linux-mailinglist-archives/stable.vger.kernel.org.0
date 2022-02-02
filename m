Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189FB4A6A7F
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 04:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243750AbiBBDX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 22:23:27 -0500
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:43344
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230342AbiBBDX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Feb 2022 22:23:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iParlnREOQlg71v2dZr9VeLkSdY755EBU+RVmwHT4/bHice79tTKuACj3MlWk44j2s8/dd8NIE+VNmmkfq5cswE2n9KX8LWAcRXspRz3vxaLrBIFSaHw+BeTteOTSvaI4n6/21p8Wmky1fpl6hA0YxIYOmNzIJmoyTgPrwLbZsuHbQ7vJDGjBdOc6DeiOSbfxukHH8p+YupDXBZCXo+Tfx79GRqlBqiogWfev8S5Jfcy5zmcX/lbLaqcdm5CPP+sw8GWcWJY3oC5kIjorvGlCGM5NL8qBb76SdGtbOz83PrFyJHPibREZ0FRelr4FG163sKspqPhucUvqlZBeo1u4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90TpX/TSNluqHpOvHQ2FEHPnVbX6OdtBAW2rtEA2Ags=;
 b=I9cH0K3hT25MtoJ/E+Fw2c5glk7zrWcpLhLQgrvTNNe9h8KrFmxCNEg+Ab1UGsNnTe38Xcmk7RdFYQiAqhgfh5tIIdM9YWXumzUs5tZMYzxK8ntkA9MkiE10UL6oOy/fBgCXbjDy0ZtTlvgci6HHU5qbGep67m63X5XtD2zu21JC2kZ8pCz8vB0rX53h6Kb1kdI4DrMpjiUzn/Oc52e94SbV5dtc/Gb1ZNdMrZRZ0WFHSm2S//8TOqYpOK7Eb5y7+7rmtmtUAWv0jAXp4C8RKTCxSLVmYU9gFy+BRZSSKz/Ek+Hf4mGJ0QQAHz//XjUajz73gQc7LpOEM+RsCoCD4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90TpX/TSNluqHpOvHQ2FEHPnVbX6OdtBAW2rtEA2Ags=;
 b=FOC74++1uzAv+FiXlxm4UO77ZASXRTJj+C4+/EVxhF5Sbn8eMekOJz11B5qx6sQVRUJBBxvKOfuy9qSI83Qc/Y/zRSXK0yAAnhVbsPtJA9Zei7rpvzYqAxjf1bzhyIr9joEcM7Z1Qm6fHLY/Sxy00ld+cLXY3haghF7QVr+3wdzANnZtoQKRRnVtukkJKZaSTTTEesbaiKU3W3ACR0ZGU/89fHdBZHTmNebrVwPOPTE/9GGKHGdG3EnH9rVj3pdbDtEV316/be2cWf0f3075UkFRGUXcZkNSgLJlQN2y/3Hu6dDZHhIVUvOp8cpEpYRtfMkoE7CyXCI/R75sQ2PzJg==
Received: from MW4P223CA0016.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::21)
 by CH0PR12MB5201.namprd12.prod.outlook.com (2603:10b6:610:b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Wed, 2 Feb
 2022 03:23:24 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::76) by MW4P223CA0016.outlook.office365.com
 (2603:10b6:303:80::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Wed, 2 Feb 2022 03:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 03:23:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Feb
 2022 03:23:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Feb 2022
 19:23:22 -0800
Received: from sandstorm.attlocal.net (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Tue, 1 Feb 2022 19:23:21 -0800
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Will McVicker <willmcvicker@google.com>,
        Minchan Kim <minchan@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] Revert mm/gup: small refactoring: simplify try_grab_page()
Date:   Tue, 1 Feb 2022 19:23:17 -0800
Message-ID: <20220202032317.327741-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f86d3e31-7b6b-4abd-c0eb-08d9e5fb5ea0
X-MS-TrafficTypeDiagnostic: CH0PR12MB5201:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB52010F4C0C2BB3171155DEEDA8279@CH0PR12MB5201.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2Jp/3y8pQMd72GczYlF+ATgySLlIWEZ8fkCXTpkjK2I0GeJTsNVYkA3QJXC+Z1AtoWKoJyKAppylX2SwkIm1zuZrW+NgP0qeAx/hcNiWlMkb0uZxByRle6/wf440EA1wYb2kxZVN+aMVgHwdvMupdkZvi0MhbgbIppYxqQWEhR9iniH371u0etCwDWUtf4xaLPgyiGvyQb9Pu2qdToZd4MC3593gbwokOcIa69GZuiJGwR8lDLvXN2fsdryXsIdT4dDAqK3q+FKshoellJCLzwHa51oXkFtfg5B9KEoP+CL1ute89c7RxzyYlauqMexLRC0OPgbViFLkxWcqTDLVUKYU9XkvNGFv79327Vc+bsvL6lsUPYbyqSwZ6W1KBdrbvh5GljyoTh3dtPe84O8a+7GfagCYVs6dupW1A6XJ0YLUGJBvj37H0sgH9nEJnbJRssV6PKGW/sqBe1u/DqhPB0iq19k0fMEVLth4Z7ZkxhTAFZgXDQLrNVkZ/aORSSj0+98uNNoURGz3fYRdNHfjJZeFEClMJUCgVtqEuwORdODRQ0pnfQCPLnSVzy5W0NBtAFFrVDtyPySnHmswAvmfdxMP+HXNk5WmrnHVZfM31aqzpfYkIuMny+vd70ral2b3E13Jx0jzVyUuetqAWZ2rVJDIJ8xZrlQWB1qIzLmtbR/JGchLL49U1gVyUumMMFA3F/QL1H8Yyqlm16eQeGRMneYcNok52Jz40AGxG1YAVnFpVPufyBzK62JSLw51MlTlUcN67lq4yIIIcRnzxXoFYRS4sLl41DwJeHbr+oIyqQ=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7416002)(5660300002)(70206006)(4326008)(36860700001)(47076005)(2906002)(6916009)(36756003)(8936002)(70586007)(316002)(54906003)(40460700003)(8676002)(82310400004)(26005)(86362001)(336012)(1076003)(81166007)(186003)(508600001)(6666004)(966005)(2616005)(356005)(83380400001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 03:23:23.5531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f86d3e31-7b6b-4abd-c0eb-08d9e5fb5ea0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5201
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 54d516b1d62ff8f17cee2da06e5e4706a0d00b8a

That commit did a refactoring that effectively combined fast and slow
gup paths (again). And that was again incorrect, for two reasons:

a) Fast gup and slow gup get reference counts on pages in different ways
and with different goals: see Linus' writeup in commit cd1adf1b63a1
("Revert "mm/gup: remove try_get_page(), call try_get_compound_head()
directly""), and

b) try_grab_compound_head() also has a specific check for "FOLL_LONGTERM
&& !is_pinned(page)", that assumes that the caller can fall back to slow
gup. This resulted in new failures, as recently report by Will McVicker
[1].

But (a) has problems too, even though they may not have been reported
yet. So just revert this.

[1] https://lore.kernel.org/r/20220131203504.3458775-1-willmcvicker@google.com

Fixes: 54d516b1d62f ("mm/gup: small refactoring: simplify try_grab_page()")
Cc: Christoph Hellwig <hch@lst.de>
Tested-by: Will McVicker <willmcvicker@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org # 5.15
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

Since v1, I've only changed the commit description:

* Added Will's Tested-by

* Added Cc: stable

 mm/gup.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index f0af462ac1e2..a9d4d724aef7 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -124,8 +124,8 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
  * considered failure, and furthermore, a likely bug in the caller, so a warning
  * is also emitted.
  */
-struct page *try_grab_compound_head(struct page *page,
-				    int refs, unsigned int flags)
+__maybe_unused struct page *try_grab_compound_head(struct page *page,
+						   int refs, unsigned int flags)
 {
 	if (flags & FOLL_GET)
 		return try_get_compound_head(page, refs);
@@ -208,10 +208,35 @@ static void put_compound_head(struct page *page, int refs, unsigned int flags)
  */
 bool __must_check try_grab_page(struct page *page, unsigned int flags)
 {
-	if (!(flags & (FOLL_GET | FOLL_PIN)))
-		return true;
+	WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == (FOLL_GET | FOLL_PIN));
 
-	return try_grab_compound_head(page, 1, flags);
+	if (flags & FOLL_GET)
+		return try_get_page(page);
+	else if (flags & FOLL_PIN) {
+		int refs = 1;
+
+		page = compound_head(page);
+
+		if (WARN_ON_ONCE(page_ref_count(page) <= 0))
+			return false;
+
+		if (hpage_pincount_available(page))
+			hpage_pincount_add(page, 1);
+		else
+			refs = GUP_PIN_COUNTING_BIAS;
+
+		/*
+		 * Similar to try_grab_compound_head(): even if using the
+		 * hpage_pincount_add/_sub() routines, be sure to
+		 * *also* increment the normal page refcount field at least
+		 * once, so that the page really is pinned.
+		 */
+		page_ref_add(page, refs);
+
+		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED, 1);
+	}
+
+	return true;
 }
 
 /**

base-commit: 9f7fb8de5d9bac17b6392a14af40baf555d9129b
-- 
2.35.1

