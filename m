Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E088928893
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389285AbfEWT1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390273AbfEWT1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA412184E;
        Thu, 23 May 2019 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639637;
        bh=F3ZuU/gwy/KLeQZjm6lkPc1LIF72DdiJ0KLUwHFmL9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g25158NA/5hefSzlXl5DR6yXoKFRJ43d4Ccw1MDEvpknxU5PR7n0/OG+BCYmx84eW
         SRvSM6BXxxcGFH9njO+L7z+M8Nn4gbcsGx1H14NeFkPGyU1FcdxPCQ/UJAaMzczCUZ
         x3z/+zTKl1LkeW5ERsLQY0XHfez7RXsXXT/sMkc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.com>, Yufen Yu <yuyufen@huawei.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.1 039/122] md: add mddev->pers to avoid potential NULL pointer dereference
Date:   Thu, 23 May 2019 21:06:01 +0200
Message-Id: <20190523181709.963999417@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
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
@@ -2852,8 +2852,10 @@ state_store(struct md_rdev *rdev, const
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


