Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FBC12F114
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgABW6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgABWQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D2C21582;
        Thu,  2 Jan 2020 22:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003368;
        bh=2bK+N9n2XhCnBiR1Sf9GV310GDSwg+CzuNtg8cn+gUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jW0MqduM2oJMXzEoOCQFzUDvbqMzdcRjPZOQSoKZoPP3nVOnsBeuY0sFweBhfAJv4
         2guRehskT9/l7guFpuFw4/2/9UOUtc6gjFr98avj5We9uGdGt5/C3azBLNrwXNdHTN
         XW4UVl5xmo9fvZ0TqYqIOA+NoGm1gNQFUVoTM88s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/191] md: make sure desc_nr less than MD_SB_DISKS
Date:   Thu,  2 Jan 2020 23:06:54 +0100
Message-Id: <20200102215843.832955499@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit 3b7436cc9449d5ff7fa1c1fd5bc3edb6402ff5b8 ]

For super_90_load, we need to make sure 'desc_nr' less
than MD_SB_DISKS, avoiding invalid memory access of 'sb->disks'.

Fixes: 228fc7d76db6 ("md: avoid invalid memory access for array sb->dev_roles")
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1159,6 +1159,7 @@ static int super_90_load(struct md_rdev
 	/* not spare disk, or LEVEL_MULTIPATH */
 	if (sb->level == LEVEL_MULTIPATH ||
 		(rdev->desc_nr >= 0 &&
+		 rdev->desc_nr < MD_SB_DISKS &&
 		 sb->disks[rdev->desc_nr].state &
 		 ((1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE))))
 		spare_disk = false;


