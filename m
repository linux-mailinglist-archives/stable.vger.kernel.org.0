Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309F547729B
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 14:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhLPNFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 08:05:09 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54110 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237207AbhLPNFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 08:05:08 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGCGxWl007552;
        Thu, 16 Dec 2021 13:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=AwoV8nyp2Rwk3kdTuofVtNRbjXvbX9U6fgRTeECtr9g=;
 b=r65n81tmSfKDsbSvV6EYZnM+sfWwIU5CsLa4ScRDdjdugJQbcc2SaJ+u1jHCWUXwwtNf
 ZI2wJsBjKQ1rrys78QSOIlkspi7mNdI5XqYm/nmUbuDG0GQLn+jX9R7Xg7vgXaAsc75a
 zvy/+0FYovF0FRd7gf7a2cQbTSgq1ZYQwV6vkpJNHxBhtG+9EP/FkArerUJ5k8kOesmK
 pc4I2yUiPwiSbTDfJfHbKo0kwJe/GyH0SqrcG/4l7CYgzsy+02GCIV54AxopIA72dwVM
 rEyEaDev9w8N6RLPnZv5dKY+lryPdYGDFeoVK7tgmmYF1jI2sKVu/+wW+1tx9wae0OVn 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknc2nu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:05:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BGD0hN2008386;
        Thu, 16 Dec 2021 13:04:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by userp3030.oracle.com with ESMTP id 3cvh41xn4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:04:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aC7zz/teswH5rNonefgwY+4SnBA2Ca8cwc16xFDfw0eLjFN2jSHJ5a3kDEsEQ3A/MYa9e55Nj2xv8QL6Kh2DnsBmCf2OpiCICNPXLDMEtRHBB70tj50a7fuIjSeDZy9es8j3l84+OdYXKdGZ3lprUoA6CWtpEsgS7fFJXRgZfrmO+gwpOUpBa7atjQFH97kuhu4GTaqIXUc0AaWfCs7e+4oJiSLOFSaRQiIJq089w4ickqtJYq9nrj3v8c/Ow3NUoWhpnNTeEJqVDDQSt2hMCq2PGgGiq+pivOk8xqCDOcTUyV2bKxeMWilNvfbBJMpF6yUDkMdRf73A8DCIqQOKCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwoV8nyp2Rwk3kdTuofVtNRbjXvbX9U6fgRTeECtr9g=;
 b=EhjhmgCKH8H3aLvy//498aNiShrqCSMxDPX8pCDMVvMsvRRgfmmN8b8Vd7245XnzDsX/nThR1wzMVKnmW0npIn1nUhizasWFso3C+E9o2GWw9cCWfnwDNl+27ac09LJMGYpc6hd+vD+xkqJxp47ukKiL++p9mjjG00+LC1n+TtZ/6mmL+KkKj8dqhLR8xGSmpWG4R+tUvJ2mTk474ut8UXBKecjyhtuYQ5wxi3IgGRu+LsE+Hm4EtLWqIz7kK5OF4D4o2kHPpyO+EJlzEmsJaUWwQu7BFNeOuThSsLaC5NDRkYt9PID0PlFbaKiJUwk8aN3xo8HoPKghBcLB/5ZbsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwoV8nyp2Rwk3kdTuofVtNRbjXvbX9U6fgRTeECtr9g=;
 b=xLe0m4MjhXvN+HojWjwwTfL9EWwUPW4QqyksjsfR4RbqiIQeJH7MyLs1A2yKUmUxrE4txRcgDgxBlY77hGDLLeoBURFkX+W6q3MaLX9C8bwDfa6RdeiJUamX1FF6pscUqcZY9XaySp+d7SFSl1tYDs1b7kv6+9RWAD+R6Vb38+E=
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB4093.namprd10.prod.outlook.com (2603:10b6:208:114::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 13:04:57 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00%8]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 13:04:57 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Su Yue <l@damenly.su>, David Sterba <dsterba@suse.com>
Subject: [PATCH stable-5.15.y 2/4] btrfs: use latest_dev in btrfs_show_devname
Date:   Thu, 16 Dec 2021 21:04:11 +0800
Message-Id: <b7925cc522db365166b8ecddde9ba6f4f6a6a058.1639658429.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639658429.git.anand.jain@oracle.com>
References: <cover.1639658429.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0029.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::16) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdd083e8-8f73-4e4c-ca52-08d9c094a8ef
X-MS-TrafficTypeDiagnostic: MN2PR10MB4093:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB40934573B27D8A0832699A3FE5779@MN2PR10MB4093.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /IXTBNBipLg/f8xSC6X8P2JHXgxMa+Q0zFMtnAy4txz4WhOQVppT2y2/MZHfppZ1OEq7oVL/99R9QFsiXYm35GJFXQhQzMLr4WPMB/hHQeFiCj77Ld/9tOMSOkXXzY9Bd1PwckxwEvQQJOsMf0Juw3uCOWCHuLE8Wqax13pZPqUo5HThRMXmlArAcuGJxwlfGFpFKTi2/HyFil3didki3N2jQZ+fqvZxphdXMHsAU082FfGN7E1sZM+IdZAW6T1wSitKvBiijx3w+YtKDLwJvlckIHFS+qn9bdEzB+J4n0rUnmFnYtfX9RS17Pmewkm/a1Vxr09kkwfbOkt8W8WU6aUfJiu4TkubXEGyIzfFJ9LFeF1FbMXIalWzYDqLQk5VnVKfR31SGTGQEPXHpRtd1ZvvFiBDVKFfbCA/9nw2PKETE67wmCxspG1mnWjRaevEleoTG2J8U2W+nvFxDwVosAsWDECAnki8VY9cOxKZano+79xDT7IAJrunFOu3iYhrNTeO0HpnuJCi0zayzuWdlDL1HdfXLOXVotPRO0Z84ZDD2JcEi1gsp4NBL7+5svFaIVHKWpGSaGRliPZyvamnk3g0j8zWRqDpQBEgJc5O7rUCyJgR1669gVSmnl6LmaEtdHORiYfm+pK3L8OVkbplVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(316002)(4326008)(6486002)(5660300002)(83380400001)(38100700002)(186003)(86362001)(2906002)(6512007)(508600001)(8676002)(6506007)(8936002)(66556008)(54906003)(36756003)(2616005)(66946007)(6666004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vfFdpbfZlOuiK7v3C4hbrPrsoBoHtSEmTFX67PSyWDAQNwvB4/xMJ18yvhWD?=
 =?us-ascii?Q?CELJw63OPqmTs/HHcTimv+edjXq4SJqbvsoLl71tYI9iHeDNyHpEim4gS5Sn?=
 =?us-ascii?Q?Y4CCj66Bla75Mgo02w/vUOLSYSlrK3Ug1PueEanMcQn5dcKtz8Mz9PaY/WtQ?=
 =?us-ascii?Q?cm7e1R0J5TgYzoKQPfXaqIDThJTkqrMDVOrLVACf00ZCHqtgaSfUVMaGyzy0?=
 =?us-ascii?Q?Y52/zoFFkSt9hVbNpN5wQrYFcSWsrPVaR6r9p3IK5p1mTCJccfyPh9qJvC1K?=
 =?us-ascii?Q?DUN+X3QiSzIFczNAfIFTfH1QH+EbjjbgH0aAYIuwqKHbGngbMGHLPR2eBzFl?=
 =?us-ascii?Q?yfNAVpjpwRd9dP34Ip0mc1uHQOvgSRvoMIKkT7NwkGMwv0w9Ai+eKD8A291t?=
 =?us-ascii?Q?46WyZdvnGcP0L1f5eneongJGcVTM1q2CZJqXMMMN4un88fGGpczq9oef5CnS?=
 =?us-ascii?Q?CPXiUNt1kRguS39Ep1WQTca8aSINpXklNe9YXLXW5veclO2Qt7TY+xCb86cX?=
 =?us-ascii?Q?YAh//3V+yO2wyyJI7GKcmP7uG6AXXYHo3eKzanIWOsKP0rJ2y1b4Gl0Onv0F?=
 =?us-ascii?Q?hsOeRIlbgsn0AHd8YAPJFbms3S5rNKSiQSl9uIV+W/h6by5kEw/KJsERThWM?=
 =?us-ascii?Q?pJA5SOXNy7XOpdex2kRSwMsDOKPQMVY6kIukJNr+YYD1+A8fcLAPD5/4By1j?=
 =?us-ascii?Q?9J85OertwQUZjG5r1VHj7TOtgzkUP3hX5WDFswBlHrWt6VuC1PUmGvXaf1CN?=
 =?us-ascii?Q?wyQcwOBJwSAtxq4GqVPrMPlL6Hlx3heNA8MtOj4EctYyy15mkw+znxFCRj0T?=
 =?us-ascii?Q?7E03DNBhLyt1IGJ0hK05wRETwk9UbbeiLAv30f2LCaaklnBIZJ5RXR0ze0e4?=
 =?us-ascii?Q?0wYSzCzIRfa5GCQMNxG7umTPVCZUyAp3kf9BcZTOAqZsD4I994ry9otftkQJ?=
 =?us-ascii?Q?ca0F0IxAsl6zyqNr84SAFz+wLQ50uJwS86RCvm4wLr3QsXqtOTDltCM6Pe8F?=
 =?us-ascii?Q?RKNcBkbLzlHUYpF3L1JtQGRmj89iGB7ETytWP++sNgBAztIeMxlraQBlQbCM?=
 =?us-ascii?Q?G3uLCcLHpznsbjrU1vOgn1DMls4jVzgutaylQhCSCIF11RYRc6JY70AGvLeS?=
 =?us-ascii?Q?nXaoC6ZBhcT7f1fYb2WQP+7sYGkBoe8qgNbByIEzK7MK5heZMbmSrE5irMiX?=
 =?us-ascii?Q?KAC7fVrQTDppJ8XIfiBmTBKDdlFmt9fINaA6yE3tidXNarkojIi0RKZ5dD53?=
 =?us-ascii?Q?rlSRL5fG4QAWN0qDIPPlqFNeoON9Szh59VnNkX2bAUwyZwtudzaw7k6y0VG4?=
 =?us-ascii?Q?QhOGOTK5Glscl3BmmgcHWPKu6r1FoNvbYTn3QrZkLPUM50OG5Y8PRSUwmxTd?=
 =?us-ascii?Q?LdLjV4WCXzildl4hLlEOPDKx7EP+T6Nphqnm2UHsldYeVupNFX76nYchd8Sd?=
 =?us-ascii?Q?+b0OTP5QICHfSc4OZt10g1jLOjry4GqcG8d5Sd2s0tjb2X/j+5Vx5zQ+we5T?=
 =?us-ascii?Q?hrWB3GB5mmYZJVI0Bwn6GtYkUcGA9yT+a9FrmwbaYU/AQlveFiL6QuP774ui?=
 =?us-ascii?Q?I2RK0xzmq9FqMZRsWkRRmfPBfng5CSHdxwtXDMgsM1jNiuk9y17XMoCk8RNV?=
 =?us-ascii?Q?yzkUpA29NSt9OjAZd/+zXIVRtqLCho+KhedhlW36rzao8ZTvIZjom6GpdQ36?=
 =?us-ascii?Q?bW4G4A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd083e8-8f73-4e4c-ca52-08d9c094a8ef
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 13:04:57.2553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plxWt2XBNgX64uRdASjWurssB0gjE+oSiPeAa3SETb7FP9cHYF6k5CwOR1JY870STBLXMIUj3Hd+IQr1dfD2Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4093
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112160073
X-Proofpoint-ORIG-GUID: 9tLOtfPNhWNi1uIWODB8CD3H4pStWDkw
X-Proofpoint-GUID: 9tLOtfPNhWNi1uIWODB8CD3H4pStWDkw
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 6605fd2f394bba0a0059df2b6cfc87b0b6d393a2 upstream.

The test case btrfs/238 reports the warning below:

 WARNING: CPU: 3 PID: 481 at fs/btrfs/super.c:2509 btrfs_show_devname+0x104/0x1e8 [btrfs]
 CPU: 2 PID: 1 Comm: systemd Tainted: G        W  O 5.14.0-rc1-custom #72
 Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
 Call trace:
   btrfs_show_devname+0x108/0x1b4 [btrfs]
   show_mountinfo+0x234/0x2c4
   m_show+0x28/0x34
   seq_read_iter+0x12c/0x3c4
   vfs_read+0x29c/0x2c8
   ksys_read+0x80/0xec
   __arm64_sys_read+0x28/0x34
   invoke_syscall+0x50/0xf8
   do_el0_svc+0x88/0x138
   el0_svc+0x2c/0x8c
   el0t_64_sync_handler+0x84/0xe4
   el0t_64_sync+0x198/0x19c

Reason:
While btrfs_prepare_sprout() moves the fs_devices::devices into
fs_devices::seed_list, the btrfs_show_devname() searches for the devices
and found none, leading to the warning as in above.

Fix:
latest_dev is updated according to the changes to the device list.
That means we could use the latest_dev->name to show the device name in
/proc/self/mounts, the pointer will be always valid as it's assigned
before the device is deleted from the list in remove or replace.
The RCU protection is sufficient as the device structure is freed after
synchronization.

Reported-by: Su Yue <l@damenly.su>
Tested-by: Su Yue <l@damenly.su>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e4963da4dd08..7f91d62c2225 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2463,30 +2463,16 @@ static int btrfs_unfreeze(struct super_block *sb)
 static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
-	struct btrfs_device *dev, *first_dev = NULL;
 
 	/*
-	 * Lightweight locking of the devices. We should not need
-	 * device_list_mutex here as we only read the device data and the list
-	 * is protected by RCU.  Even if a device is deleted during the list
-	 * traversals, we'll get valid data, the freeing callback will wait at
-	 * least until the rcu_read_unlock.
+	 * There should be always a valid pointer in latest_dev, it may be stale
+	 * for a short moment in case it's being deleted but still valid until
+	 * the end of RCU grace period.
 	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(dev, &fs_info->fs_devices->devices, dev_list) {
-		if (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state))
-			continue;
-		if (!dev->name)
-			continue;
-		if (!first_dev || dev->devid < first_dev->devid)
-			first_dev = dev;
-	}
-
-	if (first_dev)
-		seq_escape(m, rcu_str_deref(first_dev->name), " \t\n\\");
-	else
-		WARN_ON(1);
+	seq_escape(m, rcu_str_deref(fs_info->fs_devices->latest_dev->name), " \t\n\\");
 	rcu_read_unlock();
+
 	return 0;
 }
 
-- 
2.33.1

