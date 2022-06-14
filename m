Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC9954A6BB
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355215AbiFNCcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355188AbiFNC0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:26:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4729427D7;
        Mon, 13 Jun 2022 19:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81F3FB816B9;
        Tue, 14 Jun 2022 02:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEAAC341C4;
        Tue, 14 Jun 2022 02:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172656;
        bh=o/jyu2ROdm31y2b8cgGf9XEmM2oEVHame+hPgu7jdd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URndEBjW5YScMKRngGXuXPQEkDmSxmdxM8wES0Nk5nZjlnQNywW6RUm8ybwtL2ydn
         BeO+Bhy8t5asb1V3V8TUMUp4EX8qMlGAjtKceWYZdTM0669DhkXtrmRe4pDwTCgOu+
         n8BkoRHQ42W+tJhufkRpBh/BsiK8dniO2DKJQxnAz4Mh3Pky1GwELd7YlAp4Wuqr7s
         TdGlFyWTKXb/a7bfv+OCFOei+vyS9z/oQkPATcq/RsYKj3hXuUrqA+E6rIGYh/rSlF
         kd0TrkPOyfRl+T7DBUwO+SUwd2Cf6uhpn6wcqsGhO1KuKc9r1xzNlKnuI8bOLbz3vG
         aR9iJ9ypgUz/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     chengkaitao <pilgrimtao@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 09/12] virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed
Date:   Mon, 13 Jun 2022 22:10:37 -0400
Message-Id: <20220614021040.1101131-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021040.1101131-1-sashal@kernel.org>
References: <20220614021040.1101131-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: chengkaitao <pilgrimtao@gmail.com>

[ Upstream commit a58a7f97ba11391d2d0d408e0b24f38d86ae748e ]

The reference must be released when device_register(&vm_cmdline_parent)
failed. Add the corresponding 'put_device()' in the error handling path.

Signed-off-by: chengkaitao <pilgrimtao@gmail.com>
Message-Id: <20220602005542.16489-1-chengkaitao@didiglobal.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 50840984fbfa..f62da3b7c27b 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -630,6 +630,7 @@ static int vm_cmdline_set(const char *device,
 	if (!vm_cmdline_parent_registered) {
 		err = device_register(&vm_cmdline_parent);
 		if (err) {
+			put_device(&vm_cmdline_parent);
 			pr_err("Failed to register parent device!\n");
 			return err;
 		}
-- 
2.35.1

