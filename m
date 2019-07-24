Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3017573B81
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405266AbfGXUAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404950AbfGXUAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15FCA205C9;
        Wed, 24 Jul 2019 20:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998440;
        bh=Imh51isZT2drzGlUwJKWk7XtSEG4yh7bkKWU/He7j2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L96R8ybIVsIcNIkO9Gi7iC4SfP3aSRs5jV/SMF39ypaPRUxRCyiqTQBksnCF7brMu
         Tkbyr20x7dg2u6UBc81h94D++4rFyUyiGwqFqKh0xUrVygpVuSPJ8E47zsL0aRY27I
         hONsN/ngv4NbcDZv+t0vfN+Y/syF/4wWUGHPzZJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Josef Bacik <jbacik@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 366/371] blk-iolatency: clear use_delay when io.latency is set to zero
Date:   Wed, 24 Jul 2019 21:21:58 +0200
Message-Id: <20190724191751.788091643@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
@@ -758,8 +758,10 @@ static int iolatency_set_min_lat_nsec(st
 
 	if (!oldval && val)
 		return 1;
-	if (oldval && !val)
+	if (oldval && !val) {
+		blkcg_clear_delay(blkg);
 		return -1;
+	}
 	return 0;
 }
 


