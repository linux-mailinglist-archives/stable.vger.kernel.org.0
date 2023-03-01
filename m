Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADF56A6E88
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 15:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCAOfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 09:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjCAOfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 09:35:36 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2095541B6F
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 06:35:31 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321DTKaD015055;
        Wed, 1 Mar 2023 14:35:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nybnwm9ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:35:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD2Er/yxyYWGebxEYwZyLaB9KpTMuFYcyk1IBoniZhRn/pb53BMKYSplik0q2ZWWRbewHlFtDGd0+JPBaAJS+qc9xqr+06625u6SS42unXnAB7yPw2tt9VHIcIb+BLQJHYI9+Zd/qcuA8XAGa/5gUC3ZJ+PRrHYE3FCIriSgesD5qsUc20H4zIQbanGpHoeJElM1UEh65iFqWQLo7wRBuYrX5fqNtLrH5nsZxc0xAk5fQ6XdKRy2/pHoEoiLEvpvYF9gglxn2A3GcSZ8cWcOBX9Sm/7MKrmlo1PQWdJV0VfidaZ8zZL9E/7r330R5Lj4BviYBf0mtwbpmH1qocEXVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3N4es31jpsLyz6nJqq5H9TbQffmGKyHxa8c7zYSRl4=;
 b=k/sbTiXYjLw/oq7sGlbNYt2F7lxpUMnZX0pc76tCPi0wXUYPHi9GFWPaqHz3/8x6+zIxB5/3QP99GhMjAk/86TXwIPj+wq7zZYusXXlGWx2FPivSAC/2IA2lE0dEXfJwQ1FPVvmQHmiPLvwHBWIe3srBzuD+yysawVsYziZhTZHqhB4B8tmOhmyRUHeg58C9sgVRqiaNQWcytA4hv/h7GE6XfAaxLUuZwN2+uX1dyWayU23WOQEbLTIgqY+xnrnf0Qq+ZldBqTR/6HquWfmxIutUp2A1YFtmrpK9EEU2IhiVgeQU4L90y/SXLJBgdazcTBBIls64u3ZGCV0/xSbwQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7870.namprd11.prod.outlook.com (2603:10b6:208:3f8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 14:35:26 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4%9]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 14:35:25 +0000
From:   Ovidiu Panait <ovidiu.panait@eng.windriver.com>
To:     stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 1/2] drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init
Date:   Wed,  1 Mar 2023 16:34:57 +0200
Message-Id: <20230301143458.3440128-1-ovidiu.panait@eng.windriver.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR04CA0098.eurprd04.prod.outlook.com
 (2603:10a6:803:64::33) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|IA1PR11MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 50168363-fda4-451f-4219-08db1a623229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+sVZM7zzZmRubdT8bEssfN1oN2gnMWSTmMVVRRiwFHJ+0HUCeJPfxsKt1pj8EIuA3QMoypDpz3k78m0J4OSSyJVygUWFSr0jpfGNaEe2q+K7XjA5dE3XS/D1TkzXsFaMl9ftZwaCKLvMfOggyUi2/4YgyYT5PkGZ3opI0CAMCI8iAqrwb5dU6avWBbqzJhOLF9gjPFZNmxHhbvR4eh93vARLWz++ASe5WryI7Vw+8g2IVR1JwqjJIH7VrkKq9lpyK3mXLDjLbq7LUkRAGjUSiiCknlYIqYVVonGBJGCqIleojRos+CMM33hLRXdB6usWuCQBjvJNTTyF0EkPZfP/U5WAyLKlF82Eq5/o9GMf7PmgoM3dXgfbR7RHvLUF9Kt+AWxgJcHF4sZ56RogiGJhLQmZT45lCHa6GgOpdf+h1SMMBWLDeOSzfWcDzD8956mbEtzgd07MprIVNmDRNVOEeDitkt584s0JUMjpX8vLq3mN++mRV3lRYvsgKzMcecM5Kh2aBI+WTMB4AFETFzqjgFqG7COZixBhu8h/e2GRcMbHl6u4lJiaNzI6oO4Z8lVQf1qx7LwDriyNbZhQ0X5miG3Dsp8qLRWbTkm5u+KA0wOKDER3fCuMwxi+pTn2XeEYc8lVaY4lFdwWert16C58g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(84040400005)(451199018)(54906003)(478600001)(83380400001)(316002)(4326008)(6916009)(8676002)(38100700002)(38350700002)(6512007)(6506007)(1076003)(2616005)(186003)(26005)(6666004)(52116002)(107886003)(6486002)(966005)(5660300002)(66476007)(66946007)(66556008)(44832011)(2906002)(41300700001)(8936002)(83170400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JzA/i2O9rPeLd7hjGR/CXK0FEAfSUbNBCnRciAjZlyRHcuZhxWx/aunBrwpP?=
 =?us-ascii?Q?CSucOm0m7nYGTJnQQeHKi7Zx1a4y0qbhgsaRdsGeE8Kxu8OdGm40/HRmTk10?=
 =?us-ascii?Q?FPPlz7DyYQ8DEQTE/RbaDQiLY58NQ9NIW/jcUGTYWz9zpA5oQW+b/Qwp/9NJ?=
 =?us-ascii?Q?T27uF/GqRwife0qCGoPidLbwNsXbAP+aFvWdPia0jE/4IlgfxFcuPVa3QXgd?=
 =?us-ascii?Q?neycs/vIblfZqg6fUs2AQquUTr5y8k+gpHmV113HEpQZVXvLz47SUYnSacGC?=
 =?us-ascii?Q?EJnkGHHhqIT7W5fLvFqo/di9NAX2p0MS23kdVwP86JBmey5XTD3NcfvjuzNT?=
 =?us-ascii?Q?e+vE4XDtL6xiPrZb3Qo5JZovyCRWVfJlW12HKwR6Y6lttMt+KKDakLDcv6QE?=
 =?us-ascii?Q?2sG7lClpsv04UBYYlUiqn/TGN25A7g6rvPfhMXvyEzelHal1DijzJMN6qPhp?=
 =?us-ascii?Q?WMNaZ2Gm+Faubwh/K0j6EUpnOjAejQ56/32vHiTghuIHvrcYdmlZujrFCgXd?=
 =?us-ascii?Q?xMn9MtOucjqMcIBN7vhlclopZWH6VCiZsd0DBfG0HQn++tGTkNcqYCh+WzlT?=
 =?us-ascii?Q?L02BsUNxhLcI47w6yselRzIfLOH1IpEPjNFXo0IiiL6QLt9M1t55P12MXmKw?=
 =?us-ascii?Q?RY44QqSK3e6TAXx1JHf6VFHDAxmHnzKEl7uqmRv85xJToML2Axlo1WwV02+N?=
 =?us-ascii?Q?0mZYehZ6yKovBeFSxc6KHXtTi9nf7UYpFBKqytYbq9X/p+xrJKWivzpMmLGO?=
 =?us-ascii?Q?h0ZZU7ycQKyx48lXopLIiVqcd7xmFzN622sDbjdyGk/PxkPCGEwqTf3PGHhH?=
 =?us-ascii?Q?j5rkJl6oR4DL35r7ZijFvAg+gCWDbLd/uJst/Ac4weuzlwUjPBIQpbIkyBBH?=
 =?us-ascii?Q?Mgb9IoIrsGz0EMByvvsLkX0eI4dO/VmJqqSsZQVTZOj/Jh1lcciZRjnZyMDz?=
 =?us-ascii?Q?Y3728hw9MVAEJ/FGvTujKzoccWHcS2VwOBHR9hvtqOVpkBmdRxdqIniVGS72?=
 =?us-ascii?Q?/HCxe6LAAVRlYGY9AkTL3ZFNxv7m6igtT7DcTVXxtgQu7Qr77VGe1O0eK9Qx?=
 =?us-ascii?Q?c1nH2IFWLCKMT2zk2GhrX62c0FLTjYI1RLGpU1XZn7cwfoRaRjIEFSt5Z+Mu?=
 =?us-ascii?Q?i5wS6G2AuOG8X9Sg9KUER+k9r736dC0cY4++E6I/LNIOO2SgW4s4fIp1BC1t?=
 =?us-ascii?Q?gssC2Oqt8i9lmRinE2qKLqikVo2VYfVWGD9q/nyRkII9nTEtuAduXkQw3uCH?=
 =?us-ascii?Q?4L/yVCdBLSJReJKn4ffOJ2THYzBr7bw8tQHr5Ca5PwXasoB7GUA73oNym6Xg?=
 =?us-ascii?Q?xulLqcOaoYCJffkKMLef1TW32ufBnGiFzTXy1YDxCHIdfDaWAVoxE/GCXIJZ?=
 =?us-ascii?Q?ihG1/oyUYf6/oLmxEqUZyhuMcoKbQli2CiRIL9ITGsTi2OcYtqEGfIqQ55ax?=
 =?us-ascii?Q?wzaHGcD5yPcrQKhBoiJCk2gt3P7p+79kR1v/Bp3yxhejmV6TCQumQTNYj38s?=
 =?us-ascii?Q?ttlut1uEKeEc3F5BCLNvnI2hW7mC27HUGWGAuCsVnlfPnFNEfKYKhsFP3S6O?=
 =?us-ascii?Q?e2nIlVQxCbkYc1MFZBbpM68qXs5RJLP4AXwEgakZl1gSpLu5dLQAjuMTfbB8?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50168363-fda4-451f-4219-08db1a623229
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 14:35:25.6082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aoum4+0OmKv9h49KXcNURLJhfKHPtsiY2B2hedGLRjuDg35vVachOinZUs69Za43NOcifLbFeuphGTKX4DdFKoznPUKGZDoO7FvXEE/8Dy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7870
X-Proofpoint-ORIG-GUID: luqg1iW4jRAUU-J_GyBzlWKb9p4eI8uM
X-Proofpoint-GUID: luqg1iW4jRAUU-J_GyBzlWKb9p4eI8uM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_10,2023-03-01_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303010120
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit c24968734abfed81c8f93dc5f44a7b7a9aecadfa upstream.

Since drm_prime_pages_to_sg() function return error pointers.
The drm_gem_shmem_get_sg_table() function returns error pointers too.
Using IS_ERR() to check the return value to fix this.

Fixes: 2f2aa13724d5 ("drm/virtio: move virtio_gpu_mem_entry initialization to new function")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220602104223.54527-1-linmq006@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index 0c98978e2e55..d4fab3361d2c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -157,9 +157,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 	 * since virtio_gpu doesn't support dma-buf import from other devices.
 	 */
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
-	if (!shmem->pages) {
+	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base.base);
-		return -EINVAL;
+		return PTR_ERR(shmem->pages);
 	}
 
 	if (use_dma_api) {
-- 
2.39.1

