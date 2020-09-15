Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C74526AFC5
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 23:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgIOVmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 17:42:21 -0400
Received: from mail-bn8nam12on2133.outbound.protection.outlook.com ([40.107.237.133]:5473
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728122AbgIOVbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 17:31:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AisxWY/hKReXzqOOlwlF0I5LPy3Di+XTxo1wKEtEdVBduQCVX6MacePAIsAqp69/ZrlP9fiJHHA5I5BNGs4bToCXg3I4oOUwZkiF2qwyeAMWquc7pPsMh6oNedOKVByrn5vrs/k9nuysXfHFwOqjwm7w2I39MxhTfH5lVDtDl5CZhX158A8H0G7AIjxFcvd/dvFwKV4TLoO/td/WsPKVds7vdFHIvBHX3JjYneJs68TdPCb+xL01QNs46s+8sD0wNXJSLmyIY3b2iCzaFrWW/diHVVzqpexcW+XnrbZMjPU8OGPdC1mLdp0DlFft/akDqH6aDHcAt4FKS7gF7O2PfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRgoaYwsptwvSEGhZtkanK8RAy0s3MnugJYQQU77ibE=;
 b=JhfYGV0h7F+kXoRvnquFrwaKoTCyrzqpYCO2NmwPEBcsERN2jAwscRErxPQtTujDkHh6JBqayk8HvLM+Xop6WMB0+jyCMqpkPCLK2dvCZmhDO4m/K5vDQd4h0Qs39AKaOBJUmc3P5CeyQFRZ8fUXfvo5lZ5QcvDou+predpLdnvZKSx9xIIFduZv/+YawEaRCtyWKV5BAlUGR7Kw6t+ID02Soc+20mLeU2t97tWwhfrLgJZqXqjpTQ8dm5VXPLLTSUN9KWY3J8pu1JYIpAPRNyT+6GMF2XqVfLz61iszxjx7ZMglV2SrBfj5Uj4WDZPlGIOR6vnV6owOUwZdy2VG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRgoaYwsptwvSEGhZtkanK8RAy0s3MnugJYQQU77ibE=;
 b=djDh3VuuWJ+0E9TfjWcCxoWr7sCn69Kb/vijzN9MVkHUVHqt9McPmy1LUbuY/rrrsxqdW5e7xhmFAlbUjCjN7BVhGdUNHy/YA9Lt8EXcESHFgYIuX6xts3QsyT/UqnZQaNerLMBmPGmJWBL2R7zzI008vvZZQOr2fnVcZepPjqM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=os.amperecomputing.com;
Received: from DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17) by
 DM6PR01MB5516.prod.exchangelabs.com (2603:10b6:5:153::22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Tue, 15 Sep 2020 21:31:08 +0000
Received: from DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b]) by DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 21:31:08 +0000
From:   "John L. Villalovos" <jlvillal@os.amperecomputing.com>
To:     stable@vger.kernel.org
Cc:     "John L. Villalovos" <jlvillal@os.amperecomputing.com>,
        Fredrik Noring <noring@nocrew.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 1/5] lib/genalloc: add gen_pool_dma_zalloc() for zeroed DMA allocations
Date:   Tue, 15 Sep 2020 14:30:35 -0700
Message-Id: <20200915213039.862123-2-jlvillal@os.amperecomputing.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
References: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY4PR14CA0040.namprd14.prod.outlook.com
 (2603:10b6:903:101::26) To DM6PR01MB5802.prod.exchangelabs.com
 (2603:10b6:5:203::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (4.28.12.214) by CY4PR14CA0040.namprd14.prod.outlook.com (2603:10b6:903:101::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 21:31:07 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [4.28.12.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f1483e1-ac62-4958-4249-08d859bea884
X-MS-TrafficTypeDiagnostic: DM6PR01MB5516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR01MB5516D7CD9FF0B8AA23988CCCED200@DM6PR01MB5516.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8fNB7lRwBmNPtXp2QioRId0Gyp01aTRdHiS5x8ageq/pkso8Efuwmgk2hP/c3d7YU6zTEU+Irs7JB8kKUZ/1kyiXExYoockdWDdgGZ9HwdoEQgr5H2aL+yEUqHttQddCnfYfIKiJoYEhY2FUzXk1MufHmQ0n2OuAPnlM/P1jhJYCXqxzjc+Zl92Ao3QPDBGoWzQuW/Px9PsbnKGqPd2Zu/vXbc8mGMJIbB0216C9xsPQsvFwQYDnqtXHnfH5NgHYfmNZlw2ISC5k1XIR19dD0x+lqGszlxkx3uZj2wG3emvjwk9iyqh/E5Oku6zlmJc0+AO0GzOt9FxIp6CblSHLbgmaJ7XWpLhwafq5GUJY/n2gjhzkwY+i0/RFbJyctS71cqt94Fd0f0ckLkPBOIkLWh8VyeBE7gRO9iEDqfVnCTqfl1LlGzkeQvtpCYaQ0hO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB5802.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39850400004)(83380400001)(6512007)(8936002)(316002)(66946007)(16526019)(8676002)(4326008)(2616005)(6486002)(956004)(26005)(186003)(1076003)(54906003)(6666004)(6506007)(478600001)(5660300002)(86362001)(2906002)(66476007)(69590400008)(66556008)(52116002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BdSYy7qjYCKJxtk495hASrqodmpJNdiLr06XTd3FXb5UO6TyJSR7kG85weBBJI5ufEOBhKyPcySFQCGV6fFgEcMYAnJGJP6M5JQ3EQmt2zlwK8SK3W15SI+pM9Y12DgF1NFCV2X4ezGUvicEB369JnX+bYXsZlLJx5RkoMnsANFcAqy2QuICFER9BjB6wdBNOuUDNFbGv8omHFkONkNYjBBktL2oM23keAZwSqiI11zIbClgnLrg37sXvoIKrLpEA6kNVVUG+TGh5L2DI+ACPXLNx76OYpCWZJAqkZHg7kU89UG1MoooTHrPFWljdeK6DjZpOTfVp7ELsYmUdg+roN8G4A/aaCdepCnjJpsaK2iE+jsl35qDQFbEPX326ISa8qi+NQtgdJQG606N1qPwWg/YPEcr5KpO/BB2QHfxS37hbbgQpaaFX/ovEPFqeSK8Z7RmPlniq104BwML7MbCt1+kttjG6AIWFHl2ZokrtB/Oi6y/JyC4w3TcN6ywVijQbqzDfT8knzXjOIHjiUJoBRqkybHgiDCdVTZoPIIaCKT1EaTODHoBMv85eej05OehTpF/ExmDNpx0KDSR8Ugpcr4FL8H/xNE9Bte3Q2sT0IYJXDnlov1RLTlbLn/a5VDRK7UdGAcea/Zop2qNw+KEhg==
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1483e1-ac62-4958-4249-08d859bea884
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB5802.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:31:08.0212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLhCj3K11IaZc+o2Ut9peroDRvDRJTsDqxHTHiB/V98Z1eLqtb4j0hWFsxlpL47cp+3sGSVjeWVlX4VZ+FfxYvmXfqQliIR/RmxRQWaWE5xs54Uv0c0ATbPHUcZ1rnDG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5516
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit da83a722959a82733c3ca60030cc364ca2318c5a upstream.

gen_pool_dma_zalloc() is a zeroed memory variant of
gen_pool_dma_alloc().  Also document the return values of both, and
indicate NULL as a "%NULL" constant.

Signed-off-by: Fredrik Noring <noring@nocrew.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John L. Villalovos <jlvillal@os.amperecomputing.com>
---
 include/linux/genalloc.h |  1 +
 lib/genalloc.c           | 29 ++++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index dd0a452373e7..6c62eeca754f 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -121,6 +121,7 @@ extern unsigned long gen_pool_alloc_algo(struct gen_pool *, size_t,
 		genpool_algo_t algo, void *data);
 extern void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size,
 		dma_addr_t *dma);
+void *gen_pool_dma_zalloc(struct gen_pool *pool, size_t size, dma_addr_t *dma);
 extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
 extern void gen_pool_for_each_chunk(struct gen_pool *,
 	void (*)(struct gen_pool *, struct gen_pool_chunk *, void *), void *);
diff --git a/lib/genalloc.c b/lib/genalloc.c
index 7e85d1e37a6e..5db43476a19b 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -337,12 +337,14 @@ EXPORT_SYMBOL(gen_pool_alloc_algo);
  * gen_pool_dma_alloc - allocate special memory from the pool for DMA usage
  * @pool: pool to allocate from
  * @size: number of bytes to allocate from the pool
- * @dma: dma-view physical address return value.  Use NULL if unneeded.
+ * @dma: dma-view physical address return value.  Use %NULL if unneeded.
  *
  * Allocate the requested number of bytes from the specified pool.
  * Uses the pool allocation function (with first-fit algorithm by default).
  * Can not be used in NMI handler on architectures without
  * NMI-safe cmpxchg implementation.
+ *
+ * Return: virtual address of the allocated memory, or %NULL on failure
  */
 void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
 {
@@ -362,6 +364,31 @@ void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
 }
 EXPORT_SYMBOL(gen_pool_dma_alloc);
 
+/**
+ * gen_pool_dma_zalloc - allocate special zeroed memory from the pool for
+ * DMA usage
+ * @pool: pool to allocate from
+ * @size: number of bytes to allocate from the pool
+ * @dma: dma-view physical address return value.  Use %NULL if unneeded.
+ *
+ * Allocate the requested number of zeroed bytes from the specified pool.
+ * Uses the pool allocation function (with first-fit algorithm by default).
+ * Can not be used in NMI handler on architectures without
+ * NMI-safe cmpxchg implementation.
+ *
+ * Return: virtual address of the allocated zeroed memory, or %NULL on failure
+ */
+void *gen_pool_dma_zalloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
+{
+	void *vaddr = gen_pool_dma_alloc(pool, size, dma);
+
+	if (vaddr)
+		memset(vaddr, 0, size);
+
+	return vaddr;
+}
+EXPORT_SYMBOL(gen_pool_dma_zalloc);
+
 /**
  * gen_pool_free - free allocated special memory back to the pool
  * @pool: pool to free to
-- 
2.26.2

