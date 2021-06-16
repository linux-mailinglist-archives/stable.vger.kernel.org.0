Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8F83A9B24
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 14:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhFPMyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 08:54:43 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:64284 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232421AbhFPMym (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 08:54:42 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GCp90s013292;
        Wed, 16 Jun 2021 12:52:32 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by mx0a-0064b401.pphosted.com with ESMTP id 3970drgngc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 12:52:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGvHnzRpotxUPdLokTkTNiU/LEjnoSj37Hy+4IqxvP9BC3Owd6TXhH/tgAtJk+EQBSJWpA4MkvpjpdnPb/LS3J3Id8jnJRWbSCSQ6jI8c/l1YljXfRGFlf5WFTKdKAnPCprrUuRSzcfHKyFl1JDByRmGWFYzgZYr1JX1lH5omqFIUfeTFPgoRw1fGWnxQH82Jf2iOUNYuahQxBo/HhGGRs7R4jpCdnRKyqEYVqJwJ1yRqzUWmXNcBzO8WD7sQlr/4pmaUTCxXdFP0yAA0tc4gJd8Pvv8YFgIry62F99hv9/apSPzIWbk2xauLa+IgdI0TGvCuSENXSjYlXc1s+s/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqh9XlF7nA9T5POQEJ+2jE24qs2nVP5D6ZdsXxaFmjA=;
 b=F+R9hIcDtqTZ5H6n+7c0uni++6GmwU5XWsxi5DK0OBYHz+htPc8BO0AYI04PiplohxpPpKxORNSGwQ6qQ14TvmzIkDU/ngNMQGTWHjYeWptOLcg4ceAusRPgmCRk590FOhZU5wzYTJ2mBaXY3XTVnKHdIBkhAJ4EBSDljnEluWTeAwQXinHYBxwW0jYYfq8dTgaURHXBYc6edchCUb0aGMR2Qixsl/eM30fhIu+k/snHZ08bHJUMG9ok719l2PGQq5d9Mu1ttIvS2+fc1g6u/A3xmu3jTEHOkeb0l63uzFxm+95kyqd3hVcdCrjRwBcuOYn9farelMM2jHdWOoPLtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqh9XlF7nA9T5POQEJ+2jE24qs2nVP5D6ZdsXxaFmjA=;
 b=E8pk3fBBfKcMd92egK4dJFIeXlfYWLHdOn0R6eAWoM+oDUH8VqKc78S+QVLkuV7Qq6kQdMfUIuOWEPdc9MCOPujNV9L3SH2D6FAp9VVJ//7oTbEOktyPl80yi/5TJ5avhkWNbCcKHXNgXjnFF7SiyRHxtOHfQNLPwfKBYlH2YgI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14)
 by DM5PR11MB1626.namprd11.prod.outlook.com (2603:10b6:4:9::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.22; Wed, 16 Jun 2021 12:52:29 +0000
Received: from DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::1caa:f0c2:b584:4aea]) by DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::1caa:f0c2:b584:4aea%3]) with mapi id 15.20.4219.021; Wed, 16 Jun 2021
 12:52:29 +0000
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     linux-kernel@vger.kernel.org
Cc:     cgroups@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: [PATCH] cgroup1: fix leaked context root causing sporadic NULL deref in LTP
Date:   Wed, 16 Jun 2021 08:51:57 -0400
Message-Id: <20210616125157.438837-1-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.29.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.252.2]
X-ClientProxiedBy: YT1PR01CA0147.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::26) To DM6PR11MB4545.namprd11.prod.outlook.com
 (2603:10b6:5:2ae::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yow-cube1.wrs.com (128.224.252.2) by YT1PR01CA0147.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 12:52:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eb4e000-8367-4cc5-f9fc-08d930c59945
X-MS-TrafficTypeDiagnostic: DM5PR11MB1626:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR11MB162661276EE22E356D54B0A9830F9@DM5PR11MB1626.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+qwOLDO6s8jWBbpRzYTTygamX4f+atnB9JL8Y12JZCnkIeh2O8FxNygjkTqISVn7RwKg1d7GKHBpertdgNszWyC4HcqCW/FVIaTTjpp3XHX1cQ9pw1foIfNMrQmibJLg86E3uvfgo2BL8NbxruKBEBPW+bc1E6nakAzikR2o6z1EDxoD5I6FKTs8BeKLbUc66bNxNMAv4f3Mt45lEwTI+aDIuS/SPsfJxeR54A7ufc52yOu0/7dbs9zezu8nlE51iVc0RmmNonIIBwAXD4SKgWctnrXq0SP4q7UL6jfoOoDOTWQt0QtVd7JKFm79Cj+Ei0Y9wnS3yaVoDZPYGNibDj06Nfkf7TiRuDwh7KfQhKn8D3C0ttt8WRgI9f3MHddpEkKroPHfGZvME3/oCtFaOU/X3qW43PeBhQ+TpIZsJQkQIhR+3go6yRr0xt2KXDhmYcgsEuzZp7/mNyZsuq7JVhypiArnqWS745QnYveUamkTqxVA4GscPotkqUXLlAbkeVlClhEB1opP+emeL8JRW4zGuvNUjCKZZtJ3vkghwxJrkv7Q4fJ8NhN7bk3gKh8pVfRxhjIKLPJJyTmyCKW8iHGQsFDpBZn7G4fBa03KQafoPU7BY6zI0MTS/+mDKjWYxK/QCYtDNPgZnUyigP+Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4545.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(16526019)(6666004)(66946007)(2616005)(316002)(956004)(186003)(66476007)(66556008)(5660300002)(2906002)(86362001)(6486002)(54906003)(6916009)(8676002)(6512007)(8936002)(6506007)(44832011)(26005)(1076003)(52116002)(83380400001)(478600001)(36756003)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azN2bnZucWZUc2xUSG9sVlVxQWovcUZ5L2pITjNidVB0K1pCNU5YK1E1Z28v?=
 =?utf-8?B?K3J2N3pIa3ErdkVic2wzb3dRYjYydUpHYjVvdmhWWFdNWTk3M2VrbUo2VU81?=
 =?utf-8?B?a3ppVzAzdUtjay9LRkNSSXdaRGF0aHRwNFVrQkdTMnJVZ252ZlVBblZLNXdx?=
 =?utf-8?B?eEs3ZVB5dElkL2RpbVdPVmhsVEdyOWRubHBraDZtRDEwKzYycWJ1eGJNV2lw?=
 =?utf-8?B?blVMQTN6UzN3bVp5NE9DOGdJOCtzbTFkeWpkQ0tDbDZRYXR5ZVZabjVjeUFJ?=
 =?utf-8?B?aUxYQzg4dGVOQlRPVUVlYWRuR3p5YnMreWo3UUtTK1A5bUxQc1dXMnA4Sk5I?=
 =?utf-8?B?c1NzYjNwTUJrQmRWUTdNK3RMUDdMMUpuR2tkNlQ0QkhYcWFPdDBidnJDNzZv?=
 =?utf-8?B?dmpENC85bFhCUWNQUStXendrc2pZR0twVzdSM3dpL2dNM3FUaUx0VmcxQ1ds?=
 =?utf-8?B?dHdFUnNUaFJndXM2bVFJK1hwOVZFbXBvczVtdHJvNVBjVEE2aUxJOGVrNmN3?=
 =?utf-8?B?bkN2aUcyVFNJbzVPTFR5U2FJZldjRXBFZ0d2djlMRHpGdjNqYWlxSEpZM1Uv?=
 =?utf-8?B?d0VuemVyUWxwc21mcXNrOVp1QlN1U2kxM3pkaXlqcGFzUDVqL2JSYTc1TFBs?=
 =?utf-8?B?NmlVTGtSVld3aGVic0VuS3E2aURwS1VvbmZPblN4TWJ1eSsvL1FtVTFvNFRW?=
 =?utf-8?B?eGNNUldxVXZXSkxhdTA5a0JLWDQ0T3JBQVNmcWcvMmJ3V2tYOHp3TGVtaHVn?=
 =?utf-8?B?MlZLL0s1bFB4dGYzbFM2SktueGN1TTYxVXduU25LMDJwMkVHZmovc3Z1WW8w?=
 =?utf-8?B?SWE5ZTdCWHAzTHRLSFpDM3ovVmhUYkw2UVo4T3RYWFhsWW1TQ3pvQnVibktH?=
 =?utf-8?B?WVRidnpqS1h0YStlbmFEc2NJdGJBQjkzUGFzRlVGU0lsM0x0S2NDNVJranZG?=
 =?utf-8?B?YXFUcmxrWngzQk43a0tlY0NLcC9tQ1grdjN1MW1wamlHVHdmMFY2cWtlcFVM?=
 =?utf-8?B?ajVLQ3hOOGZXRlB1OHlUN1hQSlpXV0xVOEhZMyswWU1WNzV3MG1jR0RFZjJh?=
 =?utf-8?B?TEkvUlU4UjgrNVhOUWx3L1FyY21ITzlBWmNvcmlRVG40SHBzREx4cm9lOVRi?=
 =?utf-8?B?ZGlnUVluNHlCaUUrL1ZxRGR6NklJcGxrdWQ3eDRsdlFMSVZJVHc1YW1VMWlF?=
 =?utf-8?B?aUJhUlJ5WmhLdGpVMXVtdWRoSndIemxWTGF5QmVFaWRxaWdqODFWeVY1Ukx4?=
 =?utf-8?B?MUs2c20xWXloOE5mOHJpSlIxMXpXZlBlcm9SOFhCWUlOSmJHTG1JeTZtcndk?=
 =?utf-8?B?cXpZUC9tTVVwcVhLbGdkdmxNeHJjN3d3aXN4VDVNMW5waUFjalIybGFjNlhG?=
 =?utf-8?B?VVlzdzRtc29tQ0JXSUwxWVZyejNMRk5CbG9HMXRrWms1bFZwbnZSanlleG1K?=
 =?utf-8?B?c0NmQ2ZrZE5mRGdKNTJlTXo2NCs0dTZHY1dERlBUQ2F5L1V4M1VOQ2V3bC9Q?=
 =?utf-8?B?RTJ0RlIrTHRUNG9mbXZhVkhMZENpTnV2cVhoMEFDWmp3VXJ5dGg5U0ZGMWhU?=
 =?utf-8?B?N0NGTTAySVZmc0FEanJBdkU5TGJtNkVZV0JSM09PRElnQ3llaWRKcDd3Y29n?=
 =?utf-8?B?eFNRdHlHZGpJVWxvTktaaXVwWjBDcFJXZWtXWWRKOTlkd3NUcTh2eXdqS21z?=
 =?utf-8?B?TEMwTDNNY09qTG5heDIrL2VhdFQ0dW9TelIvNEptT3JGWU5aa2Y2NlF6ZG0x?=
 =?utf-8?Q?wKqlrCBit6kKmK5DfjLkLDvRzd5B3yUdpiLH53L?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb4e000-8367-4cc5-f9fc-08d930c59945
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4545.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 12:52:28.9459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfYXA3Ll1LC7dUy1BilVgehDbeSiwkvV8SFUcMtyI6h6xafYkL5ZfEeix3vjfxvgFcI4pdq1GVkid0oSKfUpFPIVmHn/VFCA59xrvi2rMjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1626
X-Proofpoint-GUID: qSImb66KdSvy5Cwh2eGiW2DnLek4_6lV
X-Proofpoint-ORIG-GUID: qSImb66KdSvy5Cwh2eGiW2DnLek4_6lV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-16_07:2021-06-15,2021-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 clxscore=1011 impostorscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106160074
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Richard reported sporadic (roughly one in 10 or so) null dereferences and
other strange behaviour for a set of automated LTP tests.  Things like:

   BUG: kernel NULL pointer dereference, address: 0000000000000008
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 0 P4D 0
   Oops: 0000 [#1] PREEMPT SMP PTI
   CPU: 0 PID: 1516 Comm: umount Not tainted 5.10.0-yocto-standard #1
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
   RIP: 0010:kernfs_sop_show_path+0x1b/0x60

...or these others:

   RIP: 0010:do_mkdirat+0x6a/0xf0
   RIP: 0010:d_alloc_parallel+0x98/0x510
   RIP: 0010:do_readlinkat+0x86/0x120

There were other less common instances of some kind of a general scribble
but the common theme was mount and cgroup and a dubious dentry triggering
the NULL dereference.  I was only able to reproduce it under qemu by
replicating Richard's setup as closely as possible - I never did get it
to happen on bare metal, even while keeping everything else the same.

In commit 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
we see this as a part of the overall change:

   --------------
           struct cgroup_subsys *ss;
   -       struct dentry *dentry;

   [...]

   -       dentry = cgroup_do_mount(&cgroup_fs_type, fc->sb_flags, root,
   -                                CGROUP_SUPER_MAGIC, ns);

   [...]

   -       if (percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
   -               struct super_block *sb = dentry->d_sb;
   -               dput(dentry);
   +       ret = cgroup_do_mount(fc, CGROUP_SUPER_MAGIC, ns);
   +       if (!ret && percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
   +               struct super_block *sb = fc->root->d_sb;
   +               dput(fc->root);
                   deactivate_locked_super(sb);
                   msleep(10);
                   return restart_syscall();
           }
   --------------

In changing from the local "*dentry" variable to using fc->root, we now
export/leave that dentry pointer in the file context after doing the dput()
in the unlikely "is_dying" case.   With LTP doing a crazy amount of back to
back mount/unmount [testcases/bin/cgroup_regression_5_1.sh] the unlikely
becomes slightly likely and then bad things happen.

A fix would be to not leave the stale reference in fc->root as follows:

   --------------
                  dput(fc->root);
  +               fc->root = NULL;
                  deactivate_locked_super(sb);
   --------------

...but then we are just open-coding a duplicate of fc_drop_locked() so we
simply use that instead.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org      # v5.1+
Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Fixes: 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/fs/internal.h b/fs/internal.h
index 6aeae7ef3380..728f8d70d7f1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -61,7 +61,6 @@ extern void __init chrdev_init(void);
  */
 extern const struct fs_context_operations legacy_fs_context_ops;
 extern int parse_monolithic_mount_data(struct fs_context *, void *);
-extern void fc_drop_locked(struct fs_context *);
 extern void vfs_clean_context(struct fs_context *fc);
 extern int finish_clean_context(struct fs_context *fc);
 
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 37e1e8f7f08d..5b44b0195a28 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -139,6 +139,7 @@ extern int vfs_parse_fs_string(struct fs_context *fc, const char *key,
 extern int generic_parse_monolithic(struct fs_context *fc, void *data);
 extern int vfs_get_tree(struct fs_context *fc);
 extern void put_fs_context(struct fs_context *fc);
+extern void fc_drop_locked(struct fs_context *fc);
 
 /*
  * sget() wrappers to be called from the ->get_tree() op.
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 1f274d7fc934..6e554743cf2b 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1223,9 +1223,7 @@ int cgroup1_get_tree(struct fs_context *fc)
 		ret = cgroup_do_get_tree(fc);
 
 	if (!ret && percpu_ref_is_dying(&ctx->root->cgrp.self.refcnt)) {
-		struct super_block *sb = fc->root->d_sb;
-		dput(fc->root);
-		deactivate_locked_super(sb);
+		fc_drop_locked(fc);
 		ret = 1;
 	}
 
-- 
2.31.1

