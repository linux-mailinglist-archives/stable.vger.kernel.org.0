Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7F149AA14
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324068AbiAYDaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:22 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39744 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1315481AbiAYCxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 21:53:31 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OLK4bw001466;
        Tue, 25 Jan 2022 01:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=WI29y2OvchRzIhGkieylQupiNBTPhfQ/hqvLOJROggs=;
 b=C/WT9II+xJlJjnEsjRSn8akJ2YZElEX3lc8Vyskcj3qcqrf+5WhFBz7acv86WKYzQnR2
 cEMAZEIHvTdGXv8MM/hgHKHwEoXE+6OueaUkAnR/XStlGCvNypUZV3IhJ2OiytLjD4fm
 xQZlYWUKt2SH7f2gNbGcg5ZfGulNrAPdnr/WmNxaQX82KPMNo+MbKGUUlyyuDCAOU5UA
 KCdADQIcdgBpydbchtgmShaXEQbO3/GIP1tqcVv40SixQnciOS8NQTktZURWhwCAoLmS
 e8PhQC/xcl4USB091zU3KeFJnUqhxj0eigah+JlBuoe2BE2sI80cpqvH6kB8GmhlzSbT yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsy9s1d78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 01:18:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20P1BEwP165197;
        Tue, 25 Jan 2022 01:18:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3030.oracle.com with ESMTP id 3dr7yew1ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 01:18:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMcruJCZMMbB4TWu4Ig5+YPMEpaB/QyOVDdQ0XoGUhFKb1Dje1+wDCov8s7bJ6+SZQ2SoZyFfYjqQxSx/Cns3fWG3OaOCBbsboXGjyJJVvl92Z9IL3d0Pp/JY2imBJOI2R40posQtTnZpsNwQd9uBu0ugBeCn7G1p2UChq+/RfObH7FsOrSvXdvlNFtkRbulcsdYY0rFbxSqsAc/VLkgCZLoY9109XGUCeTV0bAq8LVkz8xu7WwlZDyk1I4ymlLjAnF+t3Dt3YmQRC6hVF07P5xHYuAxlTeQpSnroSU2c2MXq5Gx5DrGT8EfJXEM3UR+MLcFFG129rbsTwZjVTsYeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Awp7ElOCINOeZaGhHoenzAuGbblyvlZemcWjalzt88w=;
 b=PVifEdbD/unamZeIWJ1i8Qw5sMG+1m9u/TAdLjDZvcYjvoNcx6hYVrUkPtg+UGHX97QIJtsOlGhDn3B2Oqlh9drf8y4BR9VVv4PzhOoPy4OUtoP48I0hLh3EXqhM8IC1RirH7g0J5bT5AWhziSrWgwElpSPxhAL+AUagoKQ1pCitQxO6q5PrkEK24ITRnRomnHsHoZ5CmGxhdJqzPUjkiOZOblOyHCn3uK9Du0KFYymFUsa9bLnIzqtzLJ/bGR1hHENiZFR9BOoKGBLp+o+GQDXhUula48RWgUViHoagBMI87OuXBI/y2ZT7jj8LFQb27Zh51yy333H/2sXFpeQRNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Awp7ElOCINOeZaGhHoenzAuGbblyvlZemcWjalzt88w=;
 b=I9Ssrh8xxWeViv9lu4tRJCEeIleCTi66dtVjrefasnTJ720ift73+PqRfMxfcydXxrmA+JvxXSNQ4Y/zsJRJ4XOlLd/66l/NNfjSJ9e4p6yGwscKi4/IO6DffvN42TCm3o/kGrVSCsM9v1g+PfA65vWd4WBjEPdS7nFgsKbXuUk=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by DM6PR10MB2779.namprd10.prod.outlook.com (2603:10b6:5:63::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Tue, 25 Jan
 2022 01:18:09 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%9]) with mapi id 15.20.4909.012; Tue, 25 Jan 2022
 01:18:09 +0000
Date:   Mon, 24 Jan 2022 20:18:04 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     peterz@infradead.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] sched/fair: Fix fault in reweight_entity
Message-ID: <20220125011804.mhlhdenbjluzqkgf@oracle.com>
References: <20220120200139.118978-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220120200139.118978-1-tadeusz.struk@linaro.org>
X-ClientProxiedBy: BL0PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:207:3c::40) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d8d5712-2438-4cb9-ec13-08d9dfa08c0f
X-MS-TrafficTypeDiagnostic: DM6PR10MB2779:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2779B8FCC67B2EEFE154363FD95F9@DM6PR10MB2779.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ECdEWUTF5iBdQKmSKYw756G+okYaWDvswL2N2D0LCOX51rmLYKxnuWSpnHGM0PB4DhNjxxnkW5NRPXmqS3xBxOXpNWvg79b+w/5DNCW9wWD384UjJ9SYpldHVtPXtokqiBwlzqpFxybUcW2n8S8yZHEXnYbe5kvlBaHmT0Fc3vRh7kOxxUYd9xcxFYmV2H9j1/orJcmsZcHAGPovwlv5QUjAtga3Fl1vVZy4hc82z3xhQBlru+FYGhmf6tts908Pl2+OF700b7uy5gE35YBhCAtOCEWlNEZnUE5L4JweEmWhZRp5bwLTdpSfiwKA7/9JU0MWjHiFlMhooEihCBYgHZTEseM7PSrTVrtJxYX4oqkBstyF0FZb9vNYdteGHZEBFZDkW6VW58eIFIeWnsayWE0mfOpFXcxuaPukKRmR+aZzHv+CrLzsZh3LOvr1BrBnKiQMfHEFm85BKNwHYDxwo+X5gPjCCpgsDTxTlRxQt05QEP8hSi7RJQpRGKb0vDt/0a8v/BHz3pWyVURYwvt/FYx9nKFRYm8aN7bSErL1i9l/yUCxSwOHNHTM25UeepQ+dIJc5l1maZM+Iv0q3+96LNT3gK6LlxQcc0HVqKwKJ1VMjViSO85MmlQQ6W9GvWfE73scAXZrnGNdoc/9I/qFVRUwW0mFUofaZnwkZD/wgjekp0on6K9orWiWNyHiRTqbud/8ac8I0K0naJgsiKFwwl4ndOj+xUGkEEPlTgzTR8E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(86362001)(38350700002)(36756003)(316002)(6916009)(52116002)(186003)(83380400001)(66476007)(3716004)(1076003)(508600001)(38100700002)(6512007)(2616005)(6666004)(5660300002)(6506007)(7416002)(66946007)(6486002)(4326008)(8936002)(8676002)(54906003)(2906002)(66556008)(16393002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/z50L8JhBslSXeanrIZ2fv9HHhxEkIWsf1Nvxurr37WliN99QvphlYsqrK?=
 =?iso-8859-1?Q?1y3dzKZpo4M5vtE1hRpaIyIH3Bx3cLg1rxjOKBvXl9Cr4Ixjzi/qNUDgNF?=
 =?iso-8859-1?Q?Y1DtbJxaVqHEvjb1BPTJk0JitHbJ64dHbaKs0SUBOmn0m5JPvRUzKyIDxh?=
 =?iso-8859-1?Q?exV2fMQKrP1lVguaI2/Lem2o6sle0m56QTGNvp1TVkyo3cUQAY0E0NsYwo?=
 =?iso-8859-1?Q?lSXzwGynQExi45OFWa6r7gpW38q1IUaKORfrQ7Ct857B1wYaanSBInB9Me?=
 =?iso-8859-1?Q?O77Y0MEcUHRY9CZdDHKPVHWdyr9ApaL531FTlu7xMSCqh/6E+w9LWhFf5g?=
 =?iso-8859-1?Q?5gz2EXmRx4CsCi5Nb6kGC3DQXNyHwFsMnjGa0eRzMfAgfuZn8UqZCoj0B8?=
 =?iso-8859-1?Q?ixF2v/vJiFTgXjTRKMkE9gF5yB549H/Zz3trz0N1WpR4t8eHBDRnebgltj?=
 =?iso-8859-1?Q?4t3zp4qcItTCZLJ1A+M2uC/zwpNWEH2uxZygHB779fIzLLxTSSVuryLWY1?=
 =?iso-8859-1?Q?k62GUTUASiU6VSIEr54hO+UTlQf5pvIO2SxNJhn1tGy9ncKDLuvWkfEStJ?=
 =?iso-8859-1?Q?HEnLbOVl7aFhynShdXlb+zFnz90BBxM7RXvgIWplz3UL8qdGAEBhSBRjbV?=
 =?iso-8859-1?Q?lpBjZu2SfxT5bQtQ3he8DsRQfo7hp76Cd7v+iOMKLklLyQmb+JoOuMiqcU?=
 =?iso-8859-1?Q?cb3U7fgoFs3v4/qmw4x+QUoBkm7zVfAgnGo7hZW02hCgCYfWl3xbhVODfh?=
 =?iso-8859-1?Q?i+1bhxg4xs64xUaB6jEN56GBBEOq+06NmMwvpbaIUdDBFZT/bVlkau/ayP?=
 =?iso-8859-1?Q?V3faEDVLands5iGQOCcNC3aAfm29YxYZ1z1s0f2CuPTfnAO3JQIXT1MGp4?=
 =?iso-8859-1?Q?v6DK3/URWHF1GL5ZXnaQVxgf5N5ZXryUC2BmfDR807gpH3ceVhZzBpFfa0?=
 =?iso-8859-1?Q?SaXeTgfPqGe0XsFaeUp71sKHs1OceSp2KRi2EyGnx9SKYmEeclJaA5UHhK?=
 =?iso-8859-1?Q?d8f7TLKPJ9Z4PyoAogBKb0gmtGLqGAdFOvclfuv3L62XqGgR8HcFw6CzQ5?=
 =?iso-8859-1?Q?p9m7N3o9JHVRyNEOeLaydqQCPllcZKzpkJvRErynhSTF7v0YLG5q5cLqyb?=
 =?iso-8859-1?Q?fDuarJ1+6u0S4PBV9BmGs4j/ImXm4ndDOX3Akvu/nDqIcVmGVuzdOtENx/?=
 =?iso-8859-1?Q?ZDKWrw5so+bncnDPQaOx0ETjpoInZHDuf24LTezYoKRCfA1gDO5MQ4FkXn?=
 =?iso-8859-1?Q?0SaLMlLjLvj40e2h+VzC5DhlAznltcE0HdORRqpFr99jAxs+l6vlz3NM9z?=
 =?iso-8859-1?Q?3B9y3i9fJHW/XDmGjlhy2Esep+bdSknemGAFqsky7aE/VE4Y2Y3FU+BBLn?=
 =?iso-8859-1?Q?co4nesD9Dq+u49kxha/DG5oCTOIgUfn+/LXqvG1LjZtCqs2d5oUAxUhoTy?=
 =?iso-8859-1?Q?/qAZKvyNuH9/hVM+wW6ce8FKHVRUkqUbfl6eUSMYEufQTKJeek52bXK3Uj?=
 =?iso-8859-1?Q?8p0kQDjEXgYVeyClA9mImw8A3bSS5SpbqAIBjWpC5UEnoXGhVxMJ/s61DQ?=
 =?iso-8859-1?Q?pz2oWcr8feJGoShRoPa46fjA/8N0ZRDN+FlUzu7K+5xIwJHNP2ozpLuG1M?=
 =?iso-8859-1?Q?U0agVpUtLevU0IxmJqVAiI2ys0Id2q2i/FrcSwWpRwi4p9pOg0jOJ6x+ro?=
 =?iso-8859-1?Q?cFWqhX/FfWJ1AHdgXB0m3ZMoaBrXvmcOm1JUirOoputfO1eU9VTjjJR1FZ?=
 =?iso-8859-1?Q?oyIA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8d5712-2438-4cb9-ec13-08d9dfa08c0f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 01:18:09.1468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7JB6ClSFnCo35w3aXOLrfAENqkV8jww02CmNwWzwtO3RnaaRLDhrsIK/yObTboKZ5X5V8HsxAELwaHDKGNv54rIzKM3/EPMfje7RpA1l1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2779
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10237 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201250006
X-Proofpoint-GUID: M3kZtCoAxcvHTgHpW7WYcDWIRdRM9lbq
X-Proofpoint-ORIG-GUID: M3kZtCoAxcvHTgHpW7WYcDWIRdRM9lbq
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Jan 20, 2022 at 12:01:39PM -0800, Tadeusz Struk wrote:
> Syzbot found a GPF in reweight_entity(). This has been bisected to commit
> 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> 
> There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
> within a thread group that causes a null-ptr-deref in reweight_entity()
> in CFS. The scenario is that the main process spawns number of new
> threads, which then call setpriority(PRIO_PGRP, 0, prio), wait, and exit.
> For each of the new threads the copy_process() gets invoked, which adds
> the new task_struct to the group, and eventually calls sched_post_fork() for it.
> 
> In the above scenario there is a possibility that setpriority(PRIO_PGRP)
> and set_one_prio() will be called for a thread in the group that is just
> being created by copy_process(), and for which the sched_post_fork() has
> not been executed yet. This will trigger a null pointer dereference in
> reweight_entity(), as it will try to access the run queue pointer, which
> hasn't been set.

It's kinda strange that p->se.cfs_rq is NULLed in __sched_fork().
AFAICT, that lets set_task_rq_fair() distinguish between fork and other
paths per ad936d8658fd, but it's causing this problem now and it's not
the only way that set_task_rq_fair() could tell the difference.

We might be able to get rid of the NULL assignment instead of adding
code to detect it.  Maybe something like this, against today's mainline?
set_task_rq_fair() would rely on TASK_NEW instead of NULL.

Haven't thought it all the way through, so could be missing something.
Will think more

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 848eaa0efe0ea..9a5b264c5dc10 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4241,10 +4241,6 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq			= NULL;
-#endif
-
 #ifdef CONFIG_SCHEDSTATS
 	/* Even if schedstat is disabled, there should not be garbage */
 	memset(&p->stats, 0, sizeof(p->stats));
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5146163bfabb9..7aff3b603220d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3339,15 +3339,19 @@ static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
  * caller only guarantees p->pi_lock is held; no other assumptions,
  * including the state of rq->lock, should be made.
  */
-void set_task_rq_fair(struct sched_entity *se,
-		      struct cfs_rq *prev, struct cfs_rq *next)
+void set_task_rq_fair(struct task_struct *p, struct cfs_rq *next)
 {
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *prev = se->cfs_rq;
 	u64 p_last_update_time;
 	u64 n_last_update_time;
 
 	if (!sched_feat(ATTACH_AGE_LOAD))
 		return;
 
+	if (p->__state == TASK_NEW)
+		return;
+
 	/*
 	 * We are supposed to update the task to "current" time, then its up to
 	 * date and ready to go to new CPU/cfs_rq. But we have difficulty in
@@ -3355,7 +3359,7 @@ void set_task_rq_fair(struct sched_entity *se,
 	 * time. This will result in the wakee task is less decayed, but giving
 	 * the wakee more load sounds not bad.
 	 */
-	if (!(se->avg.last_update_time && prev))
+	if (!se->avg.last_update_time)
 		return;
 
 #ifndef CONFIG_64BIT
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index de53be9057390..a6f749f136ee1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -514,11 +514,10 @@ extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 extern int sched_group_set_idle(struct task_group *tg, long idle);
 
 #ifdef CONFIG_SMP
-extern void set_task_rq_fair(struct sched_entity *se,
-			     struct cfs_rq *prev, struct cfs_rq *next);
+extern void set_task_rq_fair(struct task_struct *p, struct cfs_rq *next);
 #else /* !CONFIG_SMP */
-static inline void set_task_rq_fair(struct sched_entity *se,
-			     struct cfs_rq *prev, struct cfs_rq *next) { }
+static inline void set_task_rq_fair(struct task_struct *p,
+				    struct cfs_rq *next) {}
 #endif /* CONFIG_SMP */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -1910,7 +1909,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	set_task_rq_fair(&p->se, p->se.cfs_rq, tg->cfs_rq[cpu]);
+	set_task_rq_fair(p, tg->cfs_rq[cpu]);
 	p->se.cfs_rq = tg->cfs_rq[cpu];
 	p->se.parent = tg->se[cpu];
 #endif
