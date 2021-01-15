Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315642F7B67
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733150AbhAOMd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:33:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733147AbhAOMd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B88DC23359;
        Fri, 15 Jan 2021 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713991;
        bh=NV5wkySH4VnUgK2tzF+GQZE4gy+uyLRbMXb4TMmlVpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7bA25RyK5/UZHBONB7ijhbIJWv+LthNoNb6bwYAQuaZVeE4ZHWNRT2gi7VNhkk6P
         pAKGczvBSqF2wfko1KrpdJDswDfIdiXunFLd2cvmhtNYB3FQEXm6LZ0yOSiP97errK
         WA/FpMs1cCs23+Jz2AtShSfi1CV1ZEM/DmsFFMQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+825f0f9657d4e528046e@syzkaller.appspotmail.com,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 41/43] block: fix use-after-free in disk_part_iter_next
Date:   Fri, 15 Jan 2021 13:28:11 +0100
Message-Id: <20210115121959.034428248@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit aebf5db917055b38f4945ed6d621d9f07a44ff30 upstream.

Make sure that bdgrab() is done on the 'block_device' instance before
referring to it for avoiding use-after-free.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+825f0f9657d4e528046e@syzkaller.appspotmail.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/genhd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -208,14 +208,17 @@ struct hd_struct *disk_part_iter_next(st
 		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
+		get_device(part_to_dev(part));
+		piter->part = part;
 		if (!part_nr_sects_read(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
-		      piter->idx == 0))
+		      piter->idx == 0)) {
+			put_device(part_to_dev(part));
+			piter->part = NULL;
 			continue;
+		}
 
-		get_device(part_to_dev(part));
-		piter->part = part;
 		piter->idx += inc;
 		break;
 	}


