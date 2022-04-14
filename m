Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39D65008AA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 10:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbiDNIsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 04:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240029AbiDNIrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 04:47:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251E31DA77
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 01:45:31 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8MH9p025116;
        Thu, 14 Apr 2022 01:45:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=BIAIvOKsRv1ld2PYR6SJILFEIltFxECahczWifg7W7A=;
 b=D5pST3VOkxe3nNM7z/xmQutV0WGfDBSnHqaMM4UsrgMWVaxYScXkFxW7SiMs/UFGl6Bx
 E/XCrXpPGfGfQ12z04Fn7eNhphJvm4TE1AepsqiVnxZrWV4k4SQGbJSwQV2MicOwU1rz
 +pGbcrMeOoTAnOHPbeXzg28VQ0DlrcPQt9Zckvfcm6decq7gDQnkJvVHtupQEbZ/njCe
 P/XEO0V2vp7xH/SMqelKmO+bA0/ghxf1lzM2YGy0zz3sO4tsy883K7u5lIXJQFX/tGE7
 dQvoQOhwmiN39TZBsBZnzlllAkaUykbdLNGQPCrluNB6NcXE48JN+bFy/P9dFUH4M9xr Xw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jeb4hw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 01:45:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsSLfCwLo6PKFAvY2dzTZTsuuTmS+MlmbDsaMhBiyJCw4V3MtllDbCMZWU0WfpaWcEVc6nE74l2+JEJ2MqFHi+a5tDTxv5WEOi2h/jnvfH+77oIIA+DNyipsUMafoXTKy95bL4Xg6fYZLbPPqhnkDEM+xZ+P3jcvMGRGeConj6k06Ebac5zIeg0xprztpZEvh8kwQkK0OxsLhuapejI2HS05BOCUNoY/xUhjHf19NOkHb6co3A8KNWT3OLKWNHcmwPkMaqf1lZ9qm5G5x5UNVVwrxx5VUFCrJcAz6HQOqJGyfK+x4xpLJhMaJmIzE88gnl3cCpsdJNs8HMDmF6+Sow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIAIvOKsRv1ld2PYR6SJILFEIltFxECahczWifg7W7A=;
 b=Jk2WR7ZCRxpJ/ms6I71TiM92ViMCMQPjSH07zKvYfRwkbz7XDjIxmdZM2ZKSatikF7Ca/Uy7fa0nBWaqpVgs+DIXfARRB/T2hfvWqkPinfqXL6sCSeCqw723WdJmyAvGAo6ik3IHWqbcPqe06tVfm1gA9j+vophG2UzEgz8ETKXd7CPZ9I1tVYS6vrVe6h7c7y8G8CRj/9slt9sk3LrfcGWwHEfggOflpziJjlFMsV0pwY7Hrg93YFcmVZjdrKBKV8hjUvFmJLoiqS+67rakJtUZIj2/MEoPNO1b3Hw47QNhgMj/hiL5qFjMJSaHx7sv+o7Q4mrQtFkExWsU0gijNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3435.namprd11.prod.outlook.com (2603:10b6:5:68::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 08:45:15 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 08:45:15 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.4 2/6] cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
Date:   Thu, 14 Apr 2022 11:44:46 +0300
Message-Id: <20220414084450.2728917-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
References: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:803:104::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8521f430-4c08-43e9-79b1-08da1df31847
X-MS-TrafficTypeDiagnostic: DM6PR11MB3435:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3435D512DC660750AF655C0FFEEF9@DM6PR11MB3435.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JfM197iVBxwhildcNBtTpX/+nbAW1cn8cOFr9Kf47ZBuPPe5wjpKhFsZTSYni9n0RbwtZUyjDarIreULwTYdup15kBL7QhAuxRiMUhmwEuJL8FIOy3OW/gnR2sylxJRzC68jnKmAyREOPT5zwlb9tbNhf6Hj2DtlT9t6CtuFwuFrKhhrOYC747YQOzsCDKXyzkk9OLcIg1DHp3dAHa3N1eZtgYwV+2RBObo1xCQ0Tar4N7zmMNKp1aR4HBC5qj1Fy3k/bPqBSc1FHuKYCkYuwSe2W4ElKZkMOBJhJZjGVhQdoVZhw4xP5tbdfZImgFGitdY8VuvgxU5jut/1Vxc7GbNhlWSCRm1/Vn2A+0Vf7YgSMII8tfODJhu9uE4RXr43clj80XImRC+JC7CvKLMK0q3ufrO5VK10HftW7DyCfCS4go2WVTPQ8v03EoVD8wOdQVTV4DMlLG6yunM43vxGPhkeOifMAuZdGj2z/E9b/Pyr7uy4vjael+gnDv0tcVj6QrMFQ1aNcojXj0MUKuMLMgjBADtGzKQ5uyIQWQThD24pL4eARCSzb4mBfRNpkVp32Mz93xDcQIiuuoDRK+wOdpmEubkjyIXWA8f7759GRJBSU+Df8oWd//bSwfgOz4OB8CR2MTn5zWTfKwmbfeMa1DIff9gzFpyaua0/MWOA3jsG9B9zpXsZjTHp8JsoimhEBlUw0soW038tMTZnU1KAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(6666004)(316002)(86362001)(1076003)(52116002)(6506007)(2616005)(38100700002)(38350700002)(66556008)(66476007)(5660300002)(66946007)(8676002)(4326008)(6486002)(44832011)(8936002)(36756003)(6512007)(83380400001)(508600001)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWRjSFprcVRWbGVWcldId2J2N1VrdDZCN203aGpLaHJEYzZ4SUl1QWdrVVlR?=
 =?utf-8?B?cFJDTVVqcUVkem5kaVZSaGI1TkRUbFR4WjJkOEZnVHdOVHVaQWpwcUp0clJh?=
 =?utf-8?B?bmtOSEFHdVc5aUV3U0ZkRUJCSXBGeDNML2VxbW1NY2hWMGV0Sjl5T3RBaW91?=
 =?utf-8?B?YmVPTmR2b3lsYWtQUzhxQVhMK0FqY0wxanF2QmpIaVIrU244bVpTV0JVaVdN?=
 =?utf-8?B?VVhISWUrTGNnb3lISjJWUGVkQUVxaUp6bDMzWFZwdVBsNmlNSWd5ZGNIUS94?=
 =?utf-8?B?TlBoWGNPc1JYZXhWTGNDRTBMbjZicDA2VjRwQ1NnVytWSjlPZFF2ZGpsR3pE?=
 =?utf-8?B?bnJDSldKS0xZMXpQQnZNMk9LN0V3RTRkdzVCSTgxb2NsdnNObmZpUXFZa212?=
 =?utf-8?B?dVhENEV6Zi9VcGUzNGY2OU5wUkYrb04yOHFSS3pKS1lFWklueEEwUWY0WHNX?=
 =?utf-8?B?a09LTFJXYXQ2cVF3d1hXVHh2cGsxOXQ2QWtFVGI3bW85TzNZTUF3bHNiOElI?=
 =?utf-8?B?MXdMWUF2azR3QXpqM3pBWmMwTmUzdnhNZmxVMjZJelIzOVVJQ0lWOVptOEVp?=
 =?utf-8?B?VjgrTXZ4elkvQ2RFZUNwOU1VSXA4YlRTc1prSEZBbEQzUDNFME9ydXl4WTBr?=
 =?utf-8?B?THQ5MFZNTXFveFBYcGhtYXlsTmJheWYyRHBKajl0S0tCWTg0WEpvc21vMEZE?=
 =?utf-8?B?WllKY1ZWSk1XdTIyT1ROOFArditRK243TER0ZDNWVXV6L0pIOHBWNXd3a0sr?=
 =?utf-8?B?SVdzNVdJRzRHcitBZksxMURWWTY1KzRlT09RNUlXdzVINUp5QXlmU2Q3TlVJ?=
 =?utf-8?B?d0hPQVp0V2xsUFBqTXhQd29XVHFiaHpqVjc5WFl6dXQzV3lFRTE2SGYwcjNU?=
 =?utf-8?B?eEM3SHNoWjYvUGszTzE2Yk44VFR3MXk3dFBlR2F6OVozMXNUOW5JTEVZQTNz?=
 =?utf-8?B?cTNLWVhLRnF6b080dnoxSVlPSUNyZ3pUZlZwcTV1YmpETkdaUFVaNE93WmtP?=
 =?utf-8?B?Z3RDaXB1bXJ6d1V5S3MvTXZtQnp3Y05SKzBPcUMrTE9mZVgrVVptYTZzSkw3?=
 =?utf-8?B?UDc5dDdFRStrM1FMQ3R5a0VUdVowbE5FTDdsaFI4bm1KRmZVK3pVWDRFTEtu?=
 =?utf-8?B?Ti9RWktoQnJkU0VXQW5ycmRDS2wxTVBFdms2WDRiWW1HbG1xbGV4NHQyTUVj?=
 =?utf-8?B?K2tsMWpWQmoxQTUvaWxqV1dmMnVvejVTOEg0eHRYeGFuZHV2UTFSV0tqQ1Jr?=
 =?utf-8?B?ZllMb0tXZWt5Y3poWUpoK09KUTFWamxuaFJqdTBLNkh2cWtsRnFZcEVndmR1?=
 =?utf-8?B?US9OUk9ndUQyS3JmN2l3N1I3MUhiMjltZG9ZRU01bHdWL1JmOUVNVDFZaWt2?=
 =?utf-8?B?amJFL1lNQU1Ib3lucm0yZXNxeEZlK3VhRkRqbDJmTG84V0drMmlwV25MeERV?=
 =?utf-8?B?bFlBVmJLSUM1QWFqZFRjTVZTazlWVkJaRUdyU0lZYnFabU1YU3FPeEFNSEpW?=
 =?utf-8?B?ZUE4TERsUThtek9XNzc1R2pTaGpLVjg1T29QVUJQc1JYM0tMUmZ1VitCNDBB?=
 =?utf-8?B?YUhJbW8rYkVQQzA5TFJDcURsbVZ4ekRQanlxY3BnWnU2OWdkRzFTZXAyNFlD?=
 =?utf-8?B?OERNK2lzNTc3WnF3am1qMFY1VjJpOGZ3cWwyWDdYSDl0WXFyalppajVsaTMv?=
 =?utf-8?B?WHcwM2VjTXd5SVlqdzBoRTRhbURNTVQ5bzdTb0JiQXRQbG52VnE4Z2tCNk5W?=
 =?utf-8?B?TGp1Y3hERDI4djUyeEoyS0ZzbmdhbEVvNWZNeEhTeGROU3h1MlJsZkdDbXRB?=
 =?utf-8?B?Z2pUVFBKL2JFRno5YkNOOGJsb1ExVWlFTXUxT3ZYd0x1a1FkTytBdHFrL214?=
 =?utf-8?B?cTh1UG90cnNsTTcvK3BqTW9qQUMzZGxnZ1hrdXJPaUR3cmdHL25pRWk2M25a?=
 =?utf-8?B?dVRnSDF6TDV3cnlIcE5rZ3hjdmoyeThPcmh0VUdqeklUZ09Kd294Q085c3Qz?=
 =?utf-8?B?NHF5MFJDelcxbThFK2hka1I2LzdUbFFUSjhNWGo3L0d5UUVOdVNOamNlNFhk?=
 =?utf-8?B?NlNPR2p4cmdidlpkTUljYnNqTzA3YUVEY1lLNjdiK1ZtTm9OTHlsZm1uS3lw?=
 =?utf-8?B?UGtMb2FUQVlYcFUyTm53VktmdWkrTkZSbnlCaEp6ZjN3VlBVR2Z5V2I2SFBq?=
 =?utf-8?B?c2NiZlB2WnM1MEZ6WFQ4KzNzYzRPTVhWSUk0TDFmQVp5RnN1d2VNNEFEUjlw?=
 =?utf-8?B?VnEyWEdrRFVRdnJJL0NuZ1lETEdkcDZIbnBRVVIrb3pRbnlZVXJ2U3hDeDhW?=
 =?utf-8?B?S0w3SFZMaUJuVmxreHFqdHoydzk1MkJlR2FBN0JFWGRzdy9NSm1EK1N0VXVi?=
 =?utf-8?Q?p6NDNIXPRV9A3siY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8521f430-4c08-43e9-79b1-08da1df31847
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 08:45:15.2798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VubOGLM1BcjnUcmib3KFrHNdKqD1tGmtTJj2O4o5Hj3z0X910HjcKnk+3SR/JOq/aXoTr2OAPmO64RK9W9kwNWmsERQy6Y5K1etIMc5E9Ok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3435
X-Proofpoint-ORIG-GUID: 5iwOqOwb7Bac9tfZFL0SRyob0Xav1WoE
X-Proofpoint-GUID: 5iwOqOwb7Bac9tfZFL0SRyob0Xav1WoE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140048
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
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-internal.h | 17 +++++++++++
 kernel/cgroup/cgroup-v1.c       | 26 ++++++++--------
 kernel/cgroup/cgroup.c          | 54 +++++++++++++++++++++------------
 3 files changed, 65 insertions(+), 32 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 809e34a3c017..f91a8ba168dd 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -65,6 +65,23 @@ static inline struct cgroup_fs_context *cgroup_fc2context(struct fs_context *fc)
 	return container_of(kfc, struct cgroup_fs_context, kfc);
 }
 
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
index 413b8bfc0ff5..117d70098cd4 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -398,6 +398,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	 * next pid to display, if any
 	 */
 	struct kernfs_open_file *of = s->private;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct cgroup_pidlist *l;
 	enum cgroup_filetype type = seq_cft(s)->private;
@@ -407,25 +408,24 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
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
@@ -453,7 +453,8 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 
 	if (l)
 		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
@@ -464,7 +465,8 @@ static void cgroup_pidlist_stop(struct seq_file *s, void *v)
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
index 8c5f7b346abb..c1eca24db373 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3648,6 +3648,7 @@ static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 					  size_t nbytes, enum psi_res res)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
 	struct psi_group *psi;
@@ -3660,7 +3661,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 	cgroup_kn_unlock(of->kn);
 
 	/* Allow only one trigger per file descriptor */
-	if (of->priv) {
+	if (ctx->psi.trigger) {
 		cgroup_put(cgrp);
 		return -EBUSY;
 	}
@@ -3672,7 +3673,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return PTR_ERR(new);
 	}
 
-	smp_store_release(&of->priv, new);
+	smp_store_release(&ctx->psi.trigger, new);
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3702,12 +3703,15 @@ static ssize_t cgroup_cpu_pressure_write(struct kernfs_open_file *of,
 static __poll_t cgroup_pressure_poll(struct kernfs_open_file *of,
 					  poll_table *pt)
 {
-	return psi_trigger_poll(&of->priv, of->file, pt);
+	struct cgroup_file_ctx *ctx = of->priv;
+	return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
 }
 
 static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
-	psi_trigger_destroy(of->priv);
+	struct cgroup_file_ctx *ctx = of->priv;
+
+	psi_trigger_destroy(ctx->psi.trigger);
 }
 #endif /* CONFIG_PSI */
 
@@ -3748,18 +3752,31 @@ static ssize_t cgroup_freeze_write(struct kernfs_open_file *of,
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
@@ -4687,21 +4704,21 @@ void css_task_iter_end(struct css_task_iter *it)
 
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
@@ -4709,21 +4726,18 @@ static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
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

