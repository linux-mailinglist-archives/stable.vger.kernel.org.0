Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB6128A4F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfEWTMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388380AbfEWTMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:12:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B22FE2186A;
        Thu, 23 May 2019 19:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638729;
        bh=JtWd6O3/eRycUXinHH2loJFoCaEZwSr600RHCObQA7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FeJJqX87bPKp2DpOXadz4ATqQZay8JBHMYEV9JJ7YAbxXv+fEwZujI2/2mllwVst8
         zAkvB35+C9H35PbNTSc8AL+L/w/UYxDTYx9BL9YGp5A1llazChhCwocLZvDNMatuTC
         GWm7XAIngyqRSP15wB5GR7y9Ki2v06h42WPjVG2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.com>, Yufen Yu <yuyufen@huawei.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.14 16/77] md: add mddev->pers to avoid potential NULL pointer dereference
Date:   Thu, 23 May 2019 21:05:34 +0200
Message-Id: <20190523181722.480834303@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

commit ee37e62191a59d253fc916b9fc763deb777211e2 upstream.

When doing re-add, we need to ensure rdev->mddev->pers is not NULL,
which can avoid potential NULL pointer derefence in fallowing
add_bound_rdev().

Fixes: a6da4ef85cef ("md: re-add a failed disk")
Cc: Xiao Ni <xni@redhat.com>
Cc: NeilBrown <neilb@suse.com>
Cc: <stable@vger.kernel.org> # 4.4+
Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2845,8 +2845,10 @@ state_store(struct md_rdev *rdev, const
 			err = 0;
 		}
 	} else if (cmd_match(buf, "re-add")) {
-		if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk == -1) &&
-			rdev->saved_raid_disk >= 0) {
+		if (!rdev->mddev->pers)
+			err = -EINVAL;
+		else if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk == -1) &&
+				rdev->saved_raid_disk >= 0) {
 			/* clear_bit is performed _after_ all the devices
 			 * have their local Faulty bit cleared. If any writes
 			 * happen in the meantime in the local node, they


