Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64926A72B8
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCASIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCASIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:08:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C912A1FF8
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64AEA6145E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7577AC433D2;
        Wed,  1 Mar 2023 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694117;
        bh=GmD07JxGdVvvL2XK94q95n4ECoumdI7zUO39+WOxRlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efyhULbYmqLHUqTpsvd8iZaNaBXMhPhrKaJrvnUJaLsT+7G33QYV7nHb+nijVbeqQ
         EGqOFA51H0BnW3gL4NCCglqbSc80lviqxtpv5qqCvqnAocipNLbI6CgJLGLNeBnWEH
         cei5L2CH42JQvKoqpWVnew3JsRRjQOlXrSYkUk80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Zhao <xnzhao@google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/13] HID: core: Fix deadloop in hid_apply_multiplier.
Date:   Wed,  1 Mar 2023 19:07:30 +0100
Message-Id: <20230301180651.418067715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
References: <20230301180651.177668495@linuxfoundation.org>
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

From: Xin Zhao <xnzhao@google.com>

[ Upstream commit ea427a222d8bdf2bc1a8a6da3ebe247f7dced70c ]

The initial value of hid->collection[].parent_idx if 0. When
Report descriptor doesn't contain "HID Collection", the value
remains as 0.

In the meanwhile, when the Report descriptor fullfill
all following conditions, it will trigger hid_apply_multiplier
function call.
1. Usage page is Generic Desktop Ctrls (0x01)
2. Usage is RESOLUTION_MULTIPLIER (0x48)
3. Contain any FEATURE items

The while loop in hid_apply_multiplier will search the top-most
collection by searching parent_idx == -1. Because all parent_idx
is 0. The loop will run forever.

There is a Report Descriptor triggerring the deadloop
0x05, 0x01,        // Usage Page (Generic Desktop Ctrls)
0x09, 0x48,        // Usage (0x48)
0x95, 0x01,        // Report Count (1)
0x75, 0x08,        // Report Size (8)
0xB1, 0x01,        // Feature

Signed-off-by: Xin Zhao <xnzhao@google.com>
Link: https://lore.kernel.org/r/20230130212947.1315941-1-xnzhao@google.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2888bd5502f3f..0c8075d9717cb 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1190,6 +1190,7 @@ int hid_open_report(struct hid_device *device)
 	__u8 *end;
 	__u8 *next;
 	int ret;
+	int i;
 	static int (*dispatch_type[])(struct hid_parser *parser,
 				      struct hid_item *item) = {
 		hid_parser_main,
@@ -1240,6 +1241,8 @@ int hid_open_report(struct hid_device *device)
 		goto err;
 	}
 	device->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
+	for (i = 0; i < HID_DEFAULT_NUM_COLLECTIONS; i++)
+		device->collection[i].parent_idx = -1;
 
 	ret = -EINVAL;
 	while ((next = fetch_item(start, end, &item)) != NULL) {
-- 
2.39.0



