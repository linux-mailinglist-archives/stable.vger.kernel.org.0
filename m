Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE30B11BE8D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfLKUu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:50:28 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:35685 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfLKUu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:50:27 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MRCBm-1iK9Wr1CTc-00N6b3; Wed, 11 Dec 2019 21:45:01 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@fb.com>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org
Subject: [PATCH 06/24] compat_ioctl: block: handle Persistent Reservations
Date:   Wed, 11 Dec 2019 21:42:40 +0100
Message-Id: <20191211204306.1207817-7-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191211204306.1207817-1-arnd@arndb.de>
References: <20191211204306.1207817-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:MERO8zqQm/hzGxvh7HZnjW9vQ1ZkuwnxVUEsPHkICjTXF72YTAX
 GzMR0NQXrHDUH1Ymk9up4NF0oLy5R2DPdiNH0cZ5VKqru27Xw4DQslx1eJSQWf06CCL1CNf
 jgBrKB7/+0fQuGpKbgn+ah/UhrVsIriUPnvb9s0qeTnOjN0sopsSOo5nNWQRPuh8beEa46x
 CqJxhbbw4iH1L6KK+ABTw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cgHM/oukC3A=:Wr9cjDcJN40wTgqwfOa2OY
 IeB4iEnKqfNoRtRGuXIwtlpmRnDA+FXs7+eBPsV3Jtcv7d5IVtBbcJmfIW5Jq2GTuk4rqxiZG
 upmoAj6LgLqs/Xga9Dvv3jZwEz4E6KHff+Z7KEjINDweoqJV7C8SkI1177LjWSxknHaesB0Q5
 BjXEId+7YKOx03fWONcPFlB411QY5y32LND3+HeBcQM1FO1iVA+d15fICtU5rAtUwdg/J18SA
 k8eCOqXrWszndNXc+gnRwLq6O32FMoXeBONlMKkSOBAeEJOMyO7DqM/BxKRhRKAqZ2wgI1qfP
 TkPb+PfBTqlvfXQrJaYNahGpIVImte/G46I83l43XRdEBp9PvtxdWZ4haYTdngDQKN5yX3oXO
 uXgi0/BXVLT1gKvLnz4kRLfePf0H3qBBY6Ex30UinIn5gLxRDlDqZApaVwkU8wy7aKFt1jUb9
 ihFLXWJ6uxSKiB7bzLHfHZksBhL7Mvc/eLbS2/zJwZp/vchOB/uAD8bmhwn4AtsXP+sOkHikd
 t2HrJqmN2rMiGWFSIB4OVqIQkaoHABPCZOjowivoRLnLO4SQBSJNAbfzF/SOtoY9wlCfC2kSr
 wENXIPN6oQLrNRvceFj+PrbKDiDFQE/2+dFF+qQJlbH+VnzeBpVgAqV7i8IpNy0LfMzGuXEq/
 N90+kCpIPtN+R2PGwv1Jv08WFACU+uGWXH3WMib15C4h1o3sA7kUEBrIp3qsAbR3+O14ebLQo
 b0m349+vlPkY7mdXIAqMELR9ztbqWPLSAkLrziNrgq2KP+J/t/0Q2Y7+x+RtBamThBy8hkYiQ
 rg02cnlfarh5rkL6HtGaqMnHHoW7tbUaNsiJYR/5Za2agv6fEKGSLJ+o6uCXNcdnFHxoaYFTO
 26SDlJk8ZBEKbCH6Zjyg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These were added to blkdev_ioctl() in linux-5.5 but not
blkdev_compat_ioctl, so add them now.

Cc: <stable@vger.kernel.org> # v4.4+
Fixes: bbd3e064362e ("block: add an API for Persistent Reservations")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/compat_ioctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 5b13e344229c..f16ae92065d7 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -408,6 +408,14 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKTRACETEARDOWN: /* compatible */
 		ret = blk_trace_ioctl(bdev, cmd, compat_ptr(arg));
 		return ret;
+	case IOC_PR_REGISTER:
+	case IOC_PR_RESERVE:
+	case IOC_PR_RELEASE:
+	case IOC_PR_PREEMPT:
+	case IOC_PR_PREEMPT_ABORT:
+	case IOC_PR_CLEAR:
+		return blkdev_ioctl(bdev, mode, cmd,
+				(unsigned long)compat_ptr(arg));
 	default:
 		if (disk->fops->compat_ioctl)
 			ret = disk->fops->compat_ioctl(bdev, mode, cmd, arg);
-- 
2.20.0

