Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A18C745F0
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391468AbfGYFqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728399AbfGYFqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:46:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AA322CD3;
        Thu, 25 Jul 2019 05:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033607;
        bh=lOUS12o9Yt8ouLDkj3XLeTVRiYqi5C1oIrnrLOi0dhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXRAud6pOkqwti6/r8VpOr1V/UZlX3zcfuOd5fUDqQqfX5HrxY+jE1Mm9HuIr9wbT
         5Qowge5/c0m12Fz4E/zlkPVb3B4e7QuZIKHhBuUj6amfIyk91Lka76uX9Dlp5cXhvP
         ki1bJb2zJB+RUfvKikqCwocSSarWIKxXulqF6pds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Josef Bacik <jbacik@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 267/271] blk-iolatency: clear use_delay when io.latency is set to zero
Date:   Wed, 24 Jul 2019 21:22:16 +0200
Message-Id: <20190724191718.116443451@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 5de0073fcd50cc1f150895a7bb04d3cf8067b1d7 upstream.

If use_delay was non-zero when the latency target of a cgroup was set
to zero, it will stay stuck until io.latency is enabled on the cgroup
again.  This keeps readahead disabled for the cgroup impacting
performance negatively.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <jbacik@fb.com>
Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-iolatency.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -746,8 +746,10 @@ static int iolatency_set_min_lat_nsec(st
 
 	if (!oldval && val)
 		return 1;
-	if (oldval && !val)
+	if (oldval && !val) {
+		blkcg_clear_delay(blkg);
 		return -1;
+	}
 	return 0;
 }
 


