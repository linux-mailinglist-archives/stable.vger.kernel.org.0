Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D052469CC27
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbjBTNhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjBTNhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:37:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3723A1A941
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:37:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D51CAB80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF54C433EF;
        Mon, 20 Feb 2023 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900252;
        bh=IOcoKcqYYvMeIQ7nWC+9Cm7lHhuFrtsr6IJcTloQWoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRdWvZ0h8DcJ+FQZ9sUdXm4rdws6gp1kFjMU1Wmkhoo0bTHD4g9EomGoqtdMv6gpL
         f3nLLPZ1jzTLPllJ6GeJ8rZj4tmZDQeTBmPuTZpTb2cKkCM6RIFWFKiSwzcT3ih2VW
         wYcoRRNnMChcmmegUNVgAg6pNb8Wg3o3DfMsRoTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 01/53] firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region
Date:   Mon, 20 Feb 2023 14:35:27 +0100
Message-Id: <20230220133548.227243389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -831,8 +831,10 @@ static int ioctl_send_response(struct cl
 
 	r = container_of(resource, struct inbound_transaction_resource,
 			 resource);
-	if (is_fcp_request(r->request))
+	if (is_fcp_request(r->request)) {
+		kfree(r->data);
 		goto out;
+	}
 
 	if (a->length != fw_get_response_length(r->request)) {
 		ret = -EINVAL;


