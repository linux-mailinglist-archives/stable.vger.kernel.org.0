Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C65B66C587
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjAPQHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjAPQG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:06:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A6425E1D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64DE461042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1D3C433D2;
        Mon, 16 Jan 2023 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885091;
        bh=H9KEOd6zefkaddCJ4TPgugj067FnXMZcFl6yy0T700o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYVYyz/FlG6BuXYmSwbYO7ybMPXmQeYTJMtsJDbWUZ1yBbV/0LwtlQxWoYpKqIaRI
         mULUBwsWFklEfRjeRtobIYG3Zm6nlxTeMpZk02J4H6j+laAmg6YMtUjnpUy//Uod/H
         cNwsBPwPE04pBjgxl6MLQiwosGkM13fPpdLsXr1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 72/86] platform/surface: aggregator: Add missing call to ssam_request_sync_free()
Date:   Mon, 16 Jan 2023 16:51:46 +0100
Message-Id: <20230116154750.055941332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit c965daac370f08a9b71d573a71d13cda76f2a884 ]

Although rare, ssam_request_sync_init() can fail. In that case, the
request should be freed via ssam_request_sync_free(). Currently it is
leaked instead. Fix this.

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20221220175608.1436273-1-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/aggregator/controller.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/surface/aggregator/controller.c b/drivers/platform/surface/aggregator/controller.c
index b8c377b3f932..f23f7128cf2b 100644
--- a/drivers/platform/surface/aggregator/controller.c
+++ b/drivers/platform/surface/aggregator/controller.c
@@ -1700,8 +1700,10 @@ int ssam_request_sync(struct ssam_controller *ctrl,
 		return status;
 
 	status = ssam_request_sync_init(rqst, spec->flags);
-	if (status)
+	if (status) {
+		ssam_request_sync_free(rqst);
 		return status;
+	}
 
 	ssam_request_sync_set_resp(rqst, rsp);
 
-- 
2.35.1



