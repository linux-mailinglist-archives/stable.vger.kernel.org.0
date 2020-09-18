Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0EA26F39A
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgIRDHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgIRCDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B10E208DB;
        Fri, 18 Sep 2020 02:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394619;
        bh=f0+XAjM5+5/LhxBHnBVlXukbbef4qgWjJksQ0qln4Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzHLpXd+dfRZHx5lf666/Lw78cB9+6MmPOdAlxUdcKedp+UdErp5/VXocHj6lwA4b
         YFSniNRCYLtEbQuQbRZGoCZ017OmOURhlfwtprpCP2syBzmJ63OgRf9KugewFZvUdM
         zOkjbiELWmuOKJihHU9xiDIVuKJMe1VJ4l4lhdfc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 121/330] selinux: sel_avc_get_stat_idx should increase position index
Date:   Thu, 17 Sep 2020 21:57:41 -0400
Message-Id: <20200918020110.2063155-121-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 8d269a8e2a8f0bca89022f4ec98de460acb90365 ]

If seq_file .next function does not change position index,
read after some lseek can generate unexpected output.

$ dd if=/sys/fs/selinux/avc/cache_stats # usual output
lookups hits misses allocations reclaims frees
817223 810034 7189 7189 6992 7037
1934894 1926896 7998 7998 7632 7683
1322812 1317176 5636 5636 5456 5507
1560571 1551548 9023 9023 9056 9115
0+1 records in
0+1 records out
189 bytes copied, 5,1564e-05 s, 3,7 MB/s

$# read after lseek to midle of last line
$ dd if=/sys/fs/selinux/avc/cache_stats bs=180 skip=1
dd: /sys/fs/selinux/avc/cache_stats: cannot skip to specified offset
056 9115   <<<< end of last line
1560571 1551548 9023 9023 9056 9115  <<< whole last line once again
0+1 records in
0+1 records out
45 bytes copied, 8,7221e-05 s, 516 kB/s

$# read after lseek beyond  end of of file
$ dd if=/sys/fs/selinux/avc/cache_stats bs=1000 skip=1
dd: /sys/fs/selinux/avc/cache_stats: cannot skip to specified offset
1560571 1551548 9023 9023 9056 9115  <<<< generates whole last line
0+1 records in
0+1 records out
36 bytes copied, 9,0934e-05 s, 396 kB/s

https://bugzilla.kernel.org/show_bug.cgi?id=206283

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/selinuxfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index e6c7643c3fc08..e9eaff90cbccd 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1508,6 +1508,7 @@ static struct avc_cache_stats *sel_avc_get_stat_idx(loff_t *idx)
 		*idx = cpu + 1;
 		return &per_cpu(avc_cache_stats, cpu);
 	}
+	(*idx)++;
 	return NULL;
 }
 
-- 
2.25.1

