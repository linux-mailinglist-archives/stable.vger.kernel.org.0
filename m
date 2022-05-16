Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2239552901D
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiEPUE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348776AbiEPT64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:58:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BBE49F04;
        Mon, 16 May 2022 12:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B882B60A14;
        Mon, 16 May 2022 19:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19CBC34100;
        Mon, 16 May 2022 19:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730661;
        bh=GPeUlZ7dqcAiB0O1XvoRl8OE1TanIDmrxDmGkvO4ECk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3H4oeGmxchcgfJXeL3InNVo5eL6VATjXDBpejuUNTIcOdSpmhbuX+KWRKEItRSt8
         mjE2jES2mXLm9iW3crUCupbRjU/BEHQvcjjKjFjrtXQm/1sgizJStzPULGjqeof0gV
         cofkMfP+c2ahfAwgnK2JifU4HqB9hN0qCZUSfwDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 070/102] usb: cdc-wdm: fix reading stuck on device close
Date:   Mon, 16 May 2022 21:36:44 +0200
Message-Id: <20220516193626.005661571@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
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
@@ -774,6 +774,7 @@ static int wdm_release(struct inode *ino
 			poison_urbs(desc);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
+			clear_bit(WDM_RESPONDING, &desc->flags);
 			spin_unlock_irq(&desc->iuspin);
 			desc->manage_power(desc->intf, 0);
 			unpoison_urbs(desc);


