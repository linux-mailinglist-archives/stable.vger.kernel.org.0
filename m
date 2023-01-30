Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8996810CD
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbjA3OGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbjA3OGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133DB3B3E7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A366961026
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92519C433D2;
        Mon, 30 Jan 2023 14:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087611;
        bh=+FQvQmuigkcGR+nhVTKxVpb8x5WZV8/RnEqeRuUJoqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiC3aXmf2XuIVkTIqQo82u66V1XKJjd2LSNnUrow6LRIt8NzFHoqfG4FMvVDw14qI
         MJxOPX3cY1o+d/ZljgY2hz+SxtjRrJypbMvELX1hHnPdPpTIoFhEVfeRvfS2B9sTHH
         c5G4nNO0DUTM1JLnif16HXZ7lNrzff/XY/tAkwPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Graham Sider <graham.sider@amd.com>,
        Jonathan Kim <jonathan.kim@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 236/313] drm/amdgpu: remove unconditional trap enable on add gfx11 queues
Date:   Mon, 30 Jan 2023 14:51:11 +0100
Message-Id: <20230130134347.671849116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Jonathan Kim <jonathan.kim@amd.com>

commit 2de3769830346e68b3de0f4abc0d8e2625ad9dac upstream.

Rebase of driver has incorrect unconditional trap enablement
for GFX11 when adding mes queues.

Reported-by: Graham Sider <graham.sider@amd.com>
Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Graham Sider <graham.sider@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -192,7 +192,6 @@ static int mes_v11_0_add_hw_queue(struct
 	mes_add_queue_pkt.trap_handler_addr = input->tba_addr;
 	mes_add_queue_pkt.tma_addr = input->tma_addr;
 	mes_add_queue_pkt.is_kfd_process = input->is_kfd_process;
-	mes_add_queue_pkt.trap_en = 1;
 
 	/* For KFD, gds_size is re-used for queue size (needed in MES for AQL queues) */
 	mes_add_queue_pkt.is_aql_queue = input->is_aql_queue;


