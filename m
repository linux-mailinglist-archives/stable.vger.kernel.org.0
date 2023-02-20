Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959DE69CEB5
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjBTOBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjBTOBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDC41E9E0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 111EA60E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22460C433EF;
        Mon, 20 Feb 2023 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901681;
        bh=Ae203KdtJCkDRQWwuWZMlJw96Pauouf65+5MHUrCZsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPKDNUvlyDMEpl/pzw4xIKsQYWmpxcP22w1XV74UipKOdyd0Ve1pGa8CZGFmmK07f
         cVIbroAj8WDeI7FQZgvl7xI8jwMn5/k3kqi8MgXBpkDbq52ukYtCHnC+SzCM4qKf4p
         ORuOmGcBJjaDkejI0CFMQnQA29SPh4Uf1MKLBI74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Eric Curtin <ecurtin@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hector Martin <marcan@marcan.st>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/118] nvme-apple: fix controller shutdown in apple_nvme_disable
Date:   Mon, 20 Feb 2023 14:37:07 +0100
Message-Id: <20230220133604.848590902@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c76b8308e4c9148e44e0c7e086ab6d8b4bb10162 ]

nvme_shutdown_ctrl already shuts the controller down, there is no
need to also call nvme_disable_ctrl for the shutdown case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 262d2b60ac6dd..92c70c4b2f6ec 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -831,7 +831,8 @@ static void apple_nvme_disable(struct apple_nvme *anv, bool shutdown)
 
 		if (shutdown)
 			nvme_shutdown_ctrl(&anv->ctrl);
-		nvme_disable_ctrl(&anv->ctrl);
+		else
+			nvme_disable_ctrl(&anv->ctrl);
 	}
 
 	WRITE_ONCE(anv->ioq.enabled, false);
-- 
2.39.0



