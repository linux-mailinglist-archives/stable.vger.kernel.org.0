Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA64F54885B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348529AbiFMK5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350383AbiFMKyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AED1EC72;
        Mon, 13 Jun 2022 03:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9DD160FB1;
        Mon, 13 Jun 2022 10:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4D4C34114;
        Mon, 13 Jun 2022 10:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116273;
        bh=o7pGxIWwS9XsgJFBoYbgEMRnyrW1PeHRlM/SCQ7s4h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WY7iocI6f6x/DjQ4wSfSwZUWrgwvt/hCzzKTRkiHM6GqcZsES9aLBQcy3iUaSYWHW
         9A6sY3g5Kp6MPVhe4Ps3JAYcc7Q5TIjdz1K4DoH1qXeph0wfjcUAtGX4Pd5mZThXPO
         JKYKzsVnSvEuRY+vIqMINX5KkotImlFFowXtG68E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 162/218] ubi: ubi_create_volume: Fix use-after-free when volume creation failed
Date:   Mon, 13 Jun 2022 12:10:20 +0200
Message-Id: <20220613094925.511296129@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 8c03a1c21d72210f81cb369cc528e3fde4b45411 ]

There is an use-after-free problem for 'eba_tbl' in ubi_create_volume()'s
error handling path:

  ubi_eba_replace_table(vol, eba_tbl)
    vol->eba_tbl = tbl
out_mapping:
  ubi_eba_destroy_table(eba_tbl)   // Free 'eba_tbl'
out_unlock:
  put_device(&vol->dev)
    vol_release
      kfree(tbl->entries)	  // UAF

Fix it by removing redundant 'eba_tbl' releasing.
Fetch a reproducer in [Link].

Fixes: 493cfaeaa0c9b ("mtd: utilize new cdev_device_add helper function")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215965
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/vmt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 8f641448a97a..d32144c0098a 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -315,7 +315,6 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	ubi->volumes[vol_id] = NULL;
 	ubi->vol_count -= 1;
 	spin_unlock(&ubi->volumes_lock);
-	ubi_eba_destroy_table(eba_tbl);
 out_acc:
 	spin_lock(&ubi->volumes_lock);
 	ubi->rsvd_pebs -= vol->reserved_pebs;
-- 
2.35.1



