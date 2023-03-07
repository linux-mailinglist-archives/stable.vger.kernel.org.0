Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BDB6AF484
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjCGTRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbjCGTQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D54BAEC0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3B09B819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239D9C433D2;
        Tue,  7 Mar 2023 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215613;
        bh=DMHfgvn16lsUelSb+tjsuqRW5hv8aZv8AokspayJkVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4IEcbXLRbhXSNRHcgxo8lnKfUUNDL7oqz1xOfDNd/J1bUjTjLVtGoupan9G7aY0O
         cARX1dXCKutyAnP8e6qRNhJcLL9PDDPOFVfRv8udIFHffemTUfqpFbg0Ms1L0A717c
         gOjMhxnzxYFKQEDNc5OWfcVctXtT2TtUqmndPfe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jack Pham <quic_jackp@quicinc.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/567] usb: gadget: configfs: use to_config_usb_cfg() in os_desc_link()
Date:   Tue,  7 Mar 2023 18:00:54 +0100
Message-Id: <20230307165919.653061942@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <quic_linyyuan@quicinc.com>

[ Upstream commit 5d143ec451429891385a21617b292f2ceaa684ea ]

replace open-coded container_of() with to_config_usb_cfg() helper.

Reviewed-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1637211213-16400-4-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 89e7252d6c7e ("usb: gadget: configfs: Restrict symlink creation is UDC already binded")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 5ade844db4046..7d3b93dc154fe 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -890,9 +890,7 @@ static int os_desc_link(struct config_item *os_desc_ci,
 	struct gadget_info *gi = container_of(to_config_group(os_desc_ci),
 					struct gadget_info, os_desc_group);
 	struct usb_composite_dev *cdev = &gi->cdev;
-	struct config_usb_cfg *c_target =
-		container_of(to_config_group(usb_cfg_ci),
-			     struct config_usb_cfg, group);
+	struct config_usb_cfg *c_target = to_config_usb_cfg(usb_cfg_ci);
 	struct usb_configuration *c;
 	int ret;
 
-- 
2.39.2



