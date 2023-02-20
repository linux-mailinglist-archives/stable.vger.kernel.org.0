Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD62769CCD6
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjBTNn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjBTNnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:43:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01F71D92D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F7AE60CBA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758DEC4339E;
        Mon, 20 Feb 2023 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900631;
        bh=Gra5ErS4X0GNbZsEVC8ttmGP+ep9iw21Wvq0/qZPMaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogFKlcv7+lsOuxLF/ek66pK/U7KLoz2bg0c2YETA1zFut4q4BEKCoErQZEFTSXUbU
         A0JS8ypMuGkfxhxVMPgQJW/TM2MAgawIXgqjOEpmMhImSVmj0DoXM6rzJpIsdl6Zra
         VQExplpLMjsF+SXWxGrUKIZ6f0Tp0ofWiN7b5Itc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 001/156] firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region
Date:   Mon, 20 Feb 2023 14:34:05 +0100
Message-Id: <20230220133602.565463379@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 531390a243ef47448f8bad01c186c2787666bf4d upstream.

This patch is fix for Linux kernel v2.6.33 or later.

For request subaction to IEC 61883-1 FCP region, Linux FireWire subsystem
have had an issue of use-after-free. The subsystem allows multiple
user space listeners to the region, while data of the payload was likely
released before the listeners execute read(2) to access to it for copying
to user space.

The issue was fixed by a commit 281e20323ab7 ("firewire: core: fix
use-after-free regression in FCP handler"). The object of payload is
duplicated in kernel space for each listener. When the listener executes
ioctl(2) with FW_CDEV_IOC_SEND_RESPONSE request, the object is going to
be released.

However, it causes memory leak since the commit relies on call of
release_request() in drivers/firewire/core-cdev.c. Against the
expectation, the function is never called due to the design of
release_client_resource(). The function delegates release task
to caller when called with non-NULL fourth argument. The implementation
of ioctl_send_response() is the case. It should release the object
explicitly.

This commit fixes the bug.

Cc: <stable@vger.kernel.org>
Fixes: 281e20323ab7 ("firewire: core: fix use-after-free regression in FCP handler")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20230117090610.93792-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/core-cdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -818,8 +818,10 @@ static int ioctl_send_response(struct cl
 
 	r = container_of(resource, struct inbound_transaction_resource,
 			 resource);
-	if (is_fcp_request(r->request))
+	if (is_fcp_request(r->request)) {
+		kfree(r->data);
 		goto out;
+	}
 
 	if (a->length != fw_get_response_length(r->request)) {
 		ret = -EINVAL;


