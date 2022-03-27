Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBFC4E866C
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 09:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbiC0HLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 03:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiC0HLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 03:11:03 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7AD1D31F;
        Sun, 27 Mar 2022 00:09:26 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w7so7229063pfu.11;
        Sun, 27 Mar 2022 00:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Dswsk0jetBijYktZ7SH96xaSPfRhbnA9l3ZIGPdBlrI=;
        b=i6+b2XSkalNg6DOhuZPtEKFGG0z1vvDdmoEcVQ4ypDwvzICeXJOv4LFhwpx2x18QS+
         AhlWIC4s2MpT+zM5Ora+fCociP/CzNaaxGO+mJO+Z7nuQbZL7hQ1oRJlNk+n19Hq4lgb
         7A4rHk02cWxNisZq8XWes7odzO7hdXfD5DMzQIuPQjiRbP1yr1N0cCB7cM7R8ohpRLPx
         YINtCTy1tB07UxDqqu34cU/PVkwNZBOMFK0p8ZA/Dr3q9nYRJ8HLG8q214dSGaW1ETG9
         QrK6+hgJlceQmK7rDuk2ew0kSGyBPUZ1iORntFv13yzMoDOr4mqV6wloQ1dkju8jS0pY
         qzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Dswsk0jetBijYktZ7SH96xaSPfRhbnA9l3ZIGPdBlrI=;
        b=NcSGL6uQpOQSa0RiOjLuqWars9ssyBuYTw7Dya365IVU0YJOZ4t9AH0T5p0kbYSI6x
         1RHT3eBwdfZ9xFn9sSg0U+jJNX5OPppH6/XJQSMtG7hWaM2XoKv+gPcGhxK7GYpOauG9
         I3buVK+nZJMDqW2cDq2IyjRx5LdtK2rAct9BJhXlzwi0Wa6zIodJucDsOvUUzmnJ+FJs
         PMW5KdCFp1CIhV7t/nj/0JowlEW3f8o5gZlaDJRMu+zo8/dNIOe5oBcLo72i91c/ykFQ
         H64XxmZ8WCVpGHHe0jQnT0ver5Lktdxyb9RYcXSrrPcCd0N91tFKR8WBzNN7ybJ6i788
         DlIw==
X-Gm-Message-State: AOAM531sXJcYJtlL5ZlyUXH3QIszTPcgeYrZ0w/OVahIJLoGgv55WaYT
        dTAgtJKNxWtlMZaAwX4ITpw=
X-Google-Smtp-Source: ABdhPJymh6IMTtnDyhTTmlhAfbLgWrj5zjZfypZgJnag3MlTplfc8wEo9bq0GVF9wmHFKQk5NpcMMg==
X-Received: by 2002:a63:de0c:0:b0:378:9365:c3c6 with SMTP id f12-20020a63de0c000000b003789365c3c6mr5894337pgg.301.1648364965504;
        Sun, 27 Mar 2022 00:09:25 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm11349504pfi.61.2022.03.27.00.09.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 00:09:24 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     philipp.reisner@linbit.com
Cc:     lars.ellenberg@linbit.com, axboe@kernel.dk, agruen@linbit.com,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] drbd: fix an invalid memory access caused by incorrect use of list iterator
Date:   Sun, 27 Mar 2022 15:09:18 +0800
Message-Id: <20220327070918.8465-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	idr_remove(&connection->peer_devices, vnr);

If the previous for_each_connection() don't exit early (no goto hit
inside the loop), the iterator 'connection' after the loop will be a
bogus pointer to an invalid structure object containing the HEAD
(&resource->connections). As a result, the use of 'connection' above
will lead to a invalid memory access (including a possible invalid free
as idr_remove could call free_layer).

The original intention should have been to remove all peer_devices,
but the following lines have already done the work. So just remove
this line and the unneeded label, to fix this bug.

Cc: stable@vger.kernel.org
Fixes: c06ece6ba6f1b ("drbd: Turn connection->volumes into connection->peer_devices")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/block/drbd/drbd_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6f450816c4fa..5d5beeba3ed4 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2793,12 +2793,12 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	if (init_submitter(device)) {
 		err = ERR_NOMEM;
-		goto out_idr_remove_vol;
+		goto out_idr_remove_from_resource;
 	}
 
 	err = add_disk(disk);
 	if (err)
-		goto out_idr_remove_vol;
+		goto out_idr_remove_from_resource;
 
 	/* inherit the connection state */
 	device->state.conn = first_connection(resource)->cstate;
@@ -2812,8 +2812,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	drbd_debugfs_device_add(device);
 	return NO_ERROR;
 
-out_idr_remove_vol:
-	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
 	for_each_connection(connection, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
-- 
2.17.1

