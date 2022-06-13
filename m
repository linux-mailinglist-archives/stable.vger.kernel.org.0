Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B5054934B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353193AbiFMMmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358927AbiFMMkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:40:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43835F8FD;
        Mon, 13 Jun 2022 04:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C39E60B6E;
        Mon, 13 Jun 2022 11:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371F8C3411E;
        Mon, 13 Jun 2022 11:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118626;
        bh=uR7CQe4V55FxsHzDZ0qleDY1nvIx7lIoX7D3hsclkWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7DnexXb9FUUeNeAhkbJncb9t2X7p1au+lRly8WmTz99B55ITiNsxhfnctQhOCXwZ
         kO+m5i8ep3XXu7p4A6TNv0Vbk/3ojnn0VloMEcS7SBc8UsqrfU9Y956jT+DCmWEoDS
         glWW8p+Hv+waGZC+iFYkH42bhaRsGcjx111Ziex8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/172] misc: rtsx: set NULL intfdata when probe fails
Date:   Mon, 13 Jun 2022 12:11:27 +0200
Message-Id: <20220613094920.820490073@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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
 drivers/misc/cardreader/rtsx_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/cardreader/rtsx_usb.c b/drivers/misc/cardreader/rtsx_usb.c
index 59eda55d92a3..1ef9b61077c4 100644
--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -667,6 +667,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	return 0;
 
 out_init_fail:
+	usb_set_intfdata(ucr->pusb_intf, NULL);
 	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
 			ucr->iobuf_dma);
 	return ret;
-- 
2.35.1



