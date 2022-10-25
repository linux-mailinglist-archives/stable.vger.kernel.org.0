Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7C60CF57
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 16:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiJYOlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 10:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiJYOla (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 10:41:30 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C8B10EA3A
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 07:41:26 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 29PCwKAw022392;
        Tue, 25 Oct 2022 14:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=k3gzFERfwQqI1j7gmuQtL37bWesCMSn43alm37kIJGg=;
 b=mLYF3IDZgei3Z/RPe+rNEm7tsCbB5vQc23B1Skyiy5Rnyn2U4sWr39P1yXd+BUsDYj1I
 Mn9sQOneQ5W2sqWaEtZl8x4NZDGHlK53Ysdm+VQqVybKFEfcAXlSZPF9rrUV9y+0scOQ
 OHUzjeUn23SrX3+sMxBZjdL3nJbnC0WI65Dj0rF7xZFnampRKSvmOm62mIbBmhmnvvMV
 XGbSRiAiAyQ4R1ZMErJccmsVmxkxIRVDJo5g0Uh18vi+3zl6Zs61You7HTpQ0tKtwkoi
 Zx+A4nia3GaUfBg6uhy3pJL9Pf0drhs37aTzSxIuXoVNDddXZ++2gfzOC3JErWyBqU6v dQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kc7g9uc6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 14:41:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWlC/OZLJoQEWUtPbhw8S9OchshuSowUj0xS29JG7icJITLq06jaBQWSb91DJVkpIW6TlhFMcpUkmrfYSw9sIFMQooUZfPZjYaVWxwCln8bHxh/MZ/6mZbgBdMyD3s0xtHvj1AqTLeUUgcBlYx2GVOKbMtatJ8d38cPlA7ysPxGdcqHckwAlQ5zOHd5sKlFZzOLcTTWGcH/qRkAPQVN6YvjOIUnso8kmIjBJVamh9h58ynRxhuQLX9VkOXRDP02lmF6MeTRwwjRFHK879TW0CdmRVtvTRXQ3rlb0s05xND69xSXMG2JjccW1pXbEEW49gHbJugDdMTygxiWhCs+PpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3gzFERfwQqI1j7gmuQtL37bWesCMSn43alm37kIJGg=;
 b=Wgf4BLm3AV2IOGMvKY13OWC9FdkqTMFFw+n0JUxd4WLQZLqlOyz2Jpt/B6G9lkXwLJm4iV816XG1obu+NeDtSJ84Hx5KYbVFIUdvboTlCMPpo0qmVrKWJWbU7KiTf/epPb5eEmBkJycUcjTPrrCfRMLMFWYq07/P64H0ao4Or5du9smZKFSxdvkuQizyrYVu9aHb68GmgoHU3JbXCOnw6vq2WXaeHAc8oPPJj5Grlyg8dQycNn214TwHNpvnZHJ6H1fap1OhFSzAEQrQC2ECUyewK7jwhYDOXKQzKDbKEbH56fc5oUSUD+t3gtjUFV/GJpTa7G9ugi4nkqZbds0YQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CO1PR11MB4833.namprd11.prod.outlook.com (2603:10b6:303:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 14:41:20 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::a8e1:fa27:6954:d5cc]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::a8e1:fa27:6954:d5cc%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:41:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wenst@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/1] media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls
Date:   Tue, 25 Oct 2022 17:41:02 +0300
Message-Id: <20221025144102.226693-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0303.eurprd07.prod.outlook.com
 (2603:10a6:800:130::31) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|CO1PR11MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: a10bc8e5-b261-49c1-6129-08dab696fb30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zGwq12hA+9d0hyept6QqB1rA5qrKwt1A5zLM7tyMs2XbIJEeOMbjwDYIksvdhk5AJOVppc/3nhhUCZmf1s94xGGKlmgePF5S8jRLXz/EF3dPW/s6JlmMyrmCvlL4Vtw7n7uQAYHdkHXDzjXVM3PwTH7DbaaQwAmxK3wBsfPmzaMR9/Vw24/+SSZnY5JffjDsNAXjl3/8e21kJqIWyoXYGvT1Uz4PR9M1wVYplgPSnXXnfvJAuiwLsr6bnjlfDCa4F368NVohvZwq5lJwaLE11zjth48thWJubR6RSe8V0+JSd0nSD02TI/16SwQmhCinBdMazEmuFS1FvXFWYJshswm7VWFg0YysXfmvR0OQm767ia3HpMWyHmyrCPhPJlgVuTiiF9jKY5XS0aVZwEKxCP1dijRavfnpTCfLybMcg1Kznsuv1yG8TVjeDv5uks6EZX+uTFcQ0jcI4H6tw+eDPF59igKuvhh/7ClIgm4r+3BYYFzu6irpNVVKLlZAmq5NE5Ycu9dR9wcB7TfMfL/mEhKP1CLH9rDoLcrnL+pJL0zJghvRdXexrJIP8Qp6aKAOE7kRjXCuA3bghsm6zXxSCkON+6yJ70mJTRqfFwyuZPtdPisL0MnDTHeEcj1XudQvS8tPjulNQ72KFG6INex1rnb3Z6q30HnnqtvJ3X2s9tNpP8HcmSldqJNxlJJrFYssdFLBIG3fbzfig1rgpyCz9loAfsyybnr8zThaABrDAvUnrZA1U0b4VRKadnzubJC1WRF9G6a3qWUzSMpck3ztug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(346002)(396003)(39850400004)(451199015)(36756003)(6486002)(4326008)(1076003)(8676002)(41300700001)(86362001)(38350700002)(83380400001)(2616005)(44832011)(186003)(52116002)(478600001)(38100700002)(8936002)(2906002)(107886003)(6666004)(316002)(5660300002)(66946007)(26005)(6506007)(6512007)(6916009)(66556008)(54906003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m0diPhHt+9cC5ZT8FaKkk5u0r9BeoCGCyAo6gOY/DTlkdyWmc7MwGmARX0Zv?=
 =?us-ascii?Q?2JoKXWSGJ1DjZf3US6KgH9Cwo1V41u5JmaP1/8yypfo3b0Pab2rBug0Npi6a?=
 =?us-ascii?Q?4uPXp3kjf+OVE7rcws7Rnf7v5iAkEWHujkhdFSY85j51BjmRqTQPridl8893?=
 =?us-ascii?Q?WXutCmANqgEFfSnPiWNhgDOL50pukR8RQvQL05qpHAQ++DLGi+uWOceJ5Zdl?=
 =?us-ascii?Q?Vq4afb+7HFqAAogR+Z9HaZdNSctu4tu1u+ZzpSmU9uBnBXY701sMUX1gBmOJ?=
 =?us-ascii?Q?mq2VvakSFsWPoyYYpR/rXiyXL9rDCTLYJfIDIA33EqXGP4CEMET+0JDTbwL1?=
 =?us-ascii?Q?aXZC/kEq7D+CTkev7kMxwMJbXx2A3KZqRoh6w6qWnPXW7kn0h8trQfOtl4ae?=
 =?us-ascii?Q?3evYPQz73Urv7hpQmqCiAtXsKXJrykUcqV5HStVJSO0uKXKytimAeWDLtW5N?=
 =?us-ascii?Q?vkcFiSHSMDsWVNiTootV0qOH7qAqNfm5/3OuqRg5ahxpQRI7Fq9bBQbRy/i9?=
 =?us-ascii?Q?aldQA24DYej0YMnaNdr0qUFQ7/YSjgccsh1WikT9owp1OQRzpjrWpOnrIX2+?=
 =?us-ascii?Q?Cdv362a3VUdIKwr3rS2xpUJ2zU34BWztmPG0I74UuXVAqajl5KAtLiJhRjrg?=
 =?us-ascii?Q?oCsNgO/UkDCEFJM2BptGqw8G119G+Uk9x8IvGopWTAMFN8jONkXYhvKv/78Q?=
 =?us-ascii?Q?j+nHZ5mG5OPdSReNVu8pt1lwK0x/eT7aqKi3HAlaAJyFwax2D4HCWQ1QlhnV?=
 =?us-ascii?Q?phl43jjVXQy3K0jc57P3AR/c9hybd4J+RaIvfQvhTNVDYCjzMhEHTNqKdTm+?=
 =?us-ascii?Q?CwWPrsJbOfSKdf1IX604PoqhwiV+PZFY1vlMIaIXZTrKfaGJPBNTjV4EJrF1?=
 =?us-ascii?Q?H2i+bLeUNHqLmGWGZSL6AnIRQgPWHBJ1Gc7z1zOHqPIuJZLnWUgDfXDHxP0X?=
 =?us-ascii?Q?+a5e0XoZ59LdT44mwjZCBRyu3TjnvNANNKqGHNeZkwZz+mwCCZUxgu2O89W7?=
 =?us-ascii?Q?maS8VVL8uolgUfv93sRjzG7rIkZHF2xYh2X2b4Bdmctw448nmISafHYqbFY/?=
 =?us-ascii?Q?NJr3FvinnvUbCrw+pMbIlbYZO/X7w9OgGUCoc28mOJfAnG7rIuTEi8qG8KxR?=
 =?us-ascii?Q?vvrHiw2yEx6xeMfc1wRYNoY+Y+mdwfEnT8xiOibYQg+JG9Lol+KlpV6TNFdj?=
 =?us-ascii?Q?e3PnNDMh4d6DRpaDcyYlRt9jBsw8BRg3fOB2Fj/mO6DOsfV9ZF0cTsqEmC5T?=
 =?us-ascii?Q?xRLOyoWt2oy6808KNdHNXtyhQ4FIrE+6cdGuzkQfZzqyW8nfm+PliHfhGDuE?=
 =?us-ascii?Q?SdnPUlLhRvvoNt9Na9q0XBEaSHmwpTqQ1xwz3OII1qYEjErq9Fit1tiXxejG?=
 =?us-ascii?Q?Mn8eXYOgOXiusJ7LlahpPFlAZ0vY4QpTfs56V8nG3qRqR31j+7uYNhUi95Qg?=
 =?us-ascii?Q?fBhMn2/L4Za+b2TI0wh1olIz9LWFLSfSieWjP3dStjniTDL8tyv5c0iqNeW6?=
 =?us-ascii?Q?qYHkki76cIl8GeJxbd8A2jyaqqJnbMlzUuUH45DvPJGV6muN3Q7KKXaj8zZJ?=
 =?us-ascii?Q?QKez6ChaeTGxlvpEnBf7wGAEjGdOGxCJveHkuMHPFW02uAlQBUG4Dhy2bVHm?=
 =?us-ascii?Q?1w=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a10bc8e5-b261-49c1-6129-08dab696fb30
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:41:20.3978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7KB6J5ZdUPwznCoIfRfEv0Fsln86Vp8dy3xoV6onbnlZ6b7BzivMF3YQkMOlxwwXrOWMPc85O9XxHFW/kh7FhV1Ic9/lyQA7yvN2xdSToyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4833
X-Proofpoint-GUID: CuFu28-i8gqeWZH7FFgasnyqhptlxsxo
X-Proofpoint-ORIG-GUID: CuFu28-i8gqeWZH7FFgasnyqhptlxsxo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_07,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 mlxlogscore=934 spamscore=0 suspectscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250084
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

commit 8310ca94075e784bbb06593cd6c068ee6b6e4ca6 upstream.

DST_QUEUE_OFF_BASE is applied to offset/mem_offset on MMAP capture buffers
only for the VIDIOC_QUERYBUF ioctl, while the userspace fields (including
offset/mem_offset) are filled in for VIDIOC_{QUERY,PREPARE,Q,DQ}BUF
ioctls. This leads to differences in the values presented to userspace.
If userspace attempts to mmap the capture buffer directly using values
from DQBUF, it will fail.

Move the code that applies the magic offset into a helper, and call
that helper from all four ioctl entry points.

[hverkuil: drop unnecessary '= 0' in v4l2_m2m_querybuf() for ret]

Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framework for videobuf")
Fixes: 908a0d7c588e ("[media] v4l: mem2mem: port to videobuf2")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
[OP: adjusted return logic for 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 62 +++++++++++++++++++-------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index f62e68aa04c4..dcb869c588f2 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -358,19 +358,14 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 
-int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
-		      struct v4l2_buffer *buf)
+static void v4l2_m2m_adjust_mem_offset(struct vb2_queue *vq,
+				       struct v4l2_buffer *buf)
 {
-	struct vb2_queue *vq;
-	int ret = 0;
-	unsigned int i;
-
-	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_querybuf(vq, buf);
-
 	/* Adjust MMAP memory offsets for the CAPTURE queue */
 	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
 		if (V4L2_TYPE_IS_MULTIPLANAR(vq->type)) {
+			unsigned int i;
+
 			for (i = 0; i < buf->length; ++i)
 				buf->m.planes[i].m.mem_offset
 					+= DST_QUEUE_OFF_BASE;
@@ -378,8 +373,23 @@ int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			buf->m.offset += DST_QUEUE_OFF_BASE;
 		}
 	}
+}
 
-	return ret;
+int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_querybuf(vq, buf);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
 
@@ -391,10 +401,15 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_qbuf(vq, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
+	if (ret)
+		return ret;
 
-	return ret;
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 
@@ -402,9 +417,17 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf)
 {
 	struct vb2_queue *vq;
+	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	ret = vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
@@ -416,10 +439,15 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_prepare_buf(vq, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
+	if (ret)
+		return ret;
 
-	return ret;
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 
-- 
2.38.1

