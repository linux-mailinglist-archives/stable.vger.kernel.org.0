Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879F02C08E1
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388281AbgKWNCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732808AbgKWMwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:52:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5910020888;
        Mon, 23 Nov 2020 12:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135945;
        bh=AMYwANOQ6rNuIZJOiSf6IwxYur41of+l2E3MaiATE8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B67cVPQZozjkxp0gAO/mmaGQglt1FmZcXi/AsABELp3haE1sUVabTGWFM/2nSQsSi
         V6jjADnMfVHYcGZbJ28l8Id97Re6OZF8IPwqlW4mvCXCtIi1DoOJBCjnnnTciR5Zdt
         +MaK4OjI6qTyttrMQcPsV6zhLmHDGhrvqvgSnoZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 244/252] blk-cgroup: fix a hd_struct leak in blkcg_fill_root_iostats
Date:   Mon, 23 Nov 2020 13:23:14 +0100
Message-Id: <20201123121847.356844127@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit b7131ee0bac5e5df73e4098e77bbddb3a31d06ff upstream.

disk_get_part needs to be paired with a disk_put_part.

Cc: stable@vger.kernel.org
Fixes: ef45fe470e1 ("blk-cgroup: show global disk stats in root cgroup io.stat")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -840,6 +840,7 @@ static void blkcg_fill_root_iostats(void
 			blkg_iostat_set(&blkg->iostat.cur, &tmp);
 			u64_stats_update_end(&blkg->iostat.sync);
 		}
+		disk_put_part(part);
 	}
 }
 


