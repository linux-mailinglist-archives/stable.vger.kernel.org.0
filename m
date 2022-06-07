Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0805405F0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346614AbiFGRcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346711AbiFGR3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:29:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B02311803A;
        Tue,  7 Jun 2022 10:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89D1660906;
        Tue,  7 Jun 2022 17:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DADC34119;
        Tue,  7 Jun 2022 17:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622695;
        bh=T4cvfR4WHCduCcFXKo/nqm80YevLxO60ECFJam+FNdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7rszaoOVFl0Nq+5h9t0aUpRbZ9OjA9aYRvf5YAv2AQJnAvZT+Mz+WioWWOfx3W7f
         DyTq9t5fDkMrKJ7ld6eAS2g+WdZH57RemL8n2u3sQN/LnebTOzxQU+vPLILAASQ9Jb
         etWO5yd+Ah+oA+X1Z4PLRAo5Ut6jkOH+Vazxgh2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/452] HID: elan: Fix potential double free in elan_input_configured
Date:   Tue,  7 Jun 2022 19:00:07 +0200
Message-Id: <20220607164913.027375559@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 1af20714fedad238362571620be0bd690ded05b6 ]

'input' is a managed resource allocated with devm_input_allocate_device(),
so there is no need to call input_free_device() explicitly or
there will be a double free.

According to the doc of devm_input_allocate_device():
 * Managed input devices do not need to be explicitly unregistered or
 * freed as it will be done automatically when owner device unbinds from
 * its driver (or binding fails).

Fixes: b7429ea53d6c ("HID: elan: Fix memleak in elan_input_configured")
Fixes: 9a6a4193d65b ("HID: Add driver for USB ELAN Touchpad")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/hid/hid-elan.c b/drivers/hid/hid-elan.c
index 0e8f424025fe..838673303f77 100644
--- a/drivers/hid/hid-elan.c
+++ b/drivers/hid/hid-elan.c
@@ -188,7 +188,6 @@ static int elan_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	ret = input_mt_init_slots(input, ELAN_MAX_FINGERS, INPUT_MT_POINTER);
 	if (ret) {
 		hid_err(hdev, "Failed to init elan MT slots: %d\n", ret);
-		input_free_device(input);
 		return ret;
 	}
 
@@ -200,7 +199,6 @@ static int elan_input_configured(struct hid_device *hdev, struct hid_input *hi)
 		hid_err(hdev, "Failed to register elan input device: %d\n",
 			ret);
 		input_mt_destroy_slots(input);
-		input_free_device(input);
 		return ret;
 	}
 
-- 
2.35.1



