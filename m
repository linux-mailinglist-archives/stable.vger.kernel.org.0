Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3D369CC25
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjBTNgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjBTNgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:36:32 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF761A640
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:36:30 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31KDQrrB016609;
        Mon, 20 Feb 2023 05:36:23 -0800
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nty2psedc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Feb 2023 05:36:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOPPejgmoORz08sMcId6AvpDbcuzg+xOq77ZRrcUdgat2VQTbH43b7ZrILIms9w7T+ThV3BRDQXHKflRne8qE3UWFDGPpDHf+KvK6DwLE9pJrDAdF4GBuGfZgPdG6MvsPTvB5PSO1N69EWjUY4KophiybCARtEQQ3budX9VHsK02bgtCFrRwdoT1F7N+E3T11lqd/Hh5QyN5P8V34wjNmWYWzn2LQv1vRnh5nx7C6EV4WIEmtDXMchnwDTWnIRaTK9bPXjLo5BKn2s6zNR7jQ9Dk88h9deSKExnhjIZNh+b9tgmd2XQIdHLWrt3p1pL4Pk4y6+O6zLtDk6ZjWw5GJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmqOmsuq1RR9woEHF+C9OyCgSmoAVsGJyNEL4nXtc/w=;
 b=aWwWFDOoIvUz+RiDhd4wVUaebPpdDxM/iaQuIzyv4Ltk8MNtuF2h+3bUtNj50HIM5OX/xoEiBFVajZMbw7UoXh1A1n5Ooh861Pp5+84rsbOHY+ViVJa/2iu8Ziof/Vtsd3Bi58B7cJZ/t+zUKN4iZ+7QVlBKZCx3LGCSqi2bygpAN+nH9Ncgi5K2PNPF+okd5S7qdCTKbgfOAsBLp6wSYkpGBCp6cyOwl+SIRtM6KpGeh935odx1GUHqpP6Kege38D5i/9JXweh86Wh+QF9r8M3UXd+SUsKr3xy8zW5LgEQFN6oOPR6MJf8xhngMTIa9cqpj2m0IEl1FMs/VFSrijA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY5PR11MB6116.namprd11.prod.outlook.com (2603:10b6:930:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 13:36:16 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 13:36:16 +0000
From:   Ovidiu Panait <ovidiu.panait@eng.windriver.com>
To:     stable@vger.kernel.org
Cc:     Zheng Wang <zyytlz.wz@163.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Subject: [PATCH 5.15/5.10/5.4/4.19 1/1] drm/i915/gvt: fix double free bug in split_2MB_gtt_entry
Date:   Mon, 20 Feb 2023 15:35:54 +0200
Message-Id: <20230220133554.2736427-1-ovidiu.panait@eng.windriver.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR0102CA0076.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|CY5PR11MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bd1ce12-7a23-4398-67ac-08db1347710c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Oa9B/A3OeRmX7fClC+ERLE7i8/dnfGeDZZ5+8UvPNazpCnUGdex1qa55o5vpLqC/bC6n5GxXx84p3u0/2fZ1dfdvF6KNL4+0l9sONX8G+sOh6Tp00xPvW819VtJgOn0eGWX0frcNe0/xlrHDjtLtONqPFr2McRcrFAeHuO2x70l5MQOp0xbu5FQKdZJZjzV/JRZDaU1p58qGy2Llwa42iyPaeGfjyZw9O8GYgGWxJveq9I32BGaPPI4tPTCPWArgn+ezYMnR8RgeAkZlwIGAwbuavUDdvaF7H2AsmP0vj8RtJkbRBkSzhqB8mvOoZAcn0H33s5nKBwnWWaLpz0+6PAKLbS7w9velK4CpVxatq/OgKhhTE5CdU9wq6e7zabp//dKPnzFIKIY/1TYsP1QA8QrZq8F+ey9q55RF2Cwl/XjfJduHv38XC/SmVxAm5X0bzrWBLwSEh+aeLbB3Y4eDiYIXhesp/cL6tnPBPz1mW25cG2j1lDSqKI7W+03h4PucKDSVDLjVXib6tVf6lqpFKabXLvbUZCtSmX5cSNmThJfnOEnZMALuz0PTAD7JyPDUSWQwu70VSTZxHULEEJ1I/w6HpKUiPWcTo3OXMJ03HpOSz2TBVaj4UAB9bYDyJmUN64ggMzDXTUzvEq8tO/IVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39850400004)(376002)(396003)(136003)(346002)(451199018)(83170400001)(38350700002)(38100700002)(2906002)(6512007)(26005)(186003)(41300700001)(107886003)(6666004)(1076003)(44832011)(6506007)(5660300002)(2616005)(8936002)(478600001)(316002)(6486002)(966005)(66556008)(66946007)(66476007)(8676002)(6916009)(4326008)(52116002)(83380400001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0aV0Xf8BcpaYSd03N5dvE1kV0tQpxyWIFc/JWPKqKBl53mT96Qzx0KhKTP6+?=
 =?us-ascii?Q?IJaVG2tASbY5zg2fBaFcMFSugcgHPg1E6MFI78sGAG6UQEx+DLp429IlLNpj?=
 =?us-ascii?Q?70pq74KyfTLtvlYDc03Os29RvtYHfBA9pn93Dm1BZ4ax5ioHrEOHVdrNG20E?=
 =?us-ascii?Q?JdhYaU30ooAXxCvtsqPrRMNP58kcGRJcn73a6/Rt/YZFfud0h3Y6ZBHETJtC?=
 =?us-ascii?Q?aIY18uiB55qcd+sXz6re+0K0i3Swvaq14C/GRI7GhcBKoxlAzn1tyQivHyIJ?=
 =?us-ascii?Q?iKSJtVPt4fRVA02xvDD3kdj+eYIuvqMunA37pnbY1F9I9jys1/LwiWDoVvBQ?=
 =?us-ascii?Q?IyUUEodrG5CInyIxQQlGFPaqiAJxZtZZq8vd8LJqn1k6uUH/Qpm4FgTFaYak?=
 =?us-ascii?Q?I4d5IuuGlhZ/yJKMbURkJU0FrmBY55by6RQa0u13xXoEUbrrXDN0RwG2wSRN?=
 =?us-ascii?Q?BaNaq4pjom5Qfl8NTfrxfZDE156Vs7/F/ESvBg4eMj4yqAla5LMIQoRTtgex?=
 =?us-ascii?Q?wzD1kpMs+w/UdhnHvuxnObvMDDIbTVwPd4r52UlfbjORsRphNWnkEACGN0lL?=
 =?us-ascii?Q?Hiw6W4A3n54cibhY1NKLaviJbM4Qnkgd3JcfcuiYrEcdWf0Le8o5t+XjEJwG?=
 =?us-ascii?Q?Tkkv/RPpmx3MBqxj2Fd7cJan3x4Ubo1Vz4KKtXkQrJCcR7wm8OVddyHaS6X6?=
 =?us-ascii?Q?KDfvE7yFg+bKAdi/57j+/6QcE5y1J94pzo66Ws5YSAnq1QbCejbtzyHvbX8k?=
 =?us-ascii?Q?wMTG314u+LW0EL1QoSXgkXJpGeVKqmwc7Ga/qCo/mvcEq/XfIV7r2M+/IG2q?=
 =?us-ascii?Q?v6OPpjGI7H9pban+WkhYBYPQuGW0UNhevpASYjM1NTyKsK0awgFIrRnFEmcm?=
 =?us-ascii?Q?WO65+K51gX9yxljJty/fcgDg1g78KRKw0dOTGT9487t66I1CTQDPVCUbf1JA?=
 =?us-ascii?Q?gbU44PfMbln8j+qtMkCtzgw392WPEtkha6Q4D+9GlIReK2YHaZ5JJB0hZJm+?=
 =?us-ascii?Q?ND0OH/1Alg23XlQvpfblUa67v8d/6wJI5BYOZ6Z/TjEVq1dJfotyVHW/3Bk0?=
 =?us-ascii?Q?eL8GKZHPzOHyQUQ3mJ/3Bk+DEw9Tj+i3TrhEDZnB//MxTsBx68udRdWLhR/1?=
 =?us-ascii?Q?AVVjU4wqo1FD3OdM1ur4mA24OmDx0XLQ3LLYQStMeT7nsIK+XYVsJpWeFx3L?=
 =?us-ascii?Q?MPHMQApftC1WfiN0QvsYj22T0qgB2eW2+F0G9wtJPdk06IPaoh2cL84EASBQ?=
 =?us-ascii?Q?QNoeI5Wd3gX75c1Vmb1cjr8m9eujHJN/NpLcRmmlElIIa11H3kIJfXkHABl1?=
 =?us-ascii?Q?otfWKN+LLYSeDSBYL+BdKecxPdh6sWbgmnqamrKptQgU4QEt0DfBGaMijEMM?=
 =?us-ascii?Q?jYhtu3DAUUKbunCaBS6G06UOwColC4H+MsuTvuelqKXax0LtqIIqg51yb3B0?=
 =?us-ascii?Q?EGzuQeGRRSh56wCWz2acrgu1xS8BZSOtwtg0I0pW75Q08YtvQA+dlpEKDADb?=
 =?us-ascii?Q?wkEGzdUpMMqeaK99x52rmwHoN3psxajEF6iNkeZ4oioOMr9w+bJgBs4Mma3Y?=
 =?us-ascii?Q?MKaGDLc1SdbflSOWAO8lMf3xqw4WYrAMszstorzmuRDFoAoQeKwLEoe6yCRg?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd1ce12-7a23-4398-67ac-08db1347710c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 13:36:16.5644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3nKK6sVrLUwjlIFhR/6PWWW8KwR4evZTEEfKWLijfaYN+Zbgw7SVBWVWp2AehK9QLqHgZ6A1/6mg2RslLxHBwPavuWYzmnsOUlS5fUiRDD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6116
X-Proofpoint-ORIG-GUID: sFik0stg6BWAaOp10WtAfikLnH-XdR1a
X-Proofpoint-GUID: sFik0stg6BWAaOp10WtAfikLnH-XdR1a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-20_11,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=963 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200124
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

commit 4a61648af68f5ba4884f0e3b494ee1cabc4b6620 upstream.

If intel_gvt_dma_map_guest_page failed, it will call
ppgtt_invalidate_spt, which will finally free the spt.
But the caller function ppgtt_populate_spt_by_guest_entry
does not notice that, it will free spt again in its error
path.

Fix this by canceling the mapping of DMA address and freeing sub_spt.
Besides, leave the handle of spt destroy to caller function instead
of callee function when error occurs.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20221229165641.1192455-1-zyytlz.wz@163.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
---
Backport of CVE-2022-3707 fix.

 drivers/gpu/drm/i915/gvt/gtt.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index e5c2fdfc20e3..7ea7abef6143 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1195,10 +1195,8 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	for_each_shadow_entry(sub_spt, &sub_se, sub_index) {
 		ret = intel_gvt_hypervisor_dma_map_guest_page(vgpu,
 				start_gfn + sub_index, PAGE_SIZE, &dma_addr);
-		if (ret) {
-			ppgtt_invalidate_spt(spt);
-			return ret;
-		}
+		if (ret)
+			goto err;
 		sub_se.val64 = se->val64;
 
 		/* Copy the PAT field from PDE. */
@@ -1217,6 +1215,17 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	ops->set_pfn(se, sub_spt->shadow_page.mfn);
 	ppgtt_set_shadow_entry(spt, se, index);
 	return 0;
+err:
+	/* Cancel the existing addess mappings of DMA addr. */
+	for_each_present_shadow_entry(sub_spt, &sub_se, sub_index) {
+		gvt_vdbg_mm("invalidate 4K entry\n");
+		ppgtt_invalidate_pte(sub_spt, &sub_se);
+	}
+	/* Release the new allocated spt. */
+	trace_spt_change(sub_spt->vgpu->id, "release", sub_spt,
+		sub_spt->guest_page.gfn, sub_spt->shadow_page.type);
+	ppgtt_free_spt(sub_spt);
+	return ret;
 }
 
 static int split_64KB_gtt_entry(struct intel_vgpu *vgpu,
-- 
2.39.1

