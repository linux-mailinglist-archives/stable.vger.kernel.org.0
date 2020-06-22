Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425B12041EF
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbgFVUZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:25:19 -0400
Received: from mail-eopbgr760089.outbound.protection.outlook.com ([40.107.76.89]:20006
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728443AbgFVUZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 16:25:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+RKJyqSVLy3eaEvRt3IjvFyPm47MyJSeziPBEM2h4QKSR51QXNOihcAyNZDmbVErm7ggpL2E3Kn2uSJFcet+4juMs8QOm6/uYXD6wmnzgSpTe1qroY2C6/uTKyZkKNiLXZydJgShZTNYAm4euiZa47pe4f8TYRETzcpSFgFeldhD8f48YLbeO2y18QA1zRHFnOyrVRCYI2/xWD5IsktnfpRQ7M9jqpEdFLQ68u3fyRjV8tUqX0AmQyG3ca+By+BSzf0ZW/D/hOHLpCUc3aix+X/6luNNUs69kgKP+Yyi72IsqG0mDjJTeb+GfrnkQayGiEbY/ooPqAsYMsaUT93AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jchcwRejZk/OQvDQPkbaFjKKCr3OO0jYkDFQbCT8NM=;
 b=D7tXdC3T08m2rFky8j7OhpAY+Drg5xikg57RyT4JXCmb4oTyBYOcrg7jVhxTVxURYBY63zNl1dpI2qlEbwcCjapYj7MfX6o2A+5wcnaEojUHS5tl1NeTivzlp2uXKn5Iblp6NG1+a4FxbWKkpwa1+JzMDm+sJelsSa3Ve0tHk4Yr77/OGDoAM7puowlwGbrulSnHciCzvBnMXIT5imsPskRwzKaSIPydHKKXuD4eJnrFKSG+0PjKNn2rcgRL/nHomXgOG7N+d4aLFEG4rnre3032A5vPWgysIu10wQdT/LkcL57shQQkrN5z08rCtkg42TCJ1+26KpYS8FwE6un6pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jchcwRejZk/OQvDQPkbaFjKKCr3OO0jYkDFQbCT8NM=;
 b=tx7Dvff7PmwYYk2BT7YGUcX7h9GF9U35t1FQbGo7llLRAB1ZqCA32vh09NceGgX7GFjc/esB5KqDsqE3z+scPp1KoZFPep3LRVgO8/hPkJoM3gDhgT+x6KjCV1OvmWy5SsTac7tl04sGfNfpdFh+Y61zifp5KplskDaSVpI4HTw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SA0PR12MB4526.namprd12.prod.outlook.com (2603:10b6:806:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 20:25:15 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 20:25:15 +0000
From:   John Allen <john.allen@amd.com>
To:     linux-crypto@vger.kernel.org
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, bp@suse.de, linux-kernel@vger.kernel.org,
        John Allen <john.allen@amd.com>, stable@vger.kernel.org
Subject: [PATCH] crypto: ccp - Fix use of merged scatterlists
Date:   Mon, 22 Jun 2020 15:24:02 -0500
Message-Id: <20200622202402.360064-1-john.allen@amd.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:805:ca::24) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by SN6PR16CA0047.namprd16.prod.outlook.com (2603:10b6:805:ca::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Mon, 22 Jun 2020 20:25:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6b450702-1cbb-44b5-556c-08d816ea5f06
X-MS-TrafficTypeDiagnostic: SA0PR12MB4526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4526BD4F53A220941DC5484E9A970@SA0PR12MB4526.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +iEBAqfzLBFKhEJbyIRbIpJMfKVdX/TOT1szJ8S8PQBhkFLomx+uIc2njN70nFnwJ3FElZbdhqQHICIqTNHq4NU51r+fsz//yXADeun8kDvYcPMFPHqbz/6Azra7QMske/QlCL1elmDoty4ktF2n6m3qqleToT+ubJl2jviNFfj6EYfJ+jI0eIvfWe9qLDqYQLoVj1kAfGWoseA5Cu//jEUYH/eGYh2UJ9Lf4zS/ukEbtmaqkxAAVCwNdYxfpqY/xgYyBlzvqRa7NyOvEMKPxvurb9rYqklu5Wk3u2DLm3UeucTqAbGeX3Gy///K6xINimxuQ54me7xy5q2ZgdCroQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(8936002)(26005)(5660300002)(8676002)(2906002)(86362001)(16526019)(66556008)(66946007)(1076003)(186003)(66476007)(6916009)(36756003)(6666004)(4326008)(44832011)(2616005)(956004)(478600001)(83380400001)(7696005)(316002)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NAzZjxjGnPxATXeDndCSWGJdYrSV8CVdvbbCBKltvIkD9B424VY2t8CwjcK2aeVutTkSCsIcjicmGHqdCXeW0+DkT8NsSeaLQMaEkIVpNc3BR3ip+pjCkQYmwu3mobElFApoJInXYdroLdxmWrrZVchiAwqsG/vGgqrhh/beFYnwZAyc7hey5V93in8JMUAg/72Pqg3jw3dXNnZneoXLDgvlKQmJWgzq+0qxQ/v3CMVhSpc7LP4gqdlag+Og+nrHDkP6OD4yfx+6EJCcwon7vl86zxHYOs8HXu1LrsRfkTCzDlkO8+JEPTIQ/WA0IhmP0i8I7lrSPyZMe91oQAxHeNuvgEuGvaes37rblumH7ShjU7izpftQY4/uU0fALHigW6TuMZpiLYrO6GjD8jDXqHKmSBmdLPh7+SJHQRswWkpfBBsVZ2rLQsg8AZ27KjkIztzmrDU6IS5B6Kk+aQ21CwyiUJr7OlrWHyyt9ia0a4A=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b450702-1cbb-44b5-556c-08d816ea5f06
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 20:25:14.8432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKg2jxG/DrKjrGd1s+d1ZxKAW4NeQSunZXP7RieCRTZ+iasoVMZJZOkoXuEOKcJFntuXAK8Fw1WdushOU+KRfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4526
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Running the crypto manager self tests with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS may result in several types of errors
when using the ccp-crypto driver:

alg: skcipher: cbc-des3-ccp encryption failed on test vector 0; expected_error=0, actual_error=-5 ...

alg: skcipher: ctr-aes-ccp decryption overran dst buffer on test vector 0 ...

alg: ahash: sha224-ccp test failed (wrong result) on test vector ...

These errors are the result of improper processing of scatterlists mapped
for DMA.

Given a scatterlist in which entries are merged as part of mapping the
scatterlist for DMA, the DMA length of a merged entry will reflect the
combined length of the entries that were merged. The subsequent
scatterlist entry will contain DMA information for the scatterlist entry
after the last merged entry, but the non-DMA information will be that of
the first merged entry.

The ccp driver does not take this scatterlist merging into account. To
address this, add a second scatterlist pointer to track the current
position in the DMA mapped representation of the scatterlist. Both the DMA
representation and the original representation of the scatterlist must be
tracked as while most of the driver can use just the DMA representation,
scatterlist_map_and_copy() must use the original representation and
expects the scatterlist pointer to be accurate to the original
representation.

In order to properly walk the original scatterlist, the scatterlist must
be walked until the combined lengths of the entries seen is equal to the
DMA length of the current entry being processed in the DMA mapped
representation.

Fixes: 63b945091a070 ("crypto: ccp - CCP device driver and interface support")
Signed-off-by: John Allen <john.allen@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/crypto/ccp/ccp-dev.h |  1 +
 drivers/crypto/ccp/ccp-ops.c | 37 +++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 3f68262d9ab4..87a34d91fdf7 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -469,6 +469,7 @@ struct ccp_sg_workarea {
 	unsigned int sg_used;
 
 	struct scatterlist *dma_sg;
+	struct scatterlist *dma_sg_head;
 	struct device *dma_dev;
 	unsigned int dma_count;
 	enum dma_data_direction dma_dir;
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 422193690fd4..64112c736810 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -63,7 +63,7 @@ static u32 ccp_gen_jobid(struct ccp_device *ccp)
 static void ccp_sg_free(struct ccp_sg_workarea *wa)
 {
 	if (wa->dma_count)
-		dma_unmap_sg(wa->dma_dev, wa->dma_sg, wa->nents, wa->dma_dir);
+		dma_unmap_sg(wa->dma_dev, wa->dma_sg_head, wa->nents, wa->dma_dir);
 
 	wa->dma_count = 0;
 }
@@ -92,6 +92,7 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
 		return 0;
 
 	wa->dma_sg = sg;
+	wa->dma_sg_head = sg;
 	wa->dma_dev = dev;
 	wa->dma_dir = dma_dir;
 	wa->dma_count = dma_map_sg(dev, sg, wa->nents, dma_dir);
@@ -104,14 +105,28 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
 static void ccp_update_sg_workarea(struct ccp_sg_workarea *wa, unsigned int len)
 {
 	unsigned int nbytes = min_t(u64, len, wa->bytes_left);
+	unsigned int sg_combined_len = 0;
 
 	if (!wa->sg)
 		return;
 
 	wa->sg_used += nbytes;
 	wa->bytes_left -= nbytes;
-	if (wa->sg_used == wa->sg->length) {
-		wa->sg = sg_next(wa->sg);
+	if (wa->sg_used == sg_dma_len(wa->dma_sg)) {
+		/* Advance to the next DMA scatterlist entry */
+		wa->dma_sg = sg_next(wa->dma_sg);
+
+		/* In the case that the DMA mapped scatterlist has entries
+		 * that have been merged, the non-DMA mapped scatterlist
+		 * must be advanced multiple times for each merged entry.
+		 * This ensures that the current non-DMA mapped entry
+		 * corresponds to the current DMA mapped entry.
+		 */
+		do {
+			sg_combined_len += wa->sg->length;
+			wa->sg = sg_next(wa->sg);
+		} while (wa->sg_used > sg_combined_len);
+
 		wa->sg_used = 0;
 	}
 }
@@ -299,7 +314,7 @@ static unsigned int ccp_queue_buf(struct ccp_data *data, unsigned int from)
 	/* Update the structures and generate the count */
 	buf_count = 0;
 	while (sg_wa->bytes_left && (buf_count < dm_wa->length)) {
-		nbytes = min(sg_wa->sg->length - sg_wa->sg_used,
+		nbytes = min(sg_dma_len(sg_wa->dma_sg) - sg_wa->sg_used,
 			     dm_wa->length - buf_count);
 		nbytes = min_t(u64, sg_wa->bytes_left, nbytes);
 
@@ -331,11 +346,11 @@ static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
 	 * and destination. The resulting len values will always be <= UINT_MAX
 	 * because the dma length is an unsigned int.
 	 */
-	sg_src_len = sg_dma_len(src->sg_wa.sg) - src->sg_wa.sg_used;
+	sg_src_len = sg_dma_len(src->sg_wa.dma_sg) - src->sg_wa.sg_used;
 	sg_src_len = min_t(u64, src->sg_wa.bytes_left, sg_src_len);
 
 	if (dst) {
-		sg_dst_len = sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used;
+		sg_dst_len = sg_dma_len(dst->sg_wa.dma_sg) - dst->sg_wa.sg_used;
 		sg_dst_len = min_t(u64, src->sg_wa.bytes_left, sg_dst_len);
 		op_len = min(sg_src_len, sg_dst_len);
 	} else {
@@ -365,7 +380,7 @@ static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
 		/* Enough data in the sg element, but we need to
 		 * adjust for any previously copied data
 		 */
-		op->src.u.dma.address = sg_dma_address(src->sg_wa.sg);
+		op->src.u.dma.address = sg_dma_address(src->sg_wa.dma_sg);
 		op->src.u.dma.offset = src->sg_wa.sg_used;
 		op->src.u.dma.length = op_len & ~(block_size - 1);
 
@@ -386,7 +401,7 @@ static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
 			/* Enough room in the sg element, but we need to
 			 * adjust for any previously used area
 			 */
-			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.sg);
+			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.dma_sg);
 			op->dst.u.dma.offset = dst->sg_wa.sg_used;
 			op->dst.u.dma.length = op->src.u.dma.length;
 		}
@@ -2028,7 +2043,7 @@ ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	dst.sg_wa.sg_used = 0;
 	for (i = 1; i <= src.sg_wa.dma_count; i++) {
 		if (!dst.sg_wa.sg ||
-		    (dst.sg_wa.sg->length < src.sg_wa.sg->length)) {
+		    (sg_dma_len(dst.sg_wa.sg) < sg_dma_len(src.sg_wa.sg))) {
 			ret = -EINVAL;
 			goto e_dst;
 		}
@@ -2054,8 +2069,8 @@ ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			goto e_dst;
 		}
 
-		dst.sg_wa.sg_used += src.sg_wa.sg->length;
-		if (dst.sg_wa.sg_used == dst.sg_wa.sg->length) {
+		dst.sg_wa.sg_used += sg_dma_len(src.sg_wa.sg);
+		if (dst.sg_wa.sg_used == sg_dma_len(dst.sg_wa.sg)) {
 			dst.sg_wa.sg = sg_next(dst.sg_wa.sg);
 			dst.sg_wa.sg_used = 0;
 		}
-- 
2.18.4

