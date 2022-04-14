Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A5650094B
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241226AbiDNJJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiDNJJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:09:54 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C986F6D949
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:07:29 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E97PdY018335;
        Thu, 14 Apr 2022 02:07:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=TI3dW0nRzzHZDnRDfxOInZ32a4ck4ejd3EYV/k4ZEdE=;
 b=GeqFdnRgBvDIlT7iTk+m1m0waQH6/UJLhB6pMK4w1EUgYM4LUJtQYMY2fpootNdzxzWF
 Nn2ejIf/1L9hg5ixmDjHngs7ko3xBdqlEERn8iAFdFzSIVViXZ/qT51uV6nhnXJ6SQLD
 UrijPm3LGxVxj0l150MikDbuLRoG4q+J0v9dGsvvUJxp04xYpkKkkNyBJ1tELiEJKDD2
 2O0tJxen3NDA8314g5x4/N3lQ8NgBtmY/lwltE/EvSmlA2EGf4k2zQpgK0q8W/5V+JeN
 P5zpyn2OcHDJUjJ1T3DwskOQ31z3vTIHgoJgWJCahKCV2JW8ILYEuIGrPBdfInXlngfh /g== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfurth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 02:07:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/Hby7fzo0CoF6b7DMqxVNgVtcxtwoDVn2rPTHo5aQizRo+TMX0ESsRXtGOoGFWrXpupCL0WCnLLn5pXy5AmZE3ivb2Ecn3To8P0kyk7/OeIU0/DPpqSq+1CtLtyLm65/zRLoWIXLSA2RefNqfNhBkVMyfjHKEwBT0Qsl8m1ygVsj9IBmNxti/5qGUcIvHJSCB49HbF6Y6vo2KyU+wr2/kXbw/62Qb6MiNqD9e6hLdotW7xy0AEbkwG7V9maUR7lpeHS2Sj7qmQ0cnVw9Us0VrR+P45nT0d7NfcZS7yVH40SJoK6BlslqJeXJW9sLQG5e7R/QV8hhLI2PfaiwdCQxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI3dW0nRzzHZDnRDfxOInZ32a4ck4ejd3EYV/k4ZEdE=;
 b=eWq4NNQohCssx0WXE/0OtcugNcHO25GfyCSvUkQ2oaHpylGa82AMjnLEHsFfvcgCnzBubidcZV6oBYbbHAZbBhQzyuxjs5x92kiSSpErU+BWlc7vkc+qdLhHcx+UCtSM7LWnPNYERlO8yeAdLVv/3gUbU892Gv5guMy9pCIgpaf8lU67zwqWwmZ4mljaUZQgZEyy8+ZO/xgzUMcEFmmRmhx4RPsupo5SKdnpIl2JffjQ+1rIupVb8XnPl22jFCTusnQ88BrGA3DCEAOvuoDlD6uE4YXdKXosYJpOBOCtkZ9v59JFX03tucwcU5ou4f6Yr2xNU8nUkOpMkrn+7u6ZYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BY5PR11MB4356.namprd11.prod.outlook.com (2603:10b6:a03:1bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 09:07:23 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:07:22 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.19 2/6] cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
Date:   Thu, 14 Apr 2022 12:06:56 +0300
Message-Id: <20220414090700.2729576-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
References: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0263.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fb9ff72-999d-4f01-7d9c-08da1df62fb4
X-MS-TrafficTypeDiagnostic: BY5PR11MB4356:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4356623FFCD29D1B88FBE258FEEF9@BY5PR11MB4356.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPKZ0JTOwy+zipQQvB6kdMDYNcLT6fkQmoexBoZ1vaQAWUMUTcCQUM/LA8PzDCqiUkjIzQ9IP2nGrEKv55Xt30Fxm60vDnB941yUt5xd8pid12CpKOE1U2aVxZthWU0Nqg30Kqo2kVG4TyAWePALjUlQnAfOA2sizJ6XCKzv9k6r+lh8CqBBB3PB9GJlzpS8q6/egFUbmR8bRdubHyR+jRLl2dA8G4hrkESdkqzn3hymEJllq6ozbeFPSOsw33rb0nQbExQKoC7dbxXTyDxFfocVtYxOUlp/w+ezW8SvBHzPjQZN6l8wgR2HvfzF/f/4ruajhJ78dXR0SDI0NTr6/rfkPUiGQvgQjIQqftHeKUSDYWG2pavpn1vPKS8IK/fXm8VFZE11dl9rYxQP8W4BpAfz1aGWp8JYQLbSBiTLnaEkOkQBzeDrh6CeRZdbTZ+5mle12fZ6rXmHWoFI+Yg6bJelMdOAcGLmXO49nDEyFLsVdMLm5MyeI4ZC66Skt62L/HlfLWAkou7wnO9Dz4cj6ILSl0P/F6dEyxkpgy+7kL/F6ba1dqOsnTN4Kj3GRn2SDstpNMr93noHdfP5V12Nc37hKoZ47rUkBvRme6Yqao6KpgVBSi0Fa9uCiNquwlseNHj7vR8JxpIyak/qem/0C9lZbVfwTAuH7pobSuA6kTsQynHTM+WQET9Tb13YLw+aetimJp/mbNeje1uXmZBDGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(5660300002)(52116002)(1076003)(186003)(8936002)(6666004)(26005)(36756003)(2616005)(6506007)(6512007)(508600001)(44832011)(316002)(2906002)(6486002)(66556008)(66946007)(66476007)(38350700002)(38100700002)(8676002)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czhnYzU2N0M4L2I1OEpKTy9GS1c0akV4WUl1Y2l1aDZodlVaWFhtWFlFNk9S?=
 =?utf-8?B?MzlBOXBRdXNyNUhNd1BSb3BBTnNvVTdDOHRNK0xhYzJKNFQwc1FCbjA5OGtG?=
 =?utf-8?B?SnRPTm5XNjQ0aWw5TDRoK1p2RE91c3YyZ1ZCaXplMkx1aVppQW5nL2ZhOTVG?=
 =?utf-8?B?aFRQMzhPSEx6ZE9TS0gwMjhKYlYxTnJTai9QblBPTlQ0VUMyVnFaR243ZllN?=
 =?utf-8?B?YzBSZXR3QnljRm1PQWhtVlpWUndwTFNadG5yNERiaWxQSHZ6bGp1ZE5iWkRj?=
 =?utf-8?B?NGk5L2llQmY0TVBJc0FYUlc4U2pKQURIeUpDZ1FCSGdvUnpLb1JxcFdFT2Mw?=
 =?utf-8?B?UEVSN2Mva1VYMGxSU3VVZXJpM3drVDRiRzFobzk4ckMyemtyWTI1Nng3S2h3?=
 =?utf-8?B?cGZPNVZKSXdKaHF3bFVxUHN1dnhSUmFiWnBsY0tRQWJCQUxiT3VmWmdqdDQz?=
 =?utf-8?B?dTZpR0lpcGdVayswODk4VC9EV2p6TWpUWHdDbHcrblVuNlJVTmNySnJpeVEy?=
 =?utf-8?B?NG9wMVZIR2VBVW1rV1RYVG1GQkwxRHdQemtwVGs2MkNVaWZGSnM3MXdDd0lF?=
 =?utf-8?B?eTNCSGVKS3BzbDhFNW1CTUlOODZKaXJtNVJPYWJmVkorb3ZVMVpsRzdtRHVE?=
 =?utf-8?B?MWlnVEFFa0oyY1k3aEhRL09lVHh5eDdHV1MxMjRmY2JLTE1idnl3UGdpVkRh?=
 =?utf-8?B?dFlUbFNhWnltcld4eC9ueVdHVXdXUml6Vm5zLzZOOVhPUFRnd2ExeFViWStD?=
 =?utf-8?B?NWdVUHFaZEdEVTllM2F3UTRlNU9ERTlRSVp5djBoNFV1bW5oZy93eVg4bzFC?=
 =?utf-8?B?eExrelhxYUQ0L204TkpxaHlZMllhUzdlbkludUFwY1d0bmVKVVpXWWtORE9C?=
 =?utf-8?B?VHRiTWd2ZktWZVAyUEkvejYvL1NraWJSRC9talFZVjZ1Qk52WGx0Mm9uN3hT?=
 =?utf-8?B?TXNYZEg0aSt3cEd4WXFSd0FnUEFtbVZZcloyM3ZpTStaVlNtTHE2THlrUEpQ?=
 =?utf-8?B?K0JhUDdqRG9HMHkxY0E0RnpvNDlYTlVHOG5Vdy9QSUhKeU0wOWdzc2twNmZU?=
 =?utf-8?B?UHBKdW0xQ0hmcXU2R2tlZ2lqbGtoZzRwdWJUOHBtOXlUQUlybVFyT1NsZnBC?=
 =?utf-8?B?eU14WnFlOUhmVWcwNHR2blFWYVhtRzJOZnl5YXdMd2VIQjhyVTVFYU5WWVRq?=
 =?utf-8?B?aTZNL3A2SUMvV3lLWUJIWmNPQ2gvd2xIcDU0ejNoQ2doVGVjTnJrY0NUbVE0?=
 =?utf-8?B?T0pMdDE0Y2Y0OVF5VUFLQ3JFbjBVNDZKTTVibWc3cnBya2VrOWFXMFZNMklJ?=
 =?utf-8?B?ZTVZaXNtN01YODNuRExkYnRWL2JCNzhlYzFETk40MTk3NVdXWFRPS2dTUG5Z?=
 =?utf-8?B?MGE0SFczRHhyaVFLUE5iTVRYWWJUS1BzamhvTmtGY25RWEpOVlptR2N5ejB1?=
 =?utf-8?B?WUg3VmJiSkxMeTAvOWJpWDlGWXRvOU9oZC9oSTFEZlBna3VwZFNjVWQ2dWZo?=
 =?utf-8?B?UnN3cDVSS2JOWlZvZWg3Wm9BOW9RTzFNTThMMko2Qk14aWYwbjk4MUExelll?=
 =?utf-8?B?TmNYaVFXWnluZ2xNblVvZkxqQTIwTUJoaVg5d2FQWCs3aUd6MHFicVJGazdK?=
 =?utf-8?B?czFCYUsvaGhJZXVSQ1pneWx2Qy9HOFROWkRzNC9kVUZqZDI0dlA5ckZKOGFR?=
 =?utf-8?B?Rllabi83ZGh0cUw0MFBBR2o2SnlYU0xXV2VHNjNyUkpzL2tFL3V4Y1ZWR1RM?=
 =?utf-8?B?NTlqVjd3aGlORXp6cko5M0F4eDV6WGI2RmIrWjFBRE1Uamo5aU90cTZGQ3oy?=
 =?utf-8?B?akhORnVnRWRqVFBYcldTdzcwTzlKUUc2MVVCQjA4dEdzTHREMmZmdWJRbVdz?=
 =?utf-8?B?amFxVytiRGswSXk3c29IaHZOZ3BzMGVOSnZjbmtQRFNlVlhlL0V2ZmJuamxV?=
 =?utf-8?B?QzVDU25XTUIrQ1VLbVNUOENiQkNpMEkyd1dZQUZLaGpDWDJtY2xxZC81OXVQ?=
 =?utf-8?B?MU5uRGtvbVoxTURSSDBmZDlIOHoyaE15UEIwa2R2KzE2amFnQ0Z1RnlINUR3?=
 =?utf-8?B?N1p4MG50L1BvUE43TkFseS9nRnRhRWFZdmw5aXVCME00WXVibEhSV29xWFcz?=
 =?utf-8?B?dGo1aGd6RU5QUVZldXZXWW1wVm5JOWxJdWlUdk0xRzVvUS9KUUlMWlR4SG1H?=
 =?utf-8?B?c0x2aFFZVzBya3JSSlBURWp4bTRBVVIyOC9KVVhkQThuMzZzVW1kNEJZcDFM?=
 =?utf-8?B?SE85aTliR1V5clBrTXBJOVNndHUyMzFMODluNmpNemJVWFNiWEtYTzU0dW1Z?=
 =?utf-8?B?dVFydkY4YkEzZ0lVNDBTWGozNERhUEVmUGJUckY1eXJiY1A3MDI5M21sNHR3?=
 =?utf-8?Q?zCaFmkuvsSq6SroE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb9ff72-999d-4f01-7d9c-08da1df62fb4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:07:22.8364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mjbmt0i6WO8Kv184IkGGQpzxEs+oRaiD46oDvRFtQG55qrbvy7duVvgdU5FneLiLbw4jf/uXfDrD4yKOtbUcqENwiB/byBuA5WY505dUuiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4356
X-Proofpoint-ORIG-GUID: INCf5GnBwc8ZNyWWs9QmfdcQWp4DuT8u
X-Proofpoint-GUID: INCf5GnBwc8ZNyWWs9QmfdcQWp4DuT8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140051
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 0d2b5955b36250a9428c832664f2079cbf723bec upstream.

of->priv is currently used by each interface file implementation to store
private information. This patch collects the current two private data usages
into struct cgroup_file_ctx which is allocated and freed by the common path.
This allows generic private data which applies to multiple files, which will
be used to in the following patch.

Note that cgroup_procs iterator is now embedded as procs.iter in the new
cgroup_file_ctx so that it doesn't need to be allocated and freed
separately.

v2: union dropped from cgroup_file_ctx and the procs iterator is embedded in
    cgroup_file_ctx as suggested by Linus.

v3: Michal pointed out that cgroup1's procs pidlist uses of->priv too.
    Converted. Didn't change to embedded allocation as cgroup1 pidlists get
    stored for caching.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
[mkoutny: v5.10: modify cgroup.pressure handlers, adjust context]
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to v4.19: drop changes to cgroup_pressure_*() functions]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-internal.h | 17 +++++++++++++
 kernel/cgroup/cgroup-v1.c       | 26 ++++++++++----------
 kernel/cgroup/cgroup.c          | 42 ++++++++++++++++++++-------------
 3 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 75568fcf2180..7ce7bd4b5fa0 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -34,6 +34,23 @@ extern char trace_cgroup_path[TRACE_CGROUP_PATH_LEN];
 		}							\
 	} while (0)
 
+struct cgroup_pidlist;
+
+struct cgroup_file_ctx {
+	struct {
+		void			*trigger;
+	} psi;
+
+	struct {
+		bool			started;
+		struct css_task_iter	iter;
+	} procs;
+
+	struct {
+		struct cgroup_pidlist	*pidlist;
+	} procs1;
+};
+
 /*
  * A cgroup can be associated with multiple css_sets as different tasks may
  * belong to different cgroups on different hierarchies.  In the other
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 7fb6b3ad75ce..61644976225a 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -426,6 +426,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	 * next pid to display, if any
 	 */
 	struct kernfs_open_file *of = s->private;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct cgroup_pidlist *l;
 	enum cgroup_filetype type = seq_cft(s)->private;
@@ -435,25 +436,24 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	mutex_lock(&cgrp->pidlist_mutex);
 
 	/*
-	 * !NULL @of->priv indicates that this isn't the first start()
-	 * after open.  If the matching pidlist is around, we can use that.
-	 * Look for it.  Note that @of->priv can't be used directly.  It
-	 * could already have been destroyed.
+	 * !NULL @ctx->procs1.pidlist indicates that this isn't the first
+	 * start() after open. If the matching pidlist is around, we can use
+	 * that. Look for it. Note that @ctx->procs1.pidlist can't be used
+	 * directly. It could already have been destroyed.
 	 */
-	if (of->priv)
-		of->priv = cgroup_pidlist_find(cgrp, type);
+	if (ctx->procs1.pidlist)
+		ctx->procs1.pidlist = cgroup_pidlist_find(cgrp, type);
 
 	/*
 	 * Either this is the first start() after open or the matching
 	 * pidlist has been destroyed inbetween.  Create a new one.
 	 */
-	if (!of->priv) {
-		ret = pidlist_array_load(cgrp, type,
-					 (struct cgroup_pidlist **)&of->priv);
+	if (!ctx->procs1.pidlist) {
+		ret = pidlist_array_load(cgrp, type, &ctx->procs1.pidlist);
 		if (ret)
 			return ERR_PTR(ret);
 	}
-	l = of->priv;
+	l = ctx->procs1.pidlist;
 
 	if (pid) {
 		int end = l->length;
@@ -481,7 +481,8 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 
 	if (l)
 		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
@@ -492,7 +493,8 @@ static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 	pid_t *p = v;
 	pid_t *end = l->list + l->length;
 	/*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1bac7c56f648..b2ace9339595 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3451,18 +3451,31 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
+	struct cgroup_file_ctx *ctx;
+	int ret;
 
-	if (cft->open)
-		return cft->open(of);
-	return 0;
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	of->priv = ctx;
+
+	if (!cft->open)
+		return 0;
+
+	ret = cft->open(of);
+	if (ret)
+		kfree(ctx);
+	return ret;
 }
 
 static void cgroup_file_release(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
 
 	if (cft->release)
 		cft->release(of);
+	kfree(ctx);
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
@@ -4376,21 +4389,21 @@ void css_task_iter_end(struct css_task_iter *it)
 
 static void cgroup_procs_release(struct kernfs_open_file *of)
 {
-	if (of->priv) {
-		css_task_iter_end(of->priv);
-		kfree(of->priv);
-	}
+	struct cgroup_file_ctx *ctx = of->priv;
+
+	if (ctx->procs.started)
+		css_task_iter_end(&ctx->procs.iter);
 }
 
 static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
-	struct css_task_iter *it = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
 
 	if (pos)
 		(*pos)++;
 
-	return css_task_iter_next(it);
+	return css_task_iter_next(&ctx->procs.iter);
 }
 
 static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
@@ -4398,21 +4411,18 @@ static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
 {
 	struct kernfs_open_file *of = s->private;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
-	struct css_task_iter *it = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct css_task_iter *it = &ctx->procs.iter;
 
 	/*
 	 * When a seq_file is seeked, it's always traversed sequentially
 	 * from position 0, so we can simply keep iterating on !0 *pos.
 	 */
-	if (!it) {
+	if (!ctx->procs.started) {
 		if (WARN_ON_ONCE((*pos)))
 			return ERR_PTR(-EINVAL);
-
-		it = kzalloc(sizeof(*it), GFP_KERNEL);
-		if (!it)
-			return ERR_PTR(-ENOMEM);
-		of->priv = it;
 		css_task_iter_start(&cgrp->self, iter_flags, it);
+		ctx->procs.started = true;
 	} else if (!(*pos)) {
 		css_task_iter_end(it);
 		css_task_iter_start(&cgrp->self, iter_flags, it);
-- 
2.25.1

