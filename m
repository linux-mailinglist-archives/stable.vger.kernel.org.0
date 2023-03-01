Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE16A6E89
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 15:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCAOfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 09:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjCAOfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 09:35:39 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D2236682
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 06:35:33 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321DTKaE015055;
        Wed, 1 Mar 2023 14:35:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nybnwm9ka-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:35:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaPWJ3IeYwhry9w2eOF5ef2SexVtmdLe2yvlzksV2T9nSgeIaZrzCLl7uaL7TTiFbnWJPYhEwn3CbRWX7XGn5zvmxzeE+wh5Spb818MOAl06WM/durEHPtGvtEwOc54/4Gu+cuqUuyXZ2XSIKOFjaepO2PIDXPOafORYLLlm3+gyELO97qyg53gUnHPtTfJemfJIppIi9Wfbrgjqp5JeVKSYsJrApJ7Ac02J/rKmD38Zp+s8/gvt4Kr4pewbGBhpdAzuPr6PsRbljoXy/6Z/ys9WP0aebvmC81WHYFyhtE62l2K4gmH7ovLxoBGzvzpfxdhUhFTvvWgkdd6riVzYNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9NISslKsWkk1iZQn5s9Lc2lK7QOaE4FY+RDYG+XJCs=;
 b=cdVaA66oAcYt4M4yoMn/VeJhLMvKMWYZGkJfwAfvFuc56Ths3xONyONyKAQYLCIjDpQPwT9T1goFSez0LWJQ4fVn9PqEcA0g3wiAzoiKTTAS442zkPBf4UqBf9M4FabU0cH6gGnVljZUmIouNkY76Xy1iNEgaErGcKfh/z13eeVJgOXoTcptYP1nTQ2FRvLKe0XXQoSlcFgr1ZJ3UD5PHBwrZokG3fCRorjpmaSdwr807WHlPQ6veOBulXFl7x18YYt5UJgOQMD8Vlc1bKjGiGTSihid7QS1xEIRgCcWAOvc9TEMMep3l0enCzUtJjWTaeX5fwsnUNAijLrGlHEjxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7870.namprd11.prod.outlook.com (2603:10b6:208:3f8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 14:35:27 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4%9]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 14:35:27 +0000
From:   Ovidiu Panait <ovidiu.panait@eng.windriver.com>
To:     stable@vger.kernel.org
Cc:     Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 2/2] drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling
Date:   Wed,  1 Mar 2023 16:34:58 +0200
Message-Id: <20230301143458.3440128-2-ovidiu.panait@eng.windriver.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230301143458.3440128-1-ovidiu.panait@eng.windriver.com>
References: <20230301143458.3440128-1-ovidiu.panait@eng.windriver.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR04CA0098.eurprd04.prod.outlook.com
 (2603:10a6:803:64::33) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|IA1PR11MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 68d6574c-0adf-4218-1132-08db1a623340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eOAgkO6puY4NGnkgKggieZA4Fau8V373XasbjEn8ezBhzyFtNbK/I2Ch/XVVgV0PiG1jITWpIRSwMelpR/GiB5juT1CySQuNHpqrvGW2g9Lts2VOYZ8i90k8y7ulQC15GK91ZE/csVRVCGUs/Uvgdp4D3snGXXXqjC1C7X4XsKa3erN6LbjNyRfbPCQh06hYRd1E7X96JCNPh0iGrPF0b55LyHq4I3xyevmAJWRaeY1GU+ZMVnoJMVb57iWPhHj1aSC/y5mtWBJVPtMjwe7H/vKE/vCWwglTHKbldUR9bcmTj40a2u7xHJNV9MT9Bb1qOGEcAKT0QKvFFIjzVnOb4XPuSFQhrKp+Q69bc16TBXi2pH0N6wbg9rm83vHqcorljmJXq52fyWIYAhgkZAWe7QlgK1Zrw3CUlUMWMIetELzh10MXENLeL/vnWmghIjVTFMDtj2YNqJ2oW2MR+uk4SabnEfqK/wcFy5/bm7vTkYmoghSHaXrej0OpITWb5HmRP54eg1zdiDhklG07XBHz5oxBN0w85FUwQtsQ0LTTWGHii9SUScc1SUienvJNjajGgGWUBbjxrZpGK4tOpwShGD2Iua4jK9ujIbnsAGmtdKdmhmyFyQYLX0vqGJehjqjY9jOBq9nHXFhbyo99jC0NmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(451199018)(54906003)(478600001)(316002)(4326008)(6916009)(8676002)(38100700002)(38350700002)(6512007)(6506007)(1076003)(2616005)(186003)(26005)(6666004)(52116002)(107886003)(6486002)(966005)(5660300002)(66476007)(66946007)(66556008)(44832011)(2906002)(41300700001)(8936002)(83170400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qDMdjyHLycFpPrW/vKcXtbCm0jXjToo16w4nm82ozNTjRXMDkhcEKrb4ZPaI?=
 =?us-ascii?Q?2STTnj8AkznTWpmzcVAzX3pU9NEzQR4Q4PAzq7pIF5hZQnAA3avq2BGi1hOW?=
 =?us-ascii?Q?W5wacS6trY78BPvGWh8OgX5shMuizmrQMpWb4w9S0zH4m2D6wqjE6KfHzxum?=
 =?us-ascii?Q?ebNZ8QRd8QF6oMiZcM8+5h4Eitj9Gh8d77/9kAMdOu+00v5uAUPGDuKHkt34?=
 =?us-ascii?Q?y7+K6EmSsbD6/tc/VPC4eKxXdyn1+xF/SQABeqkYlE05u7/0GhzgglCFzOOj?=
 =?us-ascii?Q?NrFjZQnbDZYree/y/NpkL54vZna3njOPkk1SqjHUNrCj6oliXKOoKv2JH1XI?=
 =?us-ascii?Q?ikATKKYxtro/Rl5L0BWdLlqB/pF9iK+uSj8bjbEDc59pgLnkOxVH5vDCQ6Ut?=
 =?us-ascii?Q?e/hPRoC+5/tf4C/elD7rP68QnbSQoyuCPa7iWvrROHOll2pnj2wVCYPCdCpZ?=
 =?us-ascii?Q?gD/6zjhm881On6SQgGjRBqIZ3ACerROAa4+eFUhBdvmTlmiYeH63vL5SHry1?=
 =?us-ascii?Q?BmcHaafbHaLgBSuCnsOkQZbFWBrq3y19FBWz1o5FdUDYV/z/NudVsgc2s+il?=
 =?us-ascii?Q?UFJdHBKtgKaprug92f7fjYqI5s+/WzodJ1wytTnRZeNNLNiNgP+9cNDi290Y?=
 =?us-ascii?Q?hGmJ9zOaqRYAwiILCR5LpKqYTsrX+hAjJz/SvagFBEvbWEedjRLdxpZ9JiKX?=
 =?us-ascii?Q?WBWo4RZAGc5sqwSpMO58phg5XHSLCfYxTQcLioB95bgN2z5Igi0CwtJY0Ysc?=
 =?us-ascii?Q?HNQocJANGsA9L7Pva0LSDYGWFH4egM5xPRtBeXgvzqP6SwaZnn61xaQw/L5F?=
 =?us-ascii?Q?ImDQJJxSAxXnWFKI5J8x2bdP1RXVGIxUWL4Sa0u9hVB+FIWBWV8HS8vKMOrL?=
 =?us-ascii?Q?CjXNC8fWB6l+BfAP3TyTEEMStSv2uO2DyvjRABEYpqrwgdGFEMPB74o81bbh?=
 =?us-ascii?Q?Q2dFjd/ciWt2cvYYlRIR6nieJt1T4BnJQu2pgGCtBsAbUj43L8WFXzfsgy25?=
 =?us-ascii?Q?c0P0sQAEFdHFpcO0ppy0OF8+IyrDYaulKDPZh9gB9BS0coN7c/Xz3mEDzxQ1?=
 =?us-ascii?Q?QBRcXQLy2FNNSyG7OUuVbQi0/rwcqU5WmN5fyHu7UGpP6y8KVqDYkef9P729?=
 =?us-ascii?Q?fqs2iWOHiEuMgQP1/i5V2kDodfoe/VZuaXRUgPCQyHQm/44C7F+wX9lNlWrO?=
 =?us-ascii?Q?gzVf+DqukzMFgBc/IWc4uKXWFgnhpjUI9lAwBZTWDR3lBamvHYY6JJFANuH+?=
 =?us-ascii?Q?MTl7rYtQKvFyqhidf5OlHkzixtxzZc81PSdEqygmXtHjvb4DDHCN6Uxs6BIG?=
 =?us-ascii?Q?obTmYVWJhedsVdUvzLWAKzRFHw0Os1ZjBfDtmMRLxJCJYjd69C9fVdbZc73T?=
 =?us-ascii?Q?zJeWaPgh3WwwIzjI0yjm+y/S9Jp5yRBc9xKOgB3eygdCaZP1d1ZSwtikKu/N?=
 =?us-ascii?Q?TXS51TRLMQ6tDM+DJtfvBVHpqosbTmDA/5ngDX3Yz8t0mPdOLFOu5i8TIben?=
 =?us-ascii?Q?SRe8/EjTtnjrjRHDszU9jCURuNrTj14nTnwtsXXABujdjffvt+aMolnKQu1n?=
 =?us-ascii?Q?SBaTUWSMyPPHe70AOi5qUR0vYkXe50AWA1329SPmFdBYpg/GPFUSiWXOdLYR?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d6574c-0adf-4218-1132-08db1a623340
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 14:35:27.4041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mA/tmmITSnwe2BSaUdmYsbrLk44/N971T6gv69Fcp28Cydt8Kb7LUlp32z2ZiEBPExL2KeMJTl1m2bz/6NC5cEdRbz8i0jqyiw1/tEYvSe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7870
X-Proofpoint-ORIG-GUID: hrx8GUZCdXSKx7naZ5TaKnfplF1T_4AH
X-Proofpoint-GUID: hrx8GUZCdXSKx7naZ5TaKnfplF1T_4AH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_10,2023-03-01_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 mlxlogscore=920 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303010120
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 64b88afbd92fbf434759d1896a7cf705e1c00e79 upstream.

Previous commit fixed checking of the ERR_PTR value returned by
drm_gem_shmem_get_sg_table(), but it missed to zero out the shmem->pages,
which will crash virtio_gpu_cleanup_object(). Add the missing zeroing of
the shmem->pages.

Fixes: c24968734abf ("drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init")
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-2-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index d4fab3361d2c..168148686001 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -159,6 +159,7 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base.base);
+		shmem->pages = NULL;
 		return PTR_ERR(shmem->pages);
 	}
 
-- 
2.39.1

