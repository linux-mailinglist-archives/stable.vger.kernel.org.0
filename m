Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BE84D83D8
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241290AbiCNMV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242229AbiCNMSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3210A4738C;
        Mon, 14 Mar 2022 05:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD20B80DEB;
        Mon, 14 Mar 2022 12:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BB5C340E9;
        Mon, 14 Mar 2022 12:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260029;
        bh=0k+i8MwccnYAWINa3YTG6YsiQlyihAfbkrLxt8cV72Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZeTCE0c2NzW4CD/sG4bBVkkspXhWMVis6P6gcjmcW80DNeAyoDl18qf2A/Dp8hwp
         ApT2MLkjjh2G0+h/hs3jm5zumhxJI6vB5JfG7tekuqazkHWn5ATeLtpxxtyjPhVwcR
         fNXWQZ86N/7NG8BLuZjD5r4guh7Di2lk38MFv+cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 037/121] ice: Dont use GFP_KERNEL in atomic context
Date:   Mon, 14 Mar 2022 12:53:40 +0100
Message-Id: <20220314112745.165027147@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3d97f1afd8d831e0c0dc1157418f94b8faa97b54 ]

ice_misc_intr() is an irq handler. It should not sleep.

Use GFP_ATOMIC instead of GFP_KERNEL when allocating some memory.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index fc04b4cf4ae0..676e837d48cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3016,7 +3016,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		struct iidc_event *event;
 
 		ena_mask &= ~ICE_AUX_CRIT_ERR;
-		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		event = kzalloc(sizeof(*event), GFP_ATOMIC);
 		if (event) {
 			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
 			/* report the entire OICR value to AUX driver */
-- 
2.34.1



