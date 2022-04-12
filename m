Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A44D4FD917
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbiDLHa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353382AbiDLHZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86664EA10;
        Tue, 12 Apr 2022 00:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BE0A615BB;
        Tue, 12 Apr 2022 07:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D2DC385A8;
        Tue, 12 Apr 2022 07:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746827;
        bh=2kkz2HUea5hGrLe3sIdjMljDa9VPFb9vQcDZSKUWuuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkhJXI98ZD6v4v/OVCJlq6VW/I7u2vAVNqYZ/9NQFI1IXAfiSNqI5bCONhxECQCo/
         kjRvD2Bq1cn9nccmcbnLWUPzFuNhK+//JRdjXwq9dB1F4FAWkJbDBOKP7Fp0hP9FTO
         RZOzDT3icuh9dndn1F2FPrdFX5C+YND9lTyz9qJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 117/285] staging: vchiq_core: handle NULL result of find_service_by_handle
Date:   Tue, 12 Apr 2022 08:29:34 +0200
Message-Id: <20220412062947.043429848@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
index 7fe20d4b7ba2..b7295236671c 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -2306,6 +2306,9 @@ void vchiq_msg_queue_push(unsigned int handle, struct vchiq_header *header)
 	struct vchiq_service *service = find_service_by_handle(handle);
 	int pos;
 
+	if (!service)
+		return;
+
 	while (service->msg_queue_write == service->msg_queue_read +
 		VCHIQ_MAX_SLOTS) {
 		if (wait_for_completion_interruptible(&service->msg_queue_pop))
@@ -2326,6 +2329,9 @@ struct vchiq_header *vchiq_msg_hold(unsigned int handle)
 	struct vchiq_header *header;
 	int pos;
 
+	if (!service)
+		return NULL;
+
 	if (service->msg_queue_write == service->msg_queue_read)
 		return NULL;
 
-- 
2.35.1



