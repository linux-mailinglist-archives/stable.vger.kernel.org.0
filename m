Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA673CDC26
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbhGSOvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344388AbhGSOsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB34E61418;
        Mon, 19 Jul 2021 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708517;
        bh=O7eGIM+q0fvJiLEGqHLB3MfpPIOCQEBLAUumc5otFFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHFXBKodp5KV5tRm2fkQvBbh/d9WolQilTXRg0MYke29tjIhHDDCMCSUlquVm2wCV
         vh3z6zo74E5LiJ3b3B4h3zZqcuAcKHQfvc+bdug7kptC/mdozgy/AFqJkBPmqnfbIJ
         Vp9iOuv7q1qikLNzV/rkPurVV9oYA0Jw8owHWGGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 023/421] ext4: remove check for zero nr_to_scan in ext4_es_scan()
Date:   Mon, 19 Jul 2021 16:47:14 +0200
Message-Id: <20210719144947.067227356@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit e5e7010e5444d923e4091cafff61d05f2d19cada upstream.

After converting fs shrinkers to new scan/count API, we are no longer
pass zero nr_to_scan parameter to detect the number of objects to free,
just remove this check.

Fixes: 1ab6c4997e04 ("fs: convert fs shrinkers to new scan/count API")
Cc: stable@vger.kernel.org # 3.12+
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210522103045.690103-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents_status.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1080,9 +1080,6 @@ static unsigned long ext4_es_scan(struct
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
 
-	if (!nr_to_scan)
-		return ret;
-
 	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
 
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);


