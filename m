Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E66810FE
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbjA3OJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjA3OJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19764303E7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A878D61085
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7631C433D2;
        Mon, 30 Jan 2023 14:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087755;
        bh=nSQI4aZcqZMCkR+QIe23Aneyj+M7p/BIQRYKz8EfHqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvbWgbaKYwdvrnGUfne3BD1PhQka/N6mp0ok9q+MUqqfA/rgES8F63QK1Bd4ccQB+
         G0YP5KeOu06bdJ23CX7QnYq3elNhHCPe8e0lkm3ar7aALD8PzBZcfLaO5ZC4fOFUfC
         1G3vIowAmCl7QJhm5/Hle7WmzTil2EBe4Xr+poAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Harris, James R" <james.r.harris@intel.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 299/313] block: ublk: move ublk_chr_class destroying after devices are removed
Date:   Mon, 30 Jan 2023 14:52:14 +0100
Message-Id: <20230130134350.660239670@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 8e4ff684762b6503db45e8906e258faee080c336 ]

The 'ublk_chr_class' is needed when deleting ublk char devices in
ublk_exit(), so move it after devices(idle) are removed.

Fixes the following warning reported by Harris, James R:

[  859.178950] sysfs group 'power' not found for kobject 'ublkc0'
[  859.178962] WARNING: CPU: 3 PID: 1109 at fs/sysfs/group.c:278 sysfs_remove_group+0x9c/0xb0

Reported-by: "Harris, James R" <james.r.harris@intel.com>
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Link: https://lore.kernel.org/linux-block/Y9JlFmSgDl3+zy3N@T590/T/#t
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Jim Harris <james.r.harris@intel.com>
Link: https://lore.kernel.org/r/20230126115346.263344-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 17b677b5d3b2..e54693204630 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2092,13 +2092,12 @@ static void __exit ublk_exit(void)
 	struct ublk_device *ub;
 	int id;
 
-	class_destroy(ublk_chr_class);
-
-	misc_deregister(&ublk_misc);
-
 	idr_for_each_entry(&ublk_index_idr, ub, id)
 		ublk_remove(ub);
 
+	class_destroy(ublk_chr_class);
+	misc_deregister(&ublk_misc);
+
 	idr_destroy(&ublk_index_idr);
 	unregister_chrdev_region(ublk_chr_devt, UBLK_MINORS);
 }
-- 
2.39.0



