Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337A54FD1A5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351019AbiDLG7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352594AbiDLG4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50241245AC;
        Mon, 11 Apr 2022 23:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00A5FB818C8;
        Tue, 12 Apr 2022 06:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49126C385A6;
        Tue, 12 Apr 2022 06:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745964;
        bh=PkzjqQdqfRCCDxJo6//915f+sa+d6tsZdAMPEWyeZZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4aU2V5rNRb5URpGztHK42qcwOcXfiWqMBtZWU9kycydoNJL3yh3rTkssg21gkjhj
         FL3c9ZkGBTIJa0TRBhrHwJNYVrjXopRZ8EXj+ph63eDKTMteOMrmrT9LOMpBXKhORQ
         aO7ZHjIK/AcetbD+ogfv1bAMzV4xDAxQqZ0n+geI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/277] staging: vchiq_core: handle NULL result of find_service_by_handle
Date:   Tue, 12 Apr 2022 08:28:35 +0200
Message-Id: <20220412062945.281147239@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit ca225857faf237234d2fffe5d1919467dfadd822 ]

In case of an invalid handle the function find_servive_by_handle
returns NULL. So take care of this and avoid a NULL pointer dereference.

Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1642968143-19281-18-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/vc04_services/interface/vchiq_arm/vchiq_core.c  | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
index 9429b8a642fb..630ed0dc24c3 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -2421,6 +2421,9 @@ void vchiq_msg_queue_push(unsigned int handle, struct vchiq_header *header)
 	struct vchiq_service *service = find_service_by_handle(handle);
 	int pos;
 
+	if (!service)
+		return;
+
 	while (service->msg_queue_write == service->msg_queue_read +
 		VCHIQ_MAX_SLOTS) {
 		if (wait_for_completion_interruptible(&service->msg_queue_pop))
@@ -2441,6 +2444,9 @@ struct vchiq_header *vchiq_msg_hold(unsigned int handle)
 	struct vchiq_header *header;
 	int pos;
 
+	if (!service)
+		return NULL;
+
 	if (service->msg_queue_write == service->msg_queue_read)
 		return NULL;
 
-- 
2.35.1



