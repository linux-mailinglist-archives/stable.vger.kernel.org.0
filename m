Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48A93C44A1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhGLGUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234062AbhGLGTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFCEA610D1;
        Mon, 12 Jul 2021 06:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070627;
        bh=Gpz18vzhw0BgSl4Ph41Sq3fPLQrmUEKZ8wV/HaCjymk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8/x6p+X+KFy0o6Pa30nTuKar13ZIS4e0Gvaa7y7NQWO4OevwkfFKpPn+kfuiF5jY
         kgkYtOZsAeYqjZWHyMIw1mgRoFuCvA01cTBtTw11V/1y2TsrEwBwX3PYzPGgbtO+Jm
         N6TDQ0ewerv4dJ9Rx4+mf/oobvr24D42vNX1wwr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 028/348] ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit
Date:   Mon, 12 Jul 2021 08:06:52 +0200
Message-Id: <20210712060704.224406766@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
@@ -1558,6 +1558,7 @@ static unsigned long ext4_es_scan(struct
 
 	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
 
+	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
 	return nr_shrunk;
 }


