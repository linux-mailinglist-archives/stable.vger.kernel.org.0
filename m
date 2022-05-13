Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1164525CC5
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 10:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353020AbiEMIBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356176AbiEMIBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:01:01 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF80417066
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:00:59 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D7mNvO001193;
        Fri, 13 May 2022 01:00:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=eQoweuhyfoCahwpXygv6rhorNqntwgo3zylxd6EIxmg=;
 b=TpkelA5PcOD3yQUT4c6/kM16jNW2S0r7ozQdkWfDjT3QAuJtvlFwlwedvemWkrb4EW50
 Vh5+BUSr3a45ksOlk/PGsTH4hu73uuQPJrYbZ9qTfkPdmzeyBtViArjrC8Q4Qub4TRU0
 VAFpodrfMEyKLBzwttToV0EvS4lbEBoemdHAPokmxnOmpqwbIBASH53f6Xt8gR24mS1g
 0eT2UOy7tIYJIklWRZc1GcALGeGu9Z0xCHenYtDJ8Kj8X1wgCHd/W2uoa4R/Kzvu7us1
 fwtlbtNBOBX1q9jWCtxiwh2/yVoO9JzCVeDQtWTqVbNTrQSKKXdvItJj7Ab0Y5vXrgXM 1Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fxde5kx1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 01:00:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSUvIzgYPyjxgQThw0OfEtOBWFk/9KNpS/9T8Rqz3y+fQ4XxnQ48otwsOQ68A1kvwWkZgq3KhAllUGZ05HucEWyFz6lZqCfTKU2EJOEsWL6/6UlmAYIrJ+Cr/v6X8rsBEgAYQ6av4cYlOyJqWZarmfZBA07JXeyup40GXWf+c6Rmg4A9u8s8tAFXX+4scKcxwRZFsohLhO/bG9sBHJfD8jc1Yp7/6ADRp+RXIIaFVdzWMtwvS24sPxiISZ7dKW9/D7iOLaGmHF1X6G5AYms605usaCILncdLmvTP1N8jCcO9FPLINEyi92lZektz0y5ndu+06zRkSAeFpyijAZg/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQoweuhyfoCahwpXygv6rhorNqntwgo3zylxd6EIxmg=;
 b=PnOpN7sTsmHj3bCMSVgfp/ybwcwbVEgv3FF3FKtcgO3Vjjt7ZPbpdBPsdy7/4x0ArNeYJp0Kg36kZdXLb/ZX4afi6715zuKS2hV/WNGQtEedT7sAzgalev63dP1/t7wnCrvI5/iAXhjDnFKYV7XkWi5wddBuR8OdwiXag31bH0m1tGYHLcMVpDoOJr03/TZ8DCgntCTazz3BYVam2uwk6L4T+J84VY7pThAiPegrH+5g0gT6f8ejxGraVUuqja+Zl3bHvq0xVCo/hlMdRXHkFxEKlz1rbCVm/8mR/jimN3UIcuO/yGuIqySNDBXlHteqjgwqD5NXmROnPqvaCRErrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BYAPR11MB3175.namprd11.prod.outlook.com (2603:10b6:a03:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 08:00:44 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 08:00:44 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+6e5c88838328e99c7e1c@syzkaller.appspotmail.com,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 5/5] ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock
Date:   Fri, 13 May 2022 11:00:18 +0300
Message-Id: <20220513080018.1302825-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
References: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0104.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::33) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32781517-1a47-471b-f652-08da34b6ae8c
X-MS-TrafficTypeDiagnostic: BYAPR11MB3175:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB317571657CC56B9D524B136DFECA9@BYAPR11MB3175.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awUM89dW1bJqJaGCLzDj3Pf6I73Tt2aEXIgSCAWpydkNU5qr+SFlgriJhQo6CxD2Z2LjOUoC5AKDteEDGWJhIEbTXmenm/9rGgkpm30Xn0xWbEc1WotREFIj3HADeq6rDn0LDXxdniN3PHBHRCbvfNRpL0oHmQ6TWLmPsatBAipB3Txb0P+dzedTa5+YB39P6dcFWtCVx0s9VOpIfUpt06Bj7Z0lGT5ip9YWXZydvPDZ5oJXsRktJib6hE2/3Ga6ZkZ56ODt/huOdvb8Vj5ubHlbfp+KNq26HzBxcrA/4wcA4PWRmxKaiDrnrYMZCFQ/hvV1KqZBswJ4sBEo1Cx5U+HTPTCvXYNblXdOI6GkaexIQEFlZGQSJ4j9fiB+9p7nR/MU3w0i5s6W/4ACo9jxhQ89avCpixwsFwMzYaz6yixCT2xsm+KaHjE1ACzl5HttS1ej2+8IpL9P7RaMpddn2iiNwVeqCjaX6VowlZxFvsQEvuuUU2FnGJm4jlAJGvXcZBep9Qc+FvOEvtcRh8vYUAO+jfPozaSA92LFrUx1FrJtvwZfpzjLfthXFfl9MT9vhRhMOEDfQv2/3+m3NuGZFz2boeAKyQld13ZqOBSfWQ+8wrSRH8Bpa0+z55HhYtrH/P9DvYLbpt8IVT+k40OtFPrRZJWp9a7mX2h/qUubF8UJufc6LKCt+p07q6JS1YqcRiWELxpM4Nh+iC7wBn7DcLqoZ3JkvnJcN5qL6GRfCZBvo2JttNqAh3uCwIjT4Pl+zBoCHQ6l1k5Q8xkiWwQkA86aoAEkjAvJB2M2uZhQiTO3TWhhUikz5WKs8z8xejTBJW9p+XdyluhB2UUDF2tLpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(54906003)(2906002)(4326008)(83380400001)(8936002)(44832011)(5660300002)(66476007)(6916009)(66556008)(8676002)(316002)(36756003)(26005)(6512007)(6506007)(86362001)(2616005)(6486002)(966005)(508600001)(107886003)(186003)(1076003)(52116002)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rj1vjSLBakC7GBKS3hRtvjiTfOq1oJVaIZeH2ZOm5rIwz3o/ng0kidVu76U0?=
 =?us-ascii?Q?cbMuVNNeLRgFKlAMWuICClQ7uRacwCjY6lo13h3Kup6RZfHbmIUDwNy4V0zy?=
 =?us-ascii?Q?i11vZ9HlrI5HrTHNHQfY9FNBNLabs8pZzNFRWtcMhYNjQr+7r+UanGT7txML?=
 =?us-ascii?Q?sxksahqSdxNdDPgBhuTMVntgWkBhfNXKyrg+BjWW9AQsXHXuSdi4hoyk9ksE?=
 =?us-ascii?Q?wT1wkP3u5p9Oali9wsXWdSj1RjsO3xjtS4aLFbC+HrHLo3theVnS+mDtdkGK?=
 =?us-ascii?Q?XtxxLSvMoG0HrF0+St3apaZ4yuB00lTCDujYs7U/WVs+Puj0/2RCp998k4qR?=
 =?us-ascii?Q?BnWtMik46UHRA6E5InlZ+DHZKmoymnEpIlY2s51YTSGH4Ylvnt7O8MkRmxvg?=
 =?us-ascii?Q?/WjJE6vp4ljxZxeTnbeRjNMKQvmISZXeNMCx4rpV/0kB2gN12gQpKOkY/VU0?=
 =?us-ascii?Q?Kk07vmYyB+NsVg08LbdGzGsOGX8b0BO3XZGQuv5YiTHOra9OO+Uv8wiCJz+d?=
 =?us-ascii?Q?ZgK++pUyF5KuBHCv1nOe+AIQpk9gItx12DoAIdtqSFXhl5gT23zJ3X6MwZcm?=
 =?us-ascii?Q?hrDvNS2iQxFVLvsn8oHSF2gZSEu6zC5r/WVcmo2MImKkIlKsi2rL1bPS4XYU?=
 =?us-ascii?Q?NJokwtp7FYv5WOjUq0iT5B7YoKj1+c7qTVfaDI4MLUQ9U0djfwk4SSzHPlG6?=
 =?us-ascii?Q?wXanx/opuYhUJrSu6d0GJPVlku6HWZ35ZkIO6dMmrBr4bAzMVEPsqImfVyis?=
 =?us-ascii?Q?EALjMB7Bcg5KnRobV8QXQCRCmxfpdifEg2N2Di4jjbiS/enaRgPw6fJrdTh2?=
 =?us-ascii?Q?LDcZiklwMAY6fIzf45tJqqca6udIhDCUWH2+g0LAuY587c4QU7LyM/bQtOMy?=
 =?us-ascii?Q?3JCJtpSDmTza0eOtB1imGlEsm4J6p5durs8FxhULmHWCb/v/Hqz3A4id116r?=
 =?us-ascii?Q?mKcxInPykyQB27psgku82CYhJqzdxjYpK69TC5nS7QZx/8a34ooqo1xo4zqx?=
 =?us-ascii?Q?RiK2E1LNuZz+t1xZL3s0gk05q9htNSExBWxGcjR3oZM+yBQCtoNm7J5s/jaR?=
 =?us-ascii?Q?sAcbxXV6yVVbpl35qd0RfLlEs5vwIMshPkVVLlGxv9ppm6bblymg6ZR4lW+Q?=
 =?us-ascii?Q?hDWEWW0WktdzzQ6sTvSMAyaXEm/inMspdMYu4Gimw22pB+JQNx1oLZZhaoxg?=
 =?us-ascii?Q?ma45jwyJGkr7IIUZIjb6uQHUr25gAzi1+X27T1U7HIa6VkxbOaOuH1fl3fBL?=
 =?us-ascii?Q?Uf+otP20rWNh9sP+iiZKZaTAowDIc2Wzwooett8SldkpX7eIduKbmw4GWrP8?=
 =?us-ascii?Q?eBJSlmXsszx712vsqeuwQVD8rd2dZDNN7QjN2lNyuJB55+GJ16fSbioxM8Fs?=
 =?us-ascii?Q?ar/xeinQR0JEN8aWFO0l3HOMFU2PbSrBsX47XsSLjBHg+WiX/p+x6nHKOfOi?=
 =?us-ascii?Q?oF3h49T5Jeg/I02EHG8he06rKp603p6hS/NRVKzHKYUDBHdqjBGSEGDMsDUS?=
 =?us-ascii?Q?AFUutTjyy2K/VX/TzzM00bi4bts6HbGCQPGeFfz94afHzxOJgGduvjg+ApF4?=
 =?us-ascii?Q?HgqnYuW/tcnlQ9zCxL9kn+k3TXNJrsbRQVKQiUdNCUdjP5qIohjM1rk9ve8A?=
 =?us-ascii?Q?hj0y3g4Yqw9JQV1S5LWsj0g0yoer8N0UnuT7jUWcHvoL/XQ5PIfw+r/3Qs9h?=
 =?us-ascii?Q?pB/b58cy86dCHk5XORG5F675AoGJJj6bUqsEr/Vw+cd/tHsnqokCfh+MF+Ag?=
 =?us-ascii?Q?fNy9dkqh8dYxYH/LfIXoAaCLken2yAU=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32781517-1a47-471b-f652-08da34b6ae8c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 08:00:44.5230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvVkzvdQeWHpO7YFlM2MeaQeA2sHhfLLSdcTCdqdQqhu7XNOPZSnnfwnLF/HOW+dmJ99lOP4R2pmK1k9r9rjb86KJkJ//D11mqfQhdUf1DI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3175
X-Proofpoint-GUID: QnYHl454yRyVFsmUv9YpBYsXHSVCKVMv
X-Proofpoint-ORIG-GUID: QnYHl454yRyVFsmUv9YpBYsXHSVCKVMv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_03,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 malwarescore=0 clxscore=1011 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130034
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

commit bc55cfd5718c7c23e5524582e9fa70b4d10f2433 upstream.

syzbot caught a potential deadlock between the PCM
runtime->buffer_mutex and the mm->mmap_lock.  It was brought by the
recent fix to cover the racy read/write and other ioctls, and in that
commit, I overlooked a (hopefully only) corner case that may take the
revert lock, namely, the OSS mmap.  The OSS mmap operation
exceptionally allows to re-configure the parameters inside the OSS
mmap syscall, where mm->mmap_mutex is already held.  Meanwhile, the
copy_from/to_user calls at read/write operations also take the
mm->mmap_lock internally, hence it may lead to a AB/BA deadlock.

A similar problem was already seen in the past and we fixed it with a
refcount (in commit b248371628aa).  The former fix covered only the
call paths with OSS read/write and OSS ioctls, while we need to cover
the concurrent access via both ALSA and OSS APIs now.

This patch addresses the problem above by replacing the buffer_mutex
lock in the read/write operations with a refcount similar as we've
used for OSS.  The new field, runtime->buffer_accessing, keeps the
number of concurrent read/write operations.  Unlike the former
buffer_mutex protection, this protects only around the
copy_from/to_user() calls; the other codes are basically protected by
the PCM stream lock.  The refcount can be a negative, meaning blocked
by the ioctls.  If a negative value is seen, the read/write aborts
with -EBUSY.  In the ioctl side, OTOH, they check this refcount, too,
and set to a negative value for blocking unless it's already being
accessed.

Reported-by: syzbot+6e5c88838328e99c7e1c@syzkaller.appspotmail.com
Fixes: dca947d4d26d ("ALSA: pcm: Fix races among concurrent read/write and buffer changes")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000381a0d05db622a81@google.com
Link: https://lore.kernel.org/r/20220330120903.4738-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 4.19: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/sound/pcm.h     |  1 +
 sound/core/pcm.c        |  1 +
 sound/core/pcm_lib.c    |  9 +++++----
 sound/core/pcm_native.c | 39 ++++++++++++++++++++++++++++++++-------
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 0871e16cd04b..cd7874535a4b 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -405,6 +405,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
 	struct mutex buffer_mutex;	/* protect for buffer changes */
+	atomic_t buffer_accessing;	/* >0: in r/w operation, <0: blocked */
 
 	/* -- private section -- */
 	void *private_data;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index a11365dc5349..8eed6244b832 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1032,6 +1032,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
 	mutex_init(&runtime->buffer_mutex);
+	atomic_set(&runtime->buffer_accessing, 0);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 552c642ee53a..c376471cf760 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1876,11 +1876,9 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
-		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
-		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2174,7 +2172,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
-	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2224,10 +2221,15 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 			snd_pcm_stream_unlock_irq(substream);
 			return -EINVAL;
 		}
+		if (!atomic_inc_unless_negative(&runtime->buffer_accessing)) {
+			err = -EBUSY;
+			goto _end_unlock;
+		}
 		snd_pcm_stream_unlock_irq(substream);
 		err = writer(substream, appl_ofs, data, offset, frames,
 			     transfer);
 		snd_pcm_stream_lock_irq(substream);
+		atomic_dec(&runtime->buffer_accessing);
 		if (err < 0)
 			goto _end_unlock;
 		err = pcm_accessible_state(runtime);
@@ -2257,7 +2259,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
-	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index f2508f1f13a3..9862b60bfa06 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -666,6 +666,24 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
 	return 0;
 }
 
+/* acquire buffer_mutex; if it's in r/w operation, return -EBUSY, otherwise
+ * block the further r/w operations
+ */
+static int snd_pcm_buffer_access_lock(struct snd_pcm_runtime *runtime)
+{
+	if (!atomic_dec_unless_positive(&runtime->buffer_accessing))
+		return -EBUSY;
+	mutex_lock(&runtime->buffer_mutex);
+	return 0; /* keep buffer_mutex, unlocked by below */
+}
+
+/* release buffer_mutex and clear r/w access flag */
+static void snd_pcm_buffer_access_unlock(struct snd_pcm_runtime *runtime)
+{
+	mutex_unlock(&runtime->buffer_mutex);
+	atomic_inc(&runtime->buffer_accessing);
+}
+
 #if IS_ENABLED(CONFIG_SND_PCM_OSS)
 #define is_oss_stream(substream)	((substream)->oss.oss)
 #else
@@ -676,14 +694,16 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err = 0, usecs;
+	int err, usecs;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	mutex_lock(&runtime->buffer_mutex);
+	err = snd_pcm_buffer_access_lock(runtime);
+	if (err < 0)
+		return err;
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
@@ -788,7 +808,7 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			substream->ops->hw_free(substream);
 	}
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return err;
 }
 
@@ -821,7 +841,9 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	mutex_lock(&runtime->buffer_mutex);
+	result = snd_pcm_buffer_access_lock(runtime);
+	if (result < 0)
+		return result;
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
@@ -841,7 +863,7 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return result;
 }
 
@@ -1208,12 +1230,15 @@ static int snd_pcm_action_nonatomic(const struct action_ops *ops,
 	int res;
 
 	down_read(&snd_pcm_link_rwsem);
-	mutex_lock(&substream->runtime->buffer_mutex);
+	res = snd_pcm_buffer_access_lock(substream->runtime);
+	if (res < 0)
+		goto unlock;
 	if (snd_pcm_stream_linked(substream))
 		res = snd_pcm_action_group(ops, substream, state, 0);
 	else
 		res = snd_pcm_action_single(ops, substream, state);
-	mutex_unlock(&substream->runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(substream->runtime);
+ unlock:
 	up_read(&snd_pcm_link_rwsem);
 	return res;
 }
-- 
2.36.0

