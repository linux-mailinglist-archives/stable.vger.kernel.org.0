Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66CD6CC15C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjC1Ns4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 09:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjC1Nsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 09:48:55 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DDEA24C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 06:48:54 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SDViZO003387;
        Tue, 28 Mar 2023 13:48:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3phqxbu925-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 13:48:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NaXPvYKr5BYNHQcf83o8+EqvfZK74k3XcZQPLpSKNq+mD7LjBdVe5uj98t88TUgbr9XhxtlYnOO5rirhM/lhAVFWAFJ1+WqDg5siHykhYsPPcxQgDy5xrbruOhb2h9EyOsL9HgaMDE1i8GT5dbSrUSSFIBwmoCJDYjXpAKjw5Ni340jboUy5yxAZ7NNj5SP8KE7V2QxOIXufyVJMFluwGqG6vLFaaY/LjMkpXtH2H+df/rksj0BXFL2go3/9MGXfmw+3236BpbSetoStGbWT9StvKvI2iEdG9qi9CJgDGrUDtPVUQMg1d5s1eKcNpLUm5uZ4eqLjdoxbFpzuYZPZPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yImPVm/V7x8s6MLVU3wgPxNShyQzaRgA440CaJOK+TM=;
 b=bjx4m1FEsMtyM7Bd+i55i3jHiln6sAgcwodq/PaEw0WRz4s0kvvbChtM7XJr68GY6dBgPqDMjIR792IPs120q+ZHD/85mDamw0hbt8GlmJclR3sqsTkcz1etBLUlW//kQkvEOdqPoOmleEGvfyrNX/YFi90bIdsogDc+ve8aV/ShqtE1Sxf5V3hUmHiLG19Y5108eK49dcOCI1VlvXLggYS0Gq2yfiDN9JBxxfhRLlb5Nnp84str1w/i1Pk6k9HjkyHb1pshrQWKRLMngRvHALpYTm0mOQxF8PPGa768R6PDnbushjTnttY4cWO83TTHRjZuybDOec4wMN3NN4fACw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY8PR11MB7687.namprd11.prod.outlook.com (2603:10b6:930:74::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 13:48:48 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::9f42:14ae:2b0a:d1fb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::9f42:14ae:2b0a:d1fb%3]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 13:48:48 +0000
From:   Ovidiu Panait <ovidiu.panait@eng.windriver.com>
To:     stable@vger.kernel.org
Cc:     Dai Ngo <dai.ngo@oracle.com>, Xingyuan Mo <hdthky0@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15/5.10 1/1] NFSD: fix use-after-free in __nfs42_ssc_open()
Date:   Tue, 28 Mar 2023 16:47:59 +0300
Message-Id: <20230328134759.401789-1-ovidiu.panait@eng.windriver.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR0901CA0108.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::34) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|CY8PR11MB7687:EE_
X-MS-Office365-Filtering-Correlation-Id: 25630c1f-c8e6-4946-6953-08db2f93285a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9VEm0Gige36O5d16bEe3xqnPDj/BGLTHOzBdDR28wEn6F85mEglbtVkkNYhFfJVjIainiQgQ7/DTC+s8pguwbbVySpRt6VElavIoJvhAiFnhhRKMeFJ5ghL1s/LxsZx7PIe6ZwdQlhcVI68iLD83KnPEJxBcKwKtrCKwlwSVsxAi8UTPmTAFPEWK07ReqrymxaDLMdGJRa5A+h1jWFqGTi33bsGkbICKB9EGSz32EkA4LGA6qBKEY9jOwDXGrUzzzGR/wJ4f1qEdzp6RYLvffe+VQAmEspqqv54U3jDBoSLyOvesbgrGoRnwi0+N+Tk11UDqQkKRSUSMJ4EdtdR8HNerdWN8wnGZmEQZDKvnVvT6YAseRpDhEqXd90nC4vuLT31leLDxI48j4XuUb9gzAyHGwvfHIf7imB/7TJnk+K0VmOgI+mNQhxzR+RRvAiYZZjBWSsyirJ0C5e6blCVsg6sec8Ewq0cRInlXxQH8NLOEVd3hdK7hTn2HzmTY1js+wccjlILyEy1xbFwzzZITrfzzIb2MG8/K8RgW0BFuhvQwIltVpYIZ1ttIgq+oYF9qREkSvN6TS2DnBa1fzkqM7ddYxm0l68hXfvh5KqBEhlaSdDsMm2ZJdBI6m0WFxgd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(39850400004)(396003)(136003)(451199021)(83170400001)(2906002)(83380400001)(2616005)(5660300002)(186003)(6512007)(6506007)(1076003)(26005)(8936002)(107886003)(6666004)(6486002)(41300700001)(4326008)(6916009)(52116002)(54906003)(66946007)(38100700002)(44832011)(38350700002)(316002)(8676002)(66556008)(66476007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CzQ04UoImTOo9/5FZDR8wYv9Pk0OiVnRzveMkVuBvWJsEahoey/Bxszp3Zsz?=
 =?us-ascii?Q?7hP5VIkx9Bw/Hov5dHkxeyAUpfARvkTSlmt5YoANeh9540PKmCdCHGSF1oGw?=
 =?us-ascii?Q?x/+zA4tx5F0u3lL8qhj+f1sMcLD1Z43XWFv+HLRAg0LlME5GoDqrdCfNJWAP?=
 =?us-ascii?Q?3oORu7rUM0J1CQBkBCHZ+bj5cvu0wbkev4xITQmjaUOeuMLDoAxvo6cGgns8?=
 =?us-ascii?Q?XOnDDesha4iId+gBfBaOKWxI2/lqARiqGRuMSb/Mzd9O666KyLvFIT22MvRQ?=
 =?us-ascii?Q?F8qgLfEpHCH50dB1wj90Q+do/ho3IZXUfGM/6Hj+cVSUFQnXhn2P3ZDJ/99A?=
 =?us-ascii?Q?GCXseQtmGTRdKicxMNFHq21XFF1TMECt+cUk13BanGMRh/Z8xUcbic6BBjH2?=
 =?us-ascii?Q?UbhR3+MXX5LWh1xtB1T77I5VXfBOp0eRQh8n2XHDgXzWWOl/hGAN7f9/nc1o?=
 =?us-ascii?Q?ZViHriXghF4/+YH/cwk1gAYaFcij0T8cnTDAAWtS8WtJTaB4+k6799Nj3XQg?=
 =?us-ascii?Q?p1jivxZRTCDxdkw2n2qBwLI6TOpsEhozv52DByJgtH5wSaAGNbM0QZTNLU7k?=
 =?us-ascii?Q?uX60xleTxP+JHkg+VdXtyGdPxNxwJl10FaB3C/NZfaIqDvoMhb78WvKGsh12?=
 =?us-ascii?Q?rX1w6W7ys1To0NdHeRynK7JWqaCqvP6zMaSmDnndiWHzAEzFTSPKQAFNANlE?=
 =?us-ascii?Q?kVh6zPC97AslZn63H4I5ik3eG7n1RIXnXxRkn/o5BNyMCg+gKzGdrKkO6jkO?=
 =?us-ascii?Q?RdotDpAMf82VEou/2AZUimjqZgG+m/hn5f354tFJiO9mB/9jW7H0vQszHjYv?=
 =?us-ascii?Q?CfmrUDJkecn12x70aun32xAHiGg+yKy0RY6kMKIpduAKJtFKUNvVo5y6onIy?=
 =?us-ascii?Q?FZ2IxBB9qf0CPzGZaAxxf6wsNjUhH8gWzcKFOP+t66xBOc1rwmeGSgGYUu0T?=
 =?us-ascii?Q?R9sdijQZ+gto0+l8ihszea7b4xYlmloulL6qaqETr75WMsyjpBcTWUO2Tjfe?=
 =?us-ascii?Q?6EdjCXRefFHo2upZxCVCYmWX1417QzwcwVyJtN/vh/U3uihfMmffF+hq0o4e?=
 =?us-ascii?Q?vGeLPE2ehsvLzbWeKTn++PyHUnN10S3dRPZ+/IsIph29r++qnYH1fx2uLRQL?=
 =?us-ascii?Q?kEVxlQh3R6oIWitYf+qYz7Rx5eKaq1Ie0YVi7jijYsKPQ9MvECqZJjn9jGJA?=
 =?us-ascii?Q?mmf0JzHhjtn332lAizE7XTvhHdSc50G4bDZ+kAYGvfHDyuvFtjaiGcdGUFW5?=
 =?us-ascii?Q?cGa/Us0v2ldv9a3umJwg+PXknOyGF/1ZlvjGp2/qtRfnuEI4JNLQz8aKozQq?=
 =?us-ascii?Q?FbuOe1CzsH18gdZ4LdIm3NmBjertqro1Er201vSUDmeQs/LUwhgHLBFtP4AZ?=
 =?us-ascii?Q?5UFb+6eoxKuNm2Ra/7UFWVTE3dinTGRXrycamEoBzH17RDfZ6v2qmovqAgJN?=
 =?us-ascii?Q?sj2DnGsqrAxZFiqLvmHu/40Fg/jPfrOQpvzPwPGvorAMXKAMsUUVZKzc4jTN?=
 =?us-ascii?Q?tNaG0RjAUgD6LPhGor0Ir5v2uKFr71JJDA5VpWHRJXtLl2rlz6Ds1iBFoScu?=
 =?us-ascii?Q?87H60SuUMycQaVaAXqD2KCfmWJ3QiqhXTw4leON2GzCIc77Gan3FNa8TIRW9?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25630c1f-c8e6-4946-6953-08db2f93285a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 13:48:48.8756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dI6pozNdmIWr5eZdZB5g6o8WjIPNwQFkjMZIJITPAERjfoFzyS2JI64oFxFeRxOuBJJ4DrEl8RCC2CT0WZA/sEl4jyat4lfNR3wFvMKSqH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7687
X-Proofpoint-GUID: I2AqNemTxWAglDGB68GgRSMRfB3HOVr9
X-Proofpoint-ORIG-GUID: I2AqNemTxWAglDGB68GgRSMRfB3HOVr9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280109
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

commit 75333d48f92256a0dec91dbf07835e804fc411c0 upstream.

Problem caused by source's vfsmount being unmounted but remains
on the delayed unmount list. This happens when nfs42_ssc_open()
return errors.

Fixed by removing nfsd4_interssc_connect(), leave the vfsmount
for the laundromat to unmount when idle time expires.

We don't need to call nfs_do_sb_deactive when nfs42_ssc_open
return errors since the file was not opened so nfs_server->active
was not incremented. Same as in nfsd4_copy, if we fail to
launch nfsd4_do_async_copy thread then there's no need to
call nfs_do_sb_deactive

Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Tested-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 fs/nfsd/nfs4proc.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 57af9c30eb48..b817d24d25a6 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1351,13 +1351,6 @@ nfsd4_interssc_connect(struct nl4_server *nss, struct svc_rqst *rqstp,
 	return status;
 }
 
-static void
-nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
-{
-	nfs_do_sb_deactive(ss_mnt->mnt_sb);
-	mntput(ss_mnt);
-}
-
 /*
  * Verify COPY destination stateid.
  *
@@ -1460,11 +1453,6 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
 {
 }
 
-static void
-nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
-{
-}
-
 static struct file *nfs42_ssc_open(struct vfsmount *ss_mnt,
 				   struct nfs_fh *src_fh,
 				   nfs4_stateid *stateid)
@@ -1622,14 +1610,14 @@ static int nfsd4_do_async_copy(void *data)
 		copy->nf_src = kzalloc(sizeof(struct nfsd_file), GFP_KERNEL);
 		if (!copy->nf_src) {
 			copy->nfserr = nfserr_serverfault;
-			nfsd4_interssc_disconnect(copy->ss_mnt);
+			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
 		copy->nf_src->nf_file = nfs42_ssc_open(copy->ss_mnt, &copy->c_fh,
 					      &copy->stateid);
 		if (IS_ERR(copy->nf_src->nf_file)) {
 			copy->nfserr = nfserr_offload_denied;
-			nfsd4_interssc_disconnect(copy->ss_mnt);
+			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
 	}
@@ -1714,8 +1702,10 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (async_copy)
 		cleanup_async_copy(async_copy);
 	status = nfserrno(-ENOMEM);
-	if (!copy->cp_intra)
-		nfsd4_interssc_disconnect(copy->ss_mnt);
+	/*
+	 * source's vfsmount of inter-copy will be unmounted
+	 * by the laundromat
+	 */
 	goto out;
 }
 
-- 
2.39.1

