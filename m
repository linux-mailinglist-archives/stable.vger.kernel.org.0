Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7361924B957
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgHTLmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgHTKEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:04:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83633208E4;
        Thu, 20 Aug 2020 10:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917849;
        bh=Ktupa7X6jxVFhDQR97qaAuJM8PQPxg3we9kpisQ/tS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hReBG15S/FXqYGzcUjfylv4pFO5hotV16LWn8/OY9Ytk8p7DqZrfec+67BIel0d7R
         Y4LiyG/kivo3sowJtZPw5FuKqDjGUXtwz/hT37EUZteIIRZs+DbsvBtehmQy8Lz3qP
         9lcogzV4HgTExJI+o6oaQXXYQhHpaoPx1TeII8RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Wu <alexwu@synology.com>,
        BingJing Chang <bingjingc@synology.com>,
        Danny Shih <dannyshih@synology.com>,
        ChangSyun Peng <allenpeng@synology.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.9 180/212] md/raid5: Fix Force reconstruct-write io stuck in degraded raid5
Date:   Thu, 20 Aug 2020 11:22:33 +0200
Message-Id: <20200820091611.480807859@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChangSyun Peng <allenpeng@synology.com>

commit a1c6ae3d9f3dd6aa5981a332a6f700cf1c25edef upstream.

In degraded raid5, we need to read parity to do reconstruct-write when
data disks fail. However, we can not read parity from
handle_stripe_dirtying() in force reconstruct-write mode.

Reproducible Steps:

1. Create degraded raid5
mdadm -C /dev/md2 --assume-clean -l5 -n3 /dev/sda2 /dev/sdb2 missing
2. Set rmw_level to 0
echo 0 > /sys/block/md2/md/rmw_level
3. IO to raid5

Now some io may be stuck in raid5. We can use handle_stripe_fill() to read
the parity in this situation.

Cc: <stable@vger.kernel.org> # v4.4+
Reviewed-by: Alex Wu <alexwu@synology.com>
Reviewed-by: BingJing Chang <bingjingc@synology.com>
Reviewed-by: Danny Shih <dannyshih@synology.com>
Signed-off-by: ChangSyun Peng <allenpeng@synology.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3364,6 +3364,7 @@ static int need_this_block(struct stripe
 	 * is missing/faulty, then we need to read everything we can.
 	 */
 	if (sh->raid_conf->level != 6 &&
+	    sh->raid_conf->rmw_level != PARITY_DISABLE_RMW &&
 	    sh->sector < sh->raid_conf->mddev->recovery_cp)
 		/* reconstruct-write isn't being forced */
 		return 0;
@@ -4498,7 +4499,7 @@ static void handle_stripe(struct stripe_
 	 * or to load a block that is being partially written.
 	 */
 	if (s.to_read || s.non_overwrite
-	    || (conf->level == 6 && s.to_write && s.failed)
+	    || (s.to_write && s.failed)
 	    || (s.syncing && (s.uptodate + s.compute < disks))
 	    || s.replacing
 	    || s.expanding)


