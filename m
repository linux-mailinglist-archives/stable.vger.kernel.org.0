Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89A95406B5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344147AbiFGRhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347687AbiFGRfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FA2BC6F8;
        Tue,  7 Jun 2022 10:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73D17B8220B;
        Tue,  7 Jun 2022 17:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF667C385A5;
        Tue,  7 Jun 2022 17:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623058;
        bh=2D9KikUe9oTYeuBe7GwvUaWVp/nisnI0acN44yzsfe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzMV/gAy8aL0Fjp/IkuZmsg1MOnzfE8cRdNuFLPw9bttx5wxq3oQ+dC1DrdImZIfx
         Lwyog4l8tHLQBUr6UjQWOqyzufQWYFR6CjhivRMgMrdYXce+qwhO3Cc4g05kcoHlVs
         eymyKu2d2fFuViUi3syIo1uVlYmWUoutwcWLQQ5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/452] misc: ocxl: fix possible double free in ocxl_file_register_afu
Date:   Tue,  7 Jun 2022 19:02:16 +0200
Message-Id: <20220607164916.863717390@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 950cf957fe34d40d63dfa3bf3968210430b6491e ]

info_release() will be called in device_unregister() when info->dev's
reference count is 0. So there is no need to call ocxl_afu_put() and
kfree() again.

Fix this by adding free_minor() and return to err_unregister error path.

Fixes: 75ca758adbaf ("ocxl: Create a clear delineation between ocxl backend & frontend")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220418085758.38145-1-hbh25y@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/ocxl/file.c b/drivers/misc/ocxl/file.c
index 4d1b44de1492..c742ab02ae18 100644
--- a/drivers/misc/ocxl/file.c
+++ b/drivers/misc/ocxl/file.c
@@ -558,7 +558,9 @@ int ocxl_file_register_afu(struct ocxl_afu *afu)
 
 err_unregister:
 	ocxl_sysfs_unregister_afu(info); // safe to call even if register failed
+	free_minor(info);
 	device_unregister(&info->dev);
+	return rc;
 err_put:
 	ocxl_afu_put(afu);
 	free_minor(info);
-- 
2.35.1



