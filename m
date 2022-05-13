Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0132D525F21
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 12:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346611AbiEMJjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 05:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379100AbiEMJjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 05:39:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4DC2A7697
        for <stable@vger.kernel.org>; Fri, 13 May 2022 02:39:11 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D995TX031470;
        Fri, 13 May 2022 09:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=hAlaZ1Ec3j09fxN+1irCKE9kEKdJiJKmKAtlmNxklJw=;
 b=sX5xQEYDKU1Fl9MkpoAah8fQHjF+/w3Fu8lpPcDvtjwjDw9WNlE94zZm61iVCsxCg5lC
 oRGk9DQCYvR00BiMtmA5gzoIkYb/Uag9tKtLgEEHDfzOBFlGqlVS3wQ2bX2PPNu0VFIr
 n1UX1WwLfWJG7oitwjorAq1MccGA5c/Rhif7r6LZImjiPF11H9lVDKVOCrgfYhlp68Cl
 Ei29a6/F63oBNFEdeW20gN5dWlaF+XfdmazFRrfxAmqXvTBc93D9XfKZwnwZL1jAObqk
 uuNExMAQud5UVcIql3rMIHuO/y8RA1U9quyhURqAG/3NqgxRpu5wHmgrmVo9bC5uIn5G QA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fwdyyvq41-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:39:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST7/gRoKWTZBMpnOy/bTdpv/TyoPH6gH+ADkm4LIvwh2gFuk5Dm99BcVSqkshTqlFRd+OI4gSOs62dPcnzLmNdfpofVTUxWHL1hHvBscyz4XUi7pAr3Ten4O6ff1LGv3v4JcvozZy/ZKXQKFFEwbGL1Mzd3+JWjq/WF6vybYXRg5E5pnjAE9kNilNTsgeOYcNMuw8FeNYO5tNwAY43bh0CSSjLYv1mMsGnkmYpmKN87brzzxh4XTCo1bqgRa6TO5Jky/Uts8+bYq4FwYPW9oHUW1Gb9rBeV5O4MjKJiL54EmgveLI1mEUQt6GxJs2mVtIJF0W6443tIR1xL6SLM1dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAlaZ1Ec3j09fxN+1irCKE9kEKdJiJKmKAtlmNxklJw=;
 b=AK4NZa4r+t0WOozriqvhArByrsoPFbkPhCK4AXgd8bW8MsMw3kqQNp3luZkEGf0bsp7I1G2/XiD8BCxJj4guJQbBFUeKHH2HUPyeCa6Xu+FbAsPFEnkt0ib4JfOQOxAofOSj2DLv3DeoxZgMoivcSSVdq8a2AB4FWx8Z711yilD2EEl1o7B/ar9xRRYG2VKhwoptuXkDH1sEog3exKnIuPJ2OcyH3u2RWHejnNv6gcGyYnF+aL9TuokvK4R0DIY/ungILt5ZWNHbeU6RWdm5G/Ie5ZnJ5eUfD6DKtafyKvbFEerddqKPq4CeHUqzafJMfgdKQIGM5uO8mjGocO+rRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 09:38:58 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 09:38:58 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Hu Jiahui <kirin.say@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/5] ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
Date:   Fri, 13 May 2022 12:38:28 +0300
Message-Id: <20220513093832.1434697-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0047.eurprd02.prod.outlook.com
 (2603:10a6:802:14::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ef3e6d7-1674-4594-e9a3-08da34c46763
X-MS-TrafficTypeDiagnostic: SA0PR11MB4527:EE_
X-Microsoft-Antispam-PRVS: <SA0PR11MB452747C266B4DB04690B6704FECA9@SA0PR11MB4527.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OQTrquKOh84U3meuxl3UDUtNQ8cSLQddhvi7zUVKdWWoIKMGQmqH/H7cP2N4/RtM4atCLkhyyBIoLgX9J3myay8V+b5+L34I7ggWM92g5WBEfm3bnMzH3j2j8qKdWi6Qp3gr2KhMqfBLfCCskQbOOD90mM74gj9l+58gNhBeGu3YSzxjveCGceUykEKaSTCNpp7mMmsqO9A4SLX1JFA3h4laUDLE8KU6AiKzQBYe4+kUjQzNkVPBAexv8cVq0dPJxsliYW3unsyEP6MxVZPCjTEWd/KVRCBDZhnNBSHFGUO8XlsjyEKYuRBo6M/El++co0XgmDeT6BLw0h1gAquPRFS/aLITmT9xfO94aS8ATsWi2m1IDRG1btbhjw3cBiiU8oNFh3eE7JqooUfsMxSJOwuT7TyQKIXj1ZZ79PXRBwjOHmTpIc4DY+wKPJFvnx3zxBM0WIUzNbYat3VUeGoENy5bM1rkTKUVmPVn4kEZ+44yGZCKcG5GxdfuAS6qpMAAuEApMVrCRfqSLfSYKx83Ba+Um5rKCFViMa4zGqaMuP2Jk5Mu4qDRJIkyqhYBaz16mBzK/TeIUZ2rZSQsOs6QuyyKmW+yY6TTq7GhwQj8VP0JZ1wUTbLPnXJI9BDkVhUpU7PgQmWOks8Y+U+yq7T2nFIk7hSo7Dwg0Y2jC+hNxGoqMO4RTJqYM/mk5Rz2LmbmIOK7i2kFIhHFl8VPAtsEGxsHJQgyKPiOOnZV0X6xoqAh3+VgGujW3bPlD4br1Ee576Y1QCXTzAHPmC1swJFvLxVbjQwUZU6Q0CADm5ts0U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38350700002)(316002)(66476007)(8676002)(4326008)(54906003)(6916009)(8936002)(66946007)(6512007)(26005)(1076003)(2616005)(107886003)(6506007)(52116002)(6486002)(508600001)(6666004)(186003)(966005)(86362001)(38100700002)(36756003)(5660300002)(44832011)(2906002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?phogzH6SQjtuk3iPpgx5uYF5++fakDBGvDptKZiLSVCzqQIHCLDA+JNd9x5i?=
 =?us-ascii?Q?kzJqfAlhVP5H57dN2lKDockcdKKpatp4E0wCCtxvloydQBlPRH4T8bay179q?=
 =?us-ascii?Q?EoERCDC6AxedPswmi5SIKNOxAfU9QXIPOehxwFsN8Ms+8DYCbqwtOUQrH/MS?=
 =?us-ascii?Q?bHb5Mh0ySyZbbBh1FrSaZZzj5Kki+cn33qKltFr0EfQPlu/oR+VHLdrFUQUg?=
 =?us-ascii?Q?HvV0MJLX1YAkkG9z/+r+6Cz3qpOIBEFp4qSkCcX4/QN8+ZIESp/7BFTvoj5R?=
 =?us-ascii?Q?GNg0WIMBpikyjenlJ7HQVhf2SBWpISLXyY1lALF7cx24p/F+Lwl+/72XR//q?=
 =?us-ascii?Q?qFLenUdDSgPCqIa10s5pzgkkYPLi6bRClYvaKaDWK9407jXkhoq3ojWaxU07?=
 =?us-ascii?Q?1Y2gI7OkUTyeYJWXAC8hs07hPocl3eNwKJ8i7drNG/LrS3PuMOCizJGurmwh?=
 =?us-ascii?Q?weAN0rzrYoPiVWkTpGe4ZxPGuT1IBEH1x6Uv9UQvlLKgS9XQ6h0jnAcg3O9v?=
 =?us-ascii?Q?BTYvqwwEqcp7GzRJD9LiBf7CxVnr3phnOJ+b9+uG10nPXqkwIPDAOAJhFf0A?=
 =?us-ascii?Q?da6hptDKa0xfhSd7F4IS6EKLbscroeYGirBowIcQRiUGfZ5qcJt/Ehwd1rGX?=
 =?us-ascii?Q?kQ/UdFGMdYxPM7X8w7VFTIq8eOzoac2Mo7DDAKTAIakJ8NLcV3DAQEs5LQkH?=
 =?us-ascii?Q?skt7wGgFimp6mL9HRvbHUJKly9YevjRsWmrcw0IA4k2epNjeLgf3FQDVrUjN?=
 =?us-ascii?Q?VArDiRq8rEmrjpqxkvyZ21W1jS8eLtMKtSgwh1xd2le0jJxaHA0yCQAPmPTY?=
 =?us-ascii?Q?Y67ocHUFBsIT2yjYwFjMSt7zgUcn8emFGteoibgcseLoHiCJMtaEIp5Jxd2H?=
 =?us-ascii?Q?3mCsvw7EqBNsXg98b5KftlueY7pkux26bknUU4ciwR+k+Ls0wQvUknKv7BGk?=
 =?us-ascii?Q?DILdyrIaKqh8WgUQ5Zt+gYirMIWhp7z+DRpagJB047S0C2Nk4yjCvFneqoXr?=
 =?us-ascii?Q?PMh55bBdaF1oIjqKoKt7iFxmwOmQ6lWihz+erc9c3zqQKhbuz4Cw1wswLybx?=
 =?us-ascii?Q?z2odUfeIBqCEa3GV14TlUDoWioU+ScZBnawYxQZVbxRnQ23te/RkKM3XJGcl?=
 =?us-ascii?Q?+hHkk25ZMRuWBKXKAzCXUMVA/DCwJc8tayfgCKDu3E0zmQuDWt0HPGmKLzaT?=
 =?us-ascii?Q?cEF8oCJrTQ+HnB7JaYaJrD9ocemuoqDrYig32cePUB2zhG0YSTgcChu+p2LQ?=
 =?us-ascii?Q?jLQvNGM5Hle1eP8Vwlhkh83DWRl+UpJl/h/TXrcHJhg9hpjLIVEmLfNU4k1v?=
 =?us-ascii?Q?g6yen1I1Ukh9qHx0OZOR9UBBRpFBNhpuoFgJYm2dKOd49iQBYpyUkoWgE1xx?=
 =?us-ascii?Q?rlBhraCzUyeArn8lcPtRfwAWkB4GlovTdRu4Vc/d0sD8AwExR9xhGWqRvUiP?=
 =?us-ascii?Q?bWnk4JMaVclW58c4HhXoEfI9JQUBljGvApluoDlaGNWmyaDmhyTjeNWENvDJ?=
 =?us-ascii?Q?W9S1pX44WRBiZXCrJeO1JSbICDzugFfEVs+NlBQanIMzIUqFo+wJwumfXDQg?=
 =?us-ascii?Q?f1HK4/Ro4VQ6xcYrxW2oLF7jZzT6Jy8S7+YnkNXC4cTs08YQHuiyXiid1PAm?=
 =?us-ascii?Q?D1qOhRyDjvsONYtqAXosJn3E+VyEN0I4GdqYAqei1Ggeg7IrT0cby/cM6Ddp?=
 =?us-ascii?Q?C9+MZBQ7diRkzZjoox5mekwfetQllUowJuqhsSqXv7vWjDlSx6wLEJ80BSSz?=
 =?us-ascii?Q?ACyfCKMc7muNS85UCrGWOTbPTzmzSaA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef3e6d7-1674-4594-e9a3-08da34c46763
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 09:38:58.1212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOCFTLBlmDffgGv6mRJoSLkFzsy/a81hOIHmtXIPGl4vJj8qvVqM8kYrrpVRiCdzJox7uVWNip5lECQseptWNF79y+QQ8j5RyZBy0SLPySs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-Proofpoint-GUID: iLkHpBGzyLboWLU-EtbvQ8JOo1Eq47Aa
X-Proofpoint-ORIG-GUID: iLkHpBGzyLboWLU-EtbvQ8JOo1Eq47Aa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=911 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130041
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 92ee3c60ec9fe64404dc035e7c41277d74aa26cb upstream.

Currently we have neither proper check nor protection against the
concurrent calls of PCM hw_params and hw_free ioctls, which may result
in a UAF.  Since the existing PCM stream lock can't be used for
protecting the whole ioctl operations, we need a new mutex to protect
those racy calls.

This patch introduced a new mutex, runtime->buffer_mutex, and applies
it to both hw_params and hw_free ioctl code paths.  Along with it, the
both functions are slightly modified (the mmap_count check is moved
into the state-check block) for code simplicity.

Reported-by: Hu Jiahui <kirin.say@gmail.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 4.14: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/sound/pcm.h     |  1 +
 sound/core/pcm.c        |  2 ++
 sound/core/pcm_native.c | 55 +++++++++++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 24febf9e177c..aff851485b4a 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -396,6 +396,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t sleep;	/* poll sleep */
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
+	struct mutex buffer_mutex;	/* protect for buffer changes */
 
 	/* -- private section -- */
 	void *private_data;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index a228bf933110..c62240d0f5b7 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1032,6 +1032,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 	init_waitqueue_head(&runtime->tsleep);
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+	mutex_init(&runtime->buffer_mutex);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
@@ -1063,6 +1064,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
 	substream->runtime = NULL;
 	if (substream->timer)
 		spin_unlock_irq(&substream->timer->lock);
+	mutex_destroy(&runtime->buffer_mutex);
 	kfree(runtime);
 	put_pid(substream->pid);
 	substream->pid = NULL;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c530d008fe01..b4ba16e31e5c 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -634,33 +634,40 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err, usecs;
+	int err = 0, usecs;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (!is_oss_stream(substream) &&
+		    atomic_read(&substream->mmap_count))
+			err = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		err = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-	if (!substream->oss.oss)
-#endif
-		if (atomic_read(&substream->mmap_count))
-			return -EBADFD;
+	if (err)
+		goto unlock;
 
 	params->rmask = ~0U;
 	err = snd_pcm_hw_refine(substream, params);
@@ -737,14 +744,19 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 	if ((usecs = period_to_usecs(runtime)) >= 0)
 		pm_qos_add_request(&substream->latency_pm_qos_req,
 				   PM_QOS_CPU_DMA_LATENCY, usecs);
-	return 0;
+	err = 0;
  _error:
-	/* hardware might be unusable from this time,
-	   so we force application to retry to set
-	   the correct hardware parameter settings */
-	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
-	if (substream->ops->hw_free != NULL)
-		substream->ops->hw_free(substream);
+	if (err) {
+		/* hardware might be unusable from this time,
+		 * so we force application to retry to set
+		 * the correct hardware parameter settings
+		 */
+		snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
+		if (substream->ops->hw_free != NULL)
+			substream->ops->hw_free(substream);
+	}
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return err;
 }
 
@@ -777,22 +789,27 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (atomic_read(&substream->mmap_count))
+			result = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		result = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-	if (atomic_read(&substream->mmap_count))
-		return -EBADFD;
+	if (result)
+		goto unlock;
 	if (substream->ops->hw_free)
 		result = substream->ops->hw_free(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return result;
 }
 
-- 
2.36.0

