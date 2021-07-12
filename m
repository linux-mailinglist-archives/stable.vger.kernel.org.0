Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0408C3C47DD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbhGLGfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235451AbhGLGcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9055361108;
        Mon, 12 Jul 2021 06:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071385;
        bh=YU00BlJnwUxmlBM+aWUIggZOnUTxk15w6kC121CN1H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lUQUeeB7YHPN3ubnuRETV2elzXxV9yfH6b7zpAL3IFmniDAJJEdVrxXbOzH8AfRw
         +ZB1/VPVaq4onnyY/xHIb/km2SOLvl3L4R1rphScswWcDvuxjrw//hlbbWO7hl5F2t
         oYz7rbo76JXjTu9ch3G7Fb2OVZPO6Cjor1LcsrYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 047/593] ext4: remove check for zero nr_to_scan in ext4_es_scan()
Date:   Mon, 12 Jul 2021 08:03:27 +0200
Message-Id: <20210712060848.299213501@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
@@ -1574,9 +1574,6 @@ static unsigned long ext4_es_scan(struct
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
 
-	if (!nr_to_scan)
-		return ret;
-
 	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
 
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);


