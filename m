Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C2A528E51
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345778AbiEPTmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345610AbiEPTkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798823ED32;
        Mon, 16 May 2022 12:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3A69614E2;
        Mon, 16 May 2022 19:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2423C385AA;
        Mon, 16 May 2022 19:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652729971;
        bh=+FAQbdGywGv1W7IEFqKFXTkIpVgAa5LatXhgDD2GBp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN6aXVepJOHKIVUAIU5M3YR3CeCJmRWy5RqlYyKPRReMaW1KntUEbb4Ulo0BuAP8i
         BDhNI/Q/3+w70xY91AN8V98fihFLGp9KDV6PxEv108500azxgyOtFBy8QtqJCU1NRc
         OCIsIvUQFWFXcvck9jWKK47EWMjPZ/13cq6bBkfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 17/25] usb: cdc-wdm: fix reading stuck on device close
Date:   Mon, 16 May 2022 21:36:31 +0200
Message-Id: <20220516193615.204377503@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.678319286@linuxfoundation.org>
References: <20220516193614.678319286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Ryazanov <ryazanov.s.a@gmail.com>

commit 01e01f5c89773c600a9f0b32c888de0146066c3a upstream.

cdc-wdm tracks whether a response reading request is in-progress and
blocks the next request from being sent until the previous request is
completed. As soon as last user closes the cdc-wdm device file, the
driver cancels any ongoing requests, resets the pending response
counter, but leaves the response reading in-progress flag
(WDM_RESPONDING) untouched.

So if the user closes the device file during the response receive
request is being performed, no more data will be obtained from the
modem. The request will be cancelled, effectively preventing the
WDM_RESPONDING flag from being reseted. Keeping the flag set will
prevent a new response receive request from being sent, permanently
blocking the read path. The read path will staying blocked until the
module will be reloaded or till the modem will be re-attached.

This stuck has been observed with a Huawei E3372 modem attached to an
OpenWrt router and using the comgt utility to set up a network
connection.

Fix this issue by clearing the WDM_RESPONDING flag on the device file
close.

Without this fix, the device reading stuck can be easily reproduced in a
few connection establishing attempts. With this fix, a load test for
modem connection re-establishing worked for several hours without any
issues.

Fixes: 922a5eadd5a3 ("usb: cdc-wdm: Fix race between autosuspend and reading from the device")
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20220501175828.8185-1-ryazanov.s.a@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -731,6 +731,7 @@ static int wdm_release(struct inode *ino
 			kill_urbs(desc);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
+			clear_bit(WDM_RESPONDING, &desc->flags);
 			spin_unlock_irq(&desc->iuspin);
 			desc->manage_power(desc->intf, 0);
 		} else {


