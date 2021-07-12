Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A9E3C4BA2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239880AbhGLG6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239384AbhGLG5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43DD86128C;
        Mon, 12 Jul 2021 06:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072882;
        bh=G88GN/b6G29KCom/8h32drPqH0lUvw+z2gj6kNG03No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBivTUD4Oz+0mt9EbQ7/jp5L7gXE55ysmMv40dJXZwehp3bk1ndpuTJmjjFffpgqI
         vfSiccWDyghLicbOBxpgVJNGcM1Qt97e1drKM6T9u7mlIuWWiCT1RfJKaOEZ2Z/S1d
         q8rKqF5SJsDusE2IhXYY5NZPzPQO0VfxQjKUHcB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 053/700] ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit
Date:   Mon, 12 Jul 2021 08:02:16 +0200
Message-Id: <20210712060932.208727618@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 4fb7c70a889ead2e91e184895ac6e5354b759135 upstream.

The cache_cnt parameter of tracepoint ext4_es_shrink_exit means the
remaining cache count after shrink, but now it is the cache count before
shrink, fix it by read sbi->s_extent_cache_cnt again.

Fixes: 1ab6c4997e04 ("fs: convert fs shrinkers to new scan/count API")
Cc: stable@vger.kernel.org # 3.12+
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210522103045.690103-3-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents_status.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1579,6 +1579,7 @@ static unsigned long ext4_es_scan(struct
 
 	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
 
+	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
 	return nr_shrunk;
 }


