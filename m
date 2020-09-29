Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B6927C3C5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgI2LIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728728AbgI2LIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:08:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5DD721D7F;
        Tue, 29 Sep 2020 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377714;
        bh=R0qJl8cpdipNiLHHrTKFMp6DOFeRLJGND6qxED8fQE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RH1h76Urrbjf9qSk2S2zuqtI27uSOXlrB9AZzikmz7XZDpEnNn0wVrKCZbWr0xWl+
         Mz/LQW8hrPLYNMYKzQUNTOBoIaPKi7fyK/QZhwjxsu09YP3Ba8AGo1PZYjX4b602E+
         bZNaxZqURgQVaVpahC9Y/fAVJT3OIVcVcWMvIVlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 046/121] selinux: sel_avc_get_stat_idx should increase position index
Date:   Tue, 29 Sep 2020 12:59:50 +0200
Message-Id: <20200929105932.473731751@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 72c145dd799f1..ef1226c1c3add 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1416,6 +1416,7 @@ static struct avc_cache_stats *sel_avc_get_stat_idx(loff_t *idx)
 		*idx = cpu + 1;
 		return &per_cpu(avc_cache_stats, cpu);
 	}
+	(*idx)++;
 	return NULL;
 }
 
-- 
2.25.1



