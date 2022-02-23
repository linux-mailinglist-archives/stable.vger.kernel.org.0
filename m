Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD24C169D
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 16:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiBWPY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 10:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiBWPY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 10:24:29 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4791EADF;
        Wed, 23 Feb 2022 07:24:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QI5yl5T9osXvXTlSKCT/CSq4SoeWTiJ361/WSwtyS9fVe2Nv9qlK8ywisWdcTSRBg8ypFAj7aJIRsKeGsccXNf1okICrqrDEzADLY9Y5eYFHEwDqFhEggJgfI1w2QtYUvMPbcohmwtyC6lT2j1hpf1k2bcUvFTpUjKqWo97cDiDTAn118kXj4J5IlUy4vGWkXncfO0Pa9sTCnQhvKVjf3C8QNOsZDxBW543L1kNPyXvxBSTdvbGo4QZOesUnzYGGED5prCav6Pfy4k4xXWTAV77YxJp3xFNtS7z7/pWeRxm+yWgOM2iWb8ef0wUm0j2pgFKRT7TI8QI9IT24w4C65w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvH38/rhlfNsAFBcgnwuKwZQWdTw8lQ6kGnJN5A5cso=;
 b=eNXkWh2HJp28d+6vU2VXFpdoiZxQU2zJXKbLvk4Wbo4fJZxeyz4J3eo/bTsGD4ijcHlQatcCjFqio8FeFlg5yzUKYcUjEdpCrgDgO+4HdhcafCSCoZHZii0AWyQQGybyCucbQS1vhRefvEd4a/KDDeHJ0L0wnLZNwsfRbPpyPWvaFAIcDjbqXKVdvDzoSVVR2Ii4LO2kEnXqud7Facl3zabMambRP2asOgN1nzDERw0kvg8tHSe6XeLwOELjZux71nfEjWFrjd1YJGlizP6R57M4Z00kyI8T2Odkmqx4h0aBJMWy9SSsrsNMd6IOlpiaQoQ1SpuQXGt77SsPVV7R/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvH38/rhlfNsAFBcgnwuKwZQWdTw8lQ6kGnJN5A5cso=;
 b=XNv1/QGPJqDnsvGPWg7Ud/Y1h2VTRWvIfSkpmgKc2cIo6+8sMegIvVdBcxZm6Kc2q0LWK625VPtQj6ggCE2BEXts/h4XF9BAWXXunq4E317FvAK+HZ49R9dq6nT/h1MdfOjzOOt1jLoOzak+f6qoZu0Y8ImOAESFtTZg+IAq35vdoZHQcfyTdv314irGTZWCpWqaZQ/EGZDoboyO/WJXLlAsDOlV13WZLPzyVt2mxIv20JNt0KX89neM22XC31dMkAmonwfHAVzmQ2cjK9vTDk8oxAiRtGHub/J0KTIVW8r3h727Q2BSKZRO+SFDx0uS0u80g7tPAHXywVOIbAT8sA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4563.namprd12.prod.outlook.com (2603:10b6:5:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 15:23:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 15:23:59 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     leonro@mlx, linux-rdma@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>, stable@vger.kernel.org,
        syzbot+c94a3675a626f6333d74@syzkaller.appspotmail.com
Subject: [PATCH rc v2] RDMA/cma: Do not change route.addr.src_addr outside state checks
Date:   Wed, 23 Feb 2022 11:23:57 -0400
Message-Id: <0-v2-e975c8fd9ef2+11e-syz_cma_srcaddr_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0011.namprd14.prod.outlook.com
 (2603:10b6:208:23e::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9ffee07-09ad-4f61-9e56-08d9f6e08391
X-MS-TrafficTypeDiagnostic: DM6PR12MB4563:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB45633D63AEC07BC8A781E106C23C9@DM6PR12MB4563.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: swdLBxvkGafsGY3Lz4sa4LUhGaOyAO5K4wB45qIhMFX0dFoM8nlfHPQcNBF/1zzcTXTh/H9avUg8gZdoiqkZho1jpVhagsDYfGFnGg3ZAkYnb/2WdWjZc+jPLrcDhND3qVHjEWh5hWyx3L3Wjnm+2n+cpP2aTIp4WqY//l1c1GwJ86vkfvYZi3y19ARd35avE3OLffbzpEd0zmXYQIr36u3L2s+9TEBK7yo/jbdz5QMWRBeIBWghBfS18SsmscfhI/BekWDOokTc993eoPXCsiBnYXekZcPBb8hXBzajys/DLEPUkXVflMBeoCJ4x82mvbIYtP29b90WuHusQuw6aNnHzaF9QEVg6TV5NEx4GrcNx9DAi3wTbm6gQsAxkW2RrwKhpgs03Kinm4KOOpzHyG0vkjsWKbJvjVv/8OqS6oWp5/65WnBRxnBEAPNLANIGI1ilmBYzGCOp9SculEAMfW9ZVifUawjcjt9+PMSp/HVzB2fe85hAW2Di6s/XFeL7JCcoJ/86oashorT9TGjjio04m5Q7EZ8MfPGldy6SSVUYSryIPYmZNDG3xJEad61jXghH5wrqIl2OuMuA/6GeIF1wr37HIZeSmTAS0Eg0ckrn4oe21jqRbFFq312LGyPKls89twJnQSol00NT8wwOoMYKt8pZmrLTMwzDIwKEkkexZI/CtbKmaIs8p3zhFsAt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(83380400001)(508600001)(2906002)(38100700002)(6512007)(186003)(26005)(86362001)(8936002)(5660300002)(36756003)(66946007)(2616005)(8676002)(66476007)(4326008)(66556008)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+uSbthCY+LxBDjlFioL+6SGT6JraJCwJXaFkZUUAsJRsAiy7ki3nCkP+f4E?=
 =?us-ascii?Q?Z6jkYW6lIZcsZ+E4umnwOzRn3EFsuF+WfplWyRq112zmoWnKPEC+fEEc4Yyk?=
 =?us-ascii?Q?5U3A1fhj9GAeP4tbs51mARMqR5hKYmdD7ocP6d8qIWgMihpk7SJtKIdM3aGM?=
 =?us-ascii?Q?icWb32w5OzNKNWr2tZw+CXJ1J843N9ZJOWkylwt8ns09hzSxBY7m5F8Dm69n?=
 =?us-ascii?Q?8MegjdOnUWiJxU6kpibkLJ1C8TgrFqxh/tEh5x480NTLKBZpU5mdQgIucP3S?=
 =?us-ascii?Q?ryYIqV/BfvEfjHUu8qGASq0aHJhSbt8RqKPRAxGPsLpBF99fPZiL/CHb2V1q?=
 =?us-ascii?Q?d7Lg+g9eG3KpxqOf8td/9UL8TysfvRKfM7JeBEmOdfOVbK1CQDNYYlxoCQBx?=
 =?us-ascii?Q?RxxiY7jckEXapdXMTgN3OCNklLN9KjXYM82TCseuMQBjWItJyFck2iK0GtWB?=
 =?us-ascii?Q?qB1UcS2pJjWSHDgFDJgsIk9HcR0ZKNjBhhmKslchwULA1mb6piaAcS/gU5CK?=
 =?us-ascii?Q?03g5OniRyPQyGBnLujEQGO27/gXASIjeH6URmY+nB7GldO4EfCFvXJZmBbYN?=
 =?us-ascii?Q?jdvTrnMgNGbUL27T2zsHaZ6+qkZmEqMKNtemMLgYS7XHL9A04NvNe+0tJ9xV?=
 =?us-ascii?Q?RLH+N8IiuqcxoF+dXutIyU95hKogXWrsirw5UBsXHl5Lx1KbUkVezmoQAPnM?=
 =?us-ascii?Q?hqt91RbQjKPDBrgYSGzRDpQYPF8v/s1qAkT8tAKgIPol0Ji9R7E20y6ojhwD?=
 =?us-ascii?Q?XOOK3fqiT/jCqfYdATVssz2EqzzlJX+MuGj6cuKk9pbWia0tiknTAhimWGnM?=
 =?us-ascii?Q?t738SZ53XM7s1o1DlFL5ZnUQtjLhSp88BAB3tAB6B5Y45PwU5CG1mqvxLlH2?=
 =?us-ascii?Q?madqFA1c+ykjrtPOiSdpLBaXQW5+ZgY8RXNWH21hA4f/vHD5IWGL9GyI2Bn7?=
 =?us-ascii?Q?UVvpWVOpr+FzuQ8Otyf5koETAYie/STjuisGVbY8Lno1StFTWIij/PtCnhKJ?=
 =?us-ascii?Q?dWpwg3IF3oldvppj1ElSL6aV1qnxbgWRyibrUspe8Q45ArD7uPWAkM097wVD?=
 =?us-ascii?Q?oCISHuyk0EifpwA5gMijrqvs43F9rQP8Vgt9iedZQdipSNTrIFijR5ACo/+Q?=
 =?us-ascii?Q?W7OBwuHjky4JIU1lyLE/AXbsFXdtrTEpPzbN2jYVKvaxNubgMuvDDfj5SqF7?=
 =?us-ascii?Q?dCspdb5Plw0IBbltokHQZS0Lpgh+83/OfydSr7KhwKLntnw0TWQ2GipWXNko?=
 =?us-ascii?Q?beyAsB5GqPyAoCLBWc6ULFplPCBLiLJMcWt6lBdrzuCZCkvcImla1n/PHfRY?=
 =?us-ascii?Q?fKxR98u0IrLKsHkOY3aT6jUR+1nLq16IsoA2wX+u+RKknDwpAh0lgTgQkP8I?=
 =?us-ascii?Q?fG0Pn2FmaCiGCTY6DlDbADECcqAaCvufvCITGVsfYIORD/qrmwVkUf81xyOE?=
 =?us-ascii?Q?MFJVl2jw8kVJHFh5Xs5ZzKJpopX22RnP/+YciSTUrGGcNUHKOj175b5KEloT?=
 =?us-ascii?Q?qEVKSYFafcJLGCWTG1oGhChMKu3Ye1hQOjoG7wiQqluhvn7RPO/wpgJh968+?=
 =?us-ascii?Q?pZfhb7YXwwCiE+5Pz3Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ffee07-09ad-4f61-9e56-08d9f6e08391
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 15:23:59.1351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlGwMUzBBmHaWMlaLOeJbOKz+LrS9liEpnygBbAhTReT+8QNY7lZBXMh+FBWD6n9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4563
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the state is not idle then resolve_prepare_src() should immediately
fail and no change to global state should happen. However, it
unconditionally overwrites the src_addr trying to build a temporary any
address.

For instance if the state is already RDMA_CM_LISTEN then this will corrupt
the src_addr and would cause the test in cma_cancel_operation():

           if (cma_any_addr(cma_src_addr(id_priv)) && !id_priv->cma_dev)

Which would manifest as this trace from syzkaller:

  BUG: KASAN: use-after-free in __list_add_valid+0x93/0xa0 lib/list_debug.c:26
  Read of size 8 at addr ffff8881546491e0 by task syz-executor.1/32204

  CPU: 1 PID: 32204 Comm: syz-executor.1 Not tainted 5.12.0-rc8-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:79 [inline]
   dump_stack+0x141/0x1d7 lib/dump_stack.c:120
   print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
   __kasan_report mm/kasan/report.c:399 [inline]
   kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
   __list_add_valid+0x93/0xa0 lib/list_debug.c:26
   __list_add include/linux/list.h:67 [inline]
   list_add_tail include/linux/list.h:100 [inline]
   cma_listen_on_all drivers/infiniband/core/cma.c:2557 [inline]
   rdma_listen+0x787/0xe00 drivers/infiniband/core/cma.c:3751
   ucma_listen+0x16a/0x210 drivers/infiniband/core/ucma.c:1102
   ucma_write+0x259/0x350 drivers/infiniband/core/ucma.c:1732
   vfs_write+0x28e/0xa30 fs/read_write.c:603
   ksys_write+0x1ee/0x250 fs/read_write.c:658
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xae

This is indicating that an rdma_id_private was destroyed without doing
cma_cancel_listens().

Instead of trying to re-use the src_addr memory to indirectly create an
any address derived from the dst build one explicitly on the stack and
bind to that as any other normal flow would do. rdma_bind_addr() will copy
it over the src_addr once it knows the state is valid.

This is similar to commit bc0bdc5afaa7 ("RDMA/cma: Do not change
route.addr.src_addr.ss_family")

Cc: stable@vger.kernel.org
Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
Reported-by: syzbot+c94a3675a626f6333d74@syzkaller.appspotmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/core/cma.c | 38 +++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 288ff0735875f4..c803d63f4d2354 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3368,22 +3368,30 @@ static int cma_resolve_ib_addr(struct rdma_id_private *id_priv)
 static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 			 const struct sockaddr *dst_addr)
 {
-	if (!src_addr || !src_addr->sa_family) {
-		src_addr = (struct sockaddr *) &id->route.addr.src_addr;
-		src_addr->sa_family = dst_addr->sa_family;
-		if (IS_ENABLED(CONFIG_IPV6) &&
-		    dst_addr->sa_family == AF_INET6) {
-			struct sockaddr_in6 *src_addr6 = (struct sockaddr_in6 *) src_addr;
-			struct sockaddr_in6 *dst_addr6 = (struct sockaddr_in6 *) dst_addr;
-			src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
-			if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
-				id->route.addr.dev_addr.bound_dev_if = dst_addr6->sin6_scope_id;
-		} else if (dst_addr->sa_family == AF_IB) {
-			((struct sockaddr_ib *) src_addr)->sib_pkey =
-				((struct sockaddr_ib *) dst_addr)->sib_pkey;
-		}
+	struct sockaddr_storage zero_sock = {};
+
+	if (src_addr && src_addr->sa_family)
+		return rdma_bind_addr(id, src_addr);
+
+	/*
+	 * When the src_addr is not specified, automatically supply an any addr
+	 */
+	zero_sock.ss_family = dst_addr->sa_family;
+	if (IS_ENABLED(CONFIG_IPV6) && dst_addr->sa_family == AF_INET6) {
+		struct sockaddr_in6 *src_addr6 =
+			(struct sockaddr_in6 *)&zero_sock;
+		struct sockaddr_in6 *dst_addr6 =
+			(struct sockaddr_in6 *)dst_addr;
+
+		src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
+		if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
+			id->route.addr.dev_addr.bound_dev_if =
+				dst_addr6->sin6_scope_id;
+	} else if (dst_addr->sa_family == AF_IB) {
+		((struct sockaddr_ib *)&zero_sock)->sib_pkey =
+			((struct sockaddr_ib *)dst_addr)->sib_pkey;
 	}
-	return rdma_bind_addr(id, src_addr);
+	return rdma_bind_addr(id, (struct sockaddr *)&zero_sock);
 }
 
 /*

base-commit: 748663c8ccf6b2e5a800de19127c2cc1c4423fd2
-- 
2.35.1

