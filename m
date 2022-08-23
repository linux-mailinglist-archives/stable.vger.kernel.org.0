Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F159DC06
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352759AbiHWKOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353669AbiHWKLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:11:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD4E1CFE5;
        Tue, 23 Aug 2022 01:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F01DB81C39;
        Tue, 23 Aug 2022 08:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA54C433C1;
        Tue, 23 Aug 2022 08:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245087;
        bh=3lexMGJKqNSSshBNGmPY6l9XMI4LRtysWKOU/2UhE5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlhB7IxljUEwTzDziegjB5VLIb+nQTMQRF8Mr7g+RWmPsdy5jj4C22EaV3GKQrmLl
         G8EnRc7a+FUaxsMlKyXZncAaK7fUGQkuLS7/t+UO2FR9dBr43xbnXMq7JzgSA1pl65
         4IURSBR9uAn/MhoJjV3IqduXqsXHyIYucEAugfNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/244] vfio: Clear the caps->buf to NULL after free
Date:   Tue, 23 Aug 2022 10:26:08 +0200
Message-Id: <20220823080106.483014565@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit 6641085e8d7b3f061911517f79a2a15a0a21b97b ]

On buffer resize failure, vfio_info_cap_add() will free the buffer,
report zero for the size, and return -ENOMEM.  As additional
hardening, also clear the buffer pointer to prevent any chance of a
double free.

Signed-off-by: Schspa Shi <schspa@gmail.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20220629022948.55608-1-schspa@gmail.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3c034fe14ccb..818e47fc0896 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1850,6 +1850,7 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
 	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
 	if (!buf) {
 		kfree(caps->buf);
+		caps->buf = NULL;
 		caps->size = 0;
 		return ERR_PTR(-ENOMEM);
 	}
-- 
2.35.1



