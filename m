Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5E24FD04C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350556AbiDLGqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351152AbiDLGoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:44:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F88639816;
        Mon, 11 Apr 2022 23:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE440B81B43;
        Tue, 12 Apr 2022 06:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCD5C385A1;
        Tue, 12 Apr 2022 06:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745450;
        bh=RvVN9NGk7CZW5sgzfkl0x8gZdQ/3SrM078EXa4GD8tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPCdSudRQlyW9WWMwJ8TcXTzvzQK4ivv8uQJLNB7Yy9bKRw9+UTak1wsnJNA0MIFC
         DVid03Z67gW2ghnXS6l6Pkb8s8eIvck5L3MlumdN1vlg9tu8/LCxxsHMtPdSvFR/lQ
         aGHYVQ2us1drYZxZkT8rx7HwPIesExARUGCO7N7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/171] staging: vchiq_core: handle NULL result of find_service_by_handle
Date:   Tue, 12 Apr 2022 08:29:24 +0200
Message-Id: <20220412062929.996163715@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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
index 38b10fd5d992..95b91fe45cb3 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -2280,6 +2280,9 @@ void vchiq_msg_queue_push(unsigned int handle, struct vchiq_header *header)
 	struct vchiq_service *service = find_service_by_handle(handle);
 	int pos;
 
+	if (!service)
+		return;
+
 	while (service->msg_queue_write == service->msg_queue_read +
 		VCHIQ_MAX_SLOTS) {
 		if (wait_for_completion_interruptible(&service->msg_queue_pop))
@@ -2299,6 +2302,9 @@ struct vchiq_header *vchiq_msg_hold(unsigned int handle)
 	struct vchiq_header *header;
 	int pos;
 
+	if (!service)
+		return NULL;
+
 	if (service->msg_queue_write == service->msg_queue_read)
 		return NULL;
 
-- 
2.35.1



