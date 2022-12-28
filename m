Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D143657F2B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiL1QCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiL1QCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:02:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8C818B01
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:01:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6043CB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D2BC433EF;
        Wed, 28 Dec 2022 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243311;
        bh=R4gQcd54zViSqX2zeZDQROWJxHqKtI64XzrtpnNjliw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzzVcO3kt5yEkBrBBI9s7JrJLtTR+8YPLuQmbVv5iXUN4LHKZ/Y2NaBq1RUmQu8bW
         Imr9unuil7LzgMeZSyAiez8zkJscrXUbLGWJl4+Cb6qblTaFoyM548lpQcYOgD+0hv
         QZ0/+baYhU/7ClOMr4tzd/vpKD+45Gtz1MWWv3eY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.15 707/731] usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq
Date:   Wed, 28 Dec 2022 15:43:34 +0100
Message-Id: <20221228144316.948225991@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 03a88b0bafbe3f548729d970d8366f48718c9b19 upstream.

Can not set the @shared_hcd to NULL before decrease the usage count
by usb_put_hcd(), this will cause the shared hcd not released.

Fixes: 04284eb74e0c ("usb: xhci-mtk: add support runtime PM")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20221128063337.18124-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -619,7 +619,6 @@ static int xhci_mtk_probe(struct platfor
 
 dealloc_usb3_hcd:
 	usb_remove_hcd(xhci->shared_hcd);
-	xhci->shared_hcd = NULL;
 
 dealloc_usb2_hcd:
 	usb_remove_hcd(hcd);


