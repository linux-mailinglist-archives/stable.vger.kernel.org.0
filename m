Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3B85312CC
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbiEWPsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238184AbiEWPsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:48:13 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297253EF15
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:48:10 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NFdaIH012813;
        Mon, 23 May 2022 15:48:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=ViUcJD0D+G6xoYvko9BkuDT+D+PrJpryGFJgkM3fzFA=;
 b=IxaEa5mBYXA0GmfhMjLQAnCjpJP8foQQ6Cj4JR5EEuxktuCgHIDmTyomeop9GmNyIL0f
 uPPXgArPJJfs2QP6RkXlAX+wnWOYrDiLQ3ONnWCkJQko54SSRg+kYUmcrw1hxJMQog4K
 BLFTM0+o3/EMpgQtvG98SpXLh93ME+i74kaBSiiwMYGwBHGSRFzr05qe+bI/vn94dSZ2
 2t/HfbREK/wb50K1VL0Mk3MAW6E6YbTJMWnEvz0LErLJmf5N/HqtQvq3rLneWk92lBCU
 9vFmjPSEH6uTvYuwDnluHd/nFH+byfQ1ZyQafmwpeCIbEEytDdIELmwdT1rLNfTkvwKl Kw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g6s94hfrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 15:48:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqnEPPkWfaTTWhTDxO5OuXetxkBPNReskgdGywBsKJZSi3PBuuwQLRL5B6kG5ngggHu8iAmOrARAwgYcc1G2U2oedbHtabIdNnwgcusRSk7pE2ikrOpUqm0DnXQuE2TgjajvgX/orTh6UO4D5L7/RYVgl0lfvJlDCsvLeTchSTxqN9pR1OdCM1yqreJyVn/kz1pB9YLL/jdMWPEYcifqVMZyXSzVfT6DG8ACwlZ9hPWNWJKeHZfAl31QryMf2kNsVOlKJCdqJ/OdmpDANBWAKpGawvHufi4nw+UYHs/m/CDw4PXOrfKYk8gmc9kg5JTfnIBL07imuMasPQsWw/nPuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ViUcJD0D+G6xoYvko9BkuDT+D+PrJpryGFJgkM3fzFA=;
 b=JXjlgstlabrOYRuspwAVC+XGXaWg0t6jIdOXjS8kg0qhntAmBZtHa533MySbx/2vIcGz6nuYa5G8EVerADHNzt6ONhWwOSG3YFDXmJXZGbrKr3hFMw0qfJnGvh64FqRYeGf6AB9YZxR8gxKgH/uD2OZFXB+xYuuYb2YrU4CiUaGH++D6FqA/4Jijm1Vz5apW6RkH5ga/qFb5Pe1QJYDHSNxXrDswEubrefIP2E8vBLcu2P6va5LlCrnTtKtDVMEiAri7GHvKqPZ1a4+uxZVTOtLySOBV6dxo78p5cvW6OfA98CbABZimqr+g0J3dsYhqN4sZlEzZ7YDTpDJT08BrOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4677.namprd11.prod.outlook.com (2603:10b6:208:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Mon, 23 May
 2022 15:48:04 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 15:48:04 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/2] swiotlb: fix info leak with DMA_FROM_DEVICE
Date:   Mon, 23 May 2022 18:46:23 +0300
Message-Id: <20220523154624.1141489-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bfae284-a01b-4089-528f-08da3cd39fa3
X-MS-TrafficTypeDiagnostic: MN2PR11MB4677:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB4677994BF11D1B1FD12A7510FED49@MN2PR11MB4677.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OTi4/v4alaBq3SO7vvXZDeMyzUhhjwb8hAxkTtvzrM68SQ510BUvv8BrpsQeCuWd1pEz4FG5EI696TYUNEhhAjt0KOt1tlkCroTGlac6zSqEXiTMUR3ou5POxpJ6fUODDJI20GLbtFXVVUIpTTtTYeJ/mHXRcJGRfbdDEcKckQpurm/QBZGgfyDX0dwN1kFANE35ka0VtdFW3K8Q1vpKhadMVLIW5JzTpQEt2//VRgWsOkdHFBpQC+mjlhn0zyfCsHjfArW35HqSMHXFgy4fvWi8KSH0NjiVw/t1mr+q+HAxn8azHKgqlok61stIcf8yAXBzl03AOzeqPWkGSRdJbAkTrF9V3q+AjXrYiOWtJiYXb4jtdSxMMmvnec88a/Mpotq+IILqZmFqLMcBX/wrq1Ni8JJHG4d7NUtuaKR4vGElcCmIQCIJnqLlejqceBSMDYCzpLpmwmwh37tyQvA2izaQG2/fhe1+TtQP1jmyB7db/1SfhJ6TQCEtj/e2c52Yd6Bs9saXpnlkITDQ3MXDDtqws7LVwZUWAxV8yv2/xjlXjKvvhcstoM4Z64amaJBHKKMgj9tpm5Wz/chNmNW4fAd6sYhb3ruJHZIij5sok6O+vT2yNu2urStlhRTVhhzRTxi5IDI+VmWDcPF8bmTdqEmP2igIVG4bGI/xwbzCqY4Gt03OShJ1X0+Nh0HJg2xMEpb+xwN1Qj0PjswF/Z4DLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(316002)(6512007)(4326008)(8676002)(38350700002)(38100700002)(6916009)(186003)(66946007)(66476007)(66556008)(6506007)(1076003)(52116002)(54906003)(44832011)(8936002)(83380400001)(6666004)(2906002)(86362001)(508600001)(26005)(5660300002)(6486002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bAi9MzuBzYEuQK36JMUF7/Ulyee1LdvSW36/IQoduQazv4tLkvHGfqVVCQRF?=
 =?us-ascii?Q?+AOxQJdnR2x0kAmYQwWt2dhi/MPcGxyYn2eqL2B1gWcfrPbZx0MaY85NNN2Q?=
 =?us-ascii?Q?SjfSkGLaPf7mkBqTr735JOijBomdCbpZjPFXe5mtTTdEVnyDiSbAW+u9d8C/?=
 =?us-ascii?Q?ttVU9T8iLBtgKtoygj3ECPgknlqnbFwA32X2ywmBIB37rLusEuAKF7yEPRxu?=
 =?us-ascii?Q?VFwQ3l7E6bD23GmmcFHvdb5gfcQjNK7czVOSIGGCLlTR5pnYcSfI2FcfBOua?=
 =?us-ascii?Q?taU5ZYNYwQo0ar9VSEMJrrW1x1LZvxL9y6o/O/QG+dCk2CMOaHhrZfD3ZB8f?=
 =?us-ascii?Q?ydNekkSE64P0ibL3UOkRDj0FOeZNF+ANcgIBgk4UMDftvKJcM8mc5pe86GgH?=
 =?us-ascii?Q?/BmMUNyi4oarOg1kt5yky+9bh0rEORNR6hcf46D8IhrXc71vJBfELo4WFEKh?=
 =?us-ascii?Q?4vvSInGqeSFr+HDewYtr39xdAa0hlkdMypxDbIg4gfzj3rzDOQ1M6rqYCfuU?=
 =?us-ascii?Q?TTy8Dl7WZw3pLAWoBoIcVxFI7InV+HTW4T/XARTdaL9OGVj2c1VS4l2Ad8Nj?=
 =?us-ascii?Q?86NoKaB006OIz+23DLuY8S3tANzozdRfJEuX9L8nTUOETIH8TKuxNKIZaOVT?=
 =?us-ascii?Q?N/prXH3tn+A6KuqoMXDPsun9+WqnCJRMRaE6PCod5fDAweaSMx3DLe8fUTJ6?=
 =?us-ascii?Q?QpCbk8DI+z/UQ8AcwriVsqBI88hT/QSn66FGS2iWy9kFl4uvMLjQQpi7emUB?=
 =?us-ascii?Q?7Nzlvu7g+xRgZA+1HAuYbBg8FobT638yfx7gd14om8dyVFhPxoVFm5ZHBhu/?=
 =?us-ascii?Q?3I7XV9JTelQnX2nY6GuTZ8rgxoJNLumQe0SZb2IWsWppMX8odylmXqZCpXaC?=
 =?us-ascii?Q?oQrdwKcqlGfUvi2RIvTUc/TzhZcKKFLhBSKRHbbmqMuGQov0Frx9bfuheDvY?=
 =?us-ascii?Q?10378/Ny4Se1DQtxsDp6lYY6y18zbcoZaIVjrhVCh9RE+xpazdIyxTkIBEvS?=
 =?us-ascii?Q?tLaNAtOfQvkdWSDRao1yzpnavYdz6BHQp/WvmixB+zY57TG0tTue/0JHrPkQ?=
 =?us-ascii?Q?ATI3q7kMFF+K+eLw+LV5P+Pw5LaLULBXIPR63BZyXL852bBfsfiKMZurrTwX?=
 =?us-ascii?Q?PZnnn5hHxAV3FuE+hKrdKLqu4c8I/AgBvcbn50quBUCK6JhATqLX+34PkUTo?=
 =?us-ascii?Q?XZplaku6p4gKMziUPOc6zx18AyJ2utKWPBqibJa2wTfo8KZJOuqxEe6zdAdO?=
 =?us-ascii?Q?wApmgBZWw+c/UCnkP+h8qCoSzoaJBaEbMa+hAeVFTCWVdubZ8IybTX/QNhPO?=
 =?us-ascii?Q?R0vS3ZPPpoUciVCe/VYu1diZXKK+9yZfoY6XZrWiRp2BHvGErTyRIgGfV9MD?=
 =?us-ascii?Q?PJGptZ6BAuuR+aVowdL3s93Ksy7jxtSe439D6aP3HsCds3BZ3hHIPx+MnvJV?=
 =?us-ascii?Q?koTilZwd5cgyyvHxWa7vER5WPTyDE2cp/EqxtwW5ffRIf3tUSTpwrnC3f98c?=
 =?us-ascii?Q?qWoHsuozauBFICsfkxdyRaOy0h5hYqZFKt/xO1QVPxc5t/ryDdfdBrSCLxYn?=
 =?us-ascii?Q?i2u4oEiqRshYUo95oZz1D91bkI7vges4beI2IdAIEDaZ0FRABcENYx87iBvX?=
 =?us-ascii?Q?KFsJwcDO84vhGiR9jbg0dluCsdkzgC8ZxTyeckz4VFpgT34MOuKlIumZPccK?=
 =?us-ascii?Q?t+l4bCFxhPOVpr1XUzwIcmx6lScj+cdJNfbe3/u2VYGcrFgssFQusfr4BSTI?=
 =?us-ascii?Q?xRI2nZPi0qldXr/mXPs5HQbwreaVSAY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bfae284-a01b-4089-528f-08da3cd39fa3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 15:48:04.1955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ml1S4mZ4W2qZlM6ypl5CHVIKUefMSgiC9Q8W9Ep8QQD7b1z6qNGzjSwcCh90oYcBvSk7Rj+oHFV5pAMrMaNoEOnQwvE7ywVDXhe+cZrh6sM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4677
X-Proofpoint-GUID: uzw9fXprOATOFUjlkdNKK7J6GUQGPS9a
X-Proofpoint-ORIG-GUID: uzw9fXprOATOFUjlkdNKK7J6GUQGPS9a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230089
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

commit ddbd89deb7d32b1fbb879f48d68fda1a8ac58e8e upstream.

The problem I'm addressing was discovered by the LTP test covering
cve-2018-1000204.

A short description of what happens follows:
1) The test case issues a command code 00 (TEST UNIT READY) via the SG_IO
   interface with: dxfer_len == 524288, dxdfer_dir == SG_DXFER_FROM_DEV
   and a corresponding dxferp. The peculiar thing about this is that TUR
   is not reading from the device.
2) In sg_start_req() the invocation of blk_rq_map_user() effectively
   bounces the user-space buffer. As if the device was to transfer into
   it. Since commit a45b599ad808 ("scsi: sg: allocate with __GFP_ZERO in
   sg_build_indirect()") we make sure this first bounce buffer is
   allocated with GFP_ZERO.
3) For the rest of the story we keep ignoring that we have a TUR, so the
   device won't touch the buffer we prepare as if the we had a
   DMA_FROM_DEVICE type of situation. My setup uses a virtio-scsi device
   and the  buffer allocated by SG is mapped by the function
   virtqueue_add_split() which uses DMA_FROM_DEVICE for the "in" sgs (here
   scatter-gather and not scsi generics). This mapping involves bouncing
   via the swiotlb (we need swiotlb to do virtio in protected guest like
   s390 Secure Execution, or AMD SEV).
4) When the SCSI TUR is done, we first copy back the content of the second
   (that is swiotlb) bounce buffer (which most likely contains some
   previous IO data), to the first bounce buffer, which contains all
   zeros.  Then we copy back the content of the first bounce buffer to
   the user-space buffer.
5) The test case detects that the buffer, which it zero-initialized,
  ain't all zeros and fails.

One can argue that this is an swiotlb problem, because without swiotlb
we leak all zeros, and the swiotlb should be transparent in a sense that
it does not affect the outcome (if all other participants are well
behaved).

Copying the content of the original buffer into the swiotlb buffer is
the only way I can think of to make swiotlb transparent in such
scenarios. So let's do just that if in doubt, but allow the driver
to tell us that the whole mapped buffer is going to be overwritten,
in which case we can preserve the old behavior and avoid the performance
impact of the extra bounce.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[OP: backport to 4.14: apply swiotlb_tbl_map_single() changes in lib/swiotlb.c]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 Documentation/DMA-attributes.txt | 10 ++++++++++
 include/linux/dma-mapping.h      |  8 ++++++++
 lib/swiotlb.c                    |  3 ++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 8f8d97f65d73..7193505a98ca 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -156,3 +156,13 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
+
+DMA_ATTR_PRIVILEGED
+-------------------
+
+Some advanced peripherals such as remote processors and GPUs perform
+accesses to DMA buffers in both privileged "supervisor" and unprivileged
+"user" modes.  This attribute is used to indicate to the DMA-mapping
+subsystem that the buffer is fully accessible at the elevated privilege
+level (and ideally inaccessible or at least read-only at the
+lesser-privileged levels).
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 9aee5f345e29..93fa253f2a37 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -70,6 +70,14 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
+/*
+ * This is a hint to the DMA-mapping subsystem that the device is expected
+ * to overwrite the entire mapped size, thus the caller does not require any
+ * of the previous buffer contents to be preserved. This allows
+ * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
+ */
+#define DMA_ATTR_OVERWRITE		(1UL << 10)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e73617b11af1..5796aa1e5cbd 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -601,7 +601,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
+	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
+	    dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 
 	return tlb_addr;
-- 
2.36.1

