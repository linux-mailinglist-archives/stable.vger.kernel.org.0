Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BBE535CF7
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343996AbiE0JBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351005AbiE0JA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF4312E303;
        Fri, 27 May 2022 01:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D06A561D95;
        Fri, 27 May 2022 08:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9224FC385A9;
        Fri, 27 May 2022 08:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641861;
        bh=990WoEyuRRvfbwVuvkDYqR86oUyJ+h0thqUuANnC+6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1tLBaVkQtVrmHS4uLFZ5GdUAP8q/zvrbCtdXo2BGIRkypkM/QSZZZG+YqEGwhGTy
         hw419BVpuZThnSgvpyQvzKQ6HcMSr0fz0RCz7ebJq/Szt5UQMgVKGMOSQw5OjVY/79
         RjadzNWjl9C9pHMJyhFK7+ZvIPc1huL/h2uN1DHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Shaw <jeffrey.b.shaw@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH 5.15 003/145] [PATCH 5.15] ice: fix crash at allocation failure
Date:   Fri, 27 May 2022 10:48:24 +0200
Message-Id: <20220527084850.902754615@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a crash in the zero-copy driver that occurs when it fails to
allocate buffers from user-space. This crash can easily be triggered
by a malicious program that does not provide any buffers in the fill
ring for the kernel to use.

Note that this bug does not exist in upstream since the batched buffer
allocation interface got introduced in 5.16 and replaced this code.

Reported-by: Jeff Shaw <jeffrey.b.shaw@intel.com>
Tested-by: Jeff Shaw <jeffrey.b.shaw@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -378,7 +378,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_rin
 
 	do {
 		*xdp = xsk_buff_alloc(rx_ring->xsk_pool);
-		if (!xdp) {
+		if (!*xdp) {
 			ok = false;
 			break;
 		}


