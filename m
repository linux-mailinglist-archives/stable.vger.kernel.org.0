Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DA9548963
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351449AbiFMLGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351772AbiFMLFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:05:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995B827B2B;
        Mon, 13 Jun 2022 03:34:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38593B80E93;
        Mon, 13 Jun 2022 10:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92201C34114;
        Mon, 13 Jun 2022 10:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116440;
        bh=wsDuzAc9NqsM7BkZpBqt7GwC66dvPJnn9XcP8LB5P/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRyI+a76Q8YTSRlEH7SRXm0sgXtbnho/t0A0abbW5AFtxg4wB0I9Xmil443hbmhLU
         jTxTw07t+pqWEiT4tcjboxXeuht+7+KZvA37aw5cVakhxZoFKRe9pCqpEmE/fvzLRM
         rmUtP1FzDnh3W+TiGNh5mItZL6bBUWA6aocB4BK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 191/218] misc: rtsx: set NULL intfdata when probe fails
Date:   Mon, 13 Jun 2022 12:10:49 +0200
Message-Id: <20220613094926.410459080@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit f861d36e021e1ac4a0a2a1f6411d623809975d63 ]

rtsx_usb_probe() doesn't call usb_set_intfdata() to null out the
interface pointer when probe fails. This leaves a stale pointer.
Noticed the missing usb_set_intfdata() while debugging an unrelated
invalid DMA mapping problem.

Fix it with a call to usb_set_intfdata(..., NULL).

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220429210913.46804-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rtsx_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 691dab791f7a..e94f855eac15 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -678,6 +678,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	return 0;
 
 out_init_fail:
+	usb_set_intfdata(ucr->pusb_intf, NULL);
 	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
 			ucr->iobuf_dma);
 	return ret;
-- 
2.35.1



