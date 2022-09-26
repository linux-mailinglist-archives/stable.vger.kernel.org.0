Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE235EA16F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbiIZKu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiIZKts (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AFD5850A;
        Mon, 26 Sep 2022 03:27:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A12FA60B7E;
        Mon, 26 Sep 2022 10:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0CDC433D6;
        Mon, 26 Sep 2022 10:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188020;
        bh=ro6m7C/bg7snchqXrcsCCConBzeIdd6JQ1ZeDqS7cxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fg6B2fHZ+gLOiNotQ8Scn89K6KcuQcQYjgK+TVNGpIedVbVDA7icZSLQ8cA1TeLgL
         L8jcycZuhUJgLmWS9+smrXeEJrw5VX/ezeNmrOXRtzVBlKENc39R5EOElFs9vRt3Ed
         27/p7FrOAcWd8TCbtUeJ0Dy6pS8+Mulca69QOdMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/141] usb: xhci-mtk: use @sch_tt to check whether need do TT schedule
Date:   Mon, 26 Sep 2022 12:10:41 +0200
Message-Id: <20220926100755.128563143@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 4a56adf4fafbc41ceffce0c3f385f59d4fc3c16a ]

It's clearer to use @sch_tt to check whether need do TT schedule,
no function is changed.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/324a76782ccaf857a8f01f67aee435e8ec7d0e28.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 548011957d1d ("usb: xhci-mtk: relax TT periodic bandwidth allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index 59ba25ca018d..b1da3cb077c9 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -548,7 +548,7 @@ static int check_sch_bw(struct usb_device *udev,
 	min_num_budget = sch_ep->num_budget_microframes;
 	esit_boundary = get_esit_boundary(sch_ep);
 	for (offset = 0; offset < sch_ep->esit; offset++) {
-		if (is_fs_or_ls(udev->speed)) {
+		if (sch_ep->sch_tt) {
 			ret = check_sch_tt(udev, sch_ep, offset);
 			if (ret)
 				continue;
@@ -585,7 +585,7 @@ static int check_sch_bw(struct usb_device *udev,
 	sch_ep->cs_count = min_cs_count;
 	sch_ep->num_budget_microframes = min_num_budget;
 
-	if (is_fs_or_ls(udev->speed)) {
+	if (sch_ep->sch_tt) {
 		/* all offset for tt is not ok*/
 		if (!tt_offset_ok)
 			return -ERANGE;
-- 
2.35.1



