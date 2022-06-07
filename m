Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8785F540B4E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350667AbiFGS1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352093AbiFGSQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169BFD110;
        Tue,  7 Jun 2022 10:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BDF6616A3;
        Tue,  7 Jun 2022 17:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAACFC34119;
        Tue,  7 Jun 2022 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624229;
        bh=uR7CQe4V55FxsHzDZ0qleDY1nvIx7lIoX7D3hsclkWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kP/Vq8LiuRq1IO9bMnesam9anPQZt6Qcix7OCGhnqWbLnZsjCu9rztmKHjDe0TCDE
         OVJkDhDfp/22dju6CF8rhL7axWl1y77gFtSc1XDciMcowjp8OiUPdJp6/fO20JrNvb
         c7PIZcR2t+EbuowwI1FJ3qBIiMuwTNEYHspTJO71YjNKscLszPRZeqX6EcNLr5E5JT
         U8WKaTY2Vq5LWAR+ZKx5PzEx4Fo74WiaBnT37k/IANLpqzgEoZHobc8EsyuzIbJOBw
         D+BvMsG7IgkBwrUQ5kVzcBH+8Z1gJFOt8Oc0kHbhWAckutv4s1aCrILOvf1a5/tFcm
         vIlBamuJE/UbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.18 23/68] misc: rtsx: set NULL intfdata when probe fails
Date:   Tue,  7 Jun 2022 13:47:49 -0400
Message-Id: <20220607174846.477972-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

