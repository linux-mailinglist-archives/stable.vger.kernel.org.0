Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8F4658441
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiL1Q4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbiL1QzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:55:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03DF1F2CE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C56061568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D997C433D2;
        Wed, 28 Dec 2022 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246219;
        bh=mpxhm3WwiWR1yI6Z7dfSSCK3d/XpiW+WSTrFtijRPgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXeyCxOrQM2O0XmlQ+a9GhIHFye2SMrV0FEpwasCU9KWERREvQ5nJGK9973dM6OJi
         qXlRG/VOWc2cNFSijX1dAlhZiMWkdyqDrWBEo8iu0rQy6Kj70uSfeJZ3D7UU7+9Xle
         w9+/K82OC/MH1sXrU/EY0vh9v/FakAQYem5EIZkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 6.0 1033/1073] usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq
Date:   Wed, 28 Dec 2022 15:43:41 +0100
Message-Id: <20221228144356.250740190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
@@ -639,7 +639,6 @@ static int xhci_mtk_probe(struct platfor
 
 dealloc_usb3_hcd:
 	usb_remove_hcd(xhci->shared_hcd);
-	xhci->shared_hcd = NULL;
 
 dealloc_usb2_hcd:
 	usb_remove_hcd(hcd);


