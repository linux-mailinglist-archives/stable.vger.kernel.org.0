Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98FE3CE22F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347708AbhGSP32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348191AbhGSPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD12B61357;
        Mon, 19 Jul 2021 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710573;
        bh=bsO9+AlvIrvEHt+LlBmWdTtj1C8W/3RmGzPNsy+bniU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ap8uLWl+CWkIEjkXA0nPb4zLhcOdgw8djWqI5iOZVV1D3awkfHIJao5pqDPvGfv4V
         Bjh7lqf+SJ2BsRw4XJ/534RFbt0xzll0+FTEqpAqCDuHLouBnmjcnGM1i498eFmv/3
         Nl6+nTcDe3e3L9A1GcvmZuPQvLj4oUaG6/WgVzyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 029/351] btrfs: zoned: fix types for u64 division in btrfs_reclaim_bgs_work
Date:   Mon, 19 Jul 2021 16:49:35 +0200
Message-Id: <20210719144945.489096172@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit 54afaae34ee49e98c1c902b444b42832551d090c upstream.

The types in calculation of the used percentage in the reclaiming
messages are both u64, though bg->length is either 1GiB (non-zoned) or
the zone size in the zoned mode. The upper limit on zone size is 8GiB so
this could theoretically overflow in the future, right now the values
fit.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.13
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1539,7 +1539,7 @@ void btrfs_reclaim_bgs_work(struct work_
 			goto next;
 
 		btrfs_info(fs_info, "reclaiming chunk %llu with %llu%% used",
-				bg->start, div_u64(bg->used * 100, bg->length));
+				bg->start, div64_u64(bg->used * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
 		if (ret)


