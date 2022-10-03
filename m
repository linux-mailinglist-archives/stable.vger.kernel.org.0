Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6A5F2C99
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiJCI7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJCI6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:58:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFC72AC3;
        Mon,  3 Oct 2022 01:44:09 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2936iMQA015401;
        Mon, 3 Oct 2022 08:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=IQ8rghEJ8YiuYGyXSLHV54jhIFml8XNUB/YL71WrwyA=;
 b=zzbdbL7UkVc3QLn+kl7gqFuMKchou3I16m/7n0sAi4JyNLRASfJdvrmHByAtSd3zSDJ8
 aY3FHH7iVV+KDSUBhnir+o/+rLSQshPfoA4Pw2woMtmbpBW+er/t0Z3hpWPpE0Vg9sID
 pFCxAtqKofAV6Zgp8L7Ypu8Yqf1kGAeOLB/q2N86b3rqzUv7W2YkzDq3+gWATEziOkAs
 yCwmt4kjxnhv2zCNwZdWMzV3JuxT3U/wg5146zBI7YZ4cWJi4ynM7YCW1SrYPmVRRJhy
 n+NPcYwlf7jZ/edGl25ao3rkWknI+/KCHtngU4WJwDXfstiZpGoBVRbADN3GT50CUIrV vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51txqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 08:44:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2937tuSh016479;
        Mon, 3 Oct 2022 08:44:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc02wyue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 08:44:04 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2938i4Wu013971;
        Mon, 3 Oct 2022 08:44:04 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3jxc02wytx-1;
        Mon, 03 Oct 2022 08:44:03 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@oracle.com, george.kennedy@oracle.com,
        darren.kenny@oracle.com, vegard.nossum@oracle.com,
        stable@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 0/1] Fix NULL dereference in i2cdev_ioctl_rdwr()
Date:   Mon,  3 Oct 2022 01:43:45 -0700
Message-Id: <20221003084346.4652-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=776 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030052
X-Proofpoint-GUID: kENcoY2An1Y55vdBb9SCfC8VpkVPBugo
X-Proofpoint-ORIG-GUID: kENcoY2An1Y55vdBb9SCfC8VpkVPBugo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This backport patch addresses a NULL pointer dereference bug in 4.14.y

BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: i2cdev_ioctl_rdwr.isra.2+0xe4/0x360
PGD 13af50067 P4D 13af50067 PUD 13504c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
Dumping ftrace buffer:
  (ftrace buffer empty)
Modules linked in:
CPU: 1 PID: 17421 Comm: rep Not tainted 4.14.295 #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
task: ffff88807c43a080 task.stack: ffffc90000d0c000
RIP: 0010:i2cdev_ioctl_rdwr.isra.2+0xe4/0x360
RSP: 0018:ffffc90000d0fdf0 EFLAGS: 00010297
RAX: ffff88807c43a080 RBX: 0000000000000000 RCX: 0000000000000000
....
Call Trace:
  i2cdev_ioctl+0x1a5/0x2a0
  ? i2cdev_ioctl_rdwr.isra.2+0x360/0x360
  do_vfs_ioctl+0xac/0x840
  ? syscall_trace_enter+0x159/0x4a0
  SyS_ioctl+0x7e/0xb0
  do_syscall_64+0x8d/0x220
....
 RIP: i2cdev_ioctl_rdwr.isra.2+0xe4/0x360 RSP: ffffc90000d0fdf0
....
 Kernel panic - not syncing: Fatal exception
 Rebooting in 86400 seconds..

rdwr_pa[i].buf[0] is a NULL dereference when len=0, so to avoid
dereferencing zero-length buffer we add a check on len before
dereferencing.

I have tested only with the reproducer and the bug doesnot occur
after this patch.

This patch is only made for 4.14.y as other higher LTS branches
(>=4.19.y) already have the fix.

Thanks,
Harshit

Alexander Popov (1):
  i2c: dev: prevent ZERO_SIZE_PTR deref in i2cdev_ioctl_rdwr()

 drivers/i2c/i2c-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.37.1

