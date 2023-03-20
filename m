Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A835F6C12C6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjCTNKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjCTNKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F07F940
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:10:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA704614B7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1E0C4339B;
        Mon, 20 Mar 2023 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679317806;
        bh=4rYgkxH8BJV5bVVdjI7x23fvRfhzItRe0BnhZEr0R+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6Bdr7wj6KQqktCvaRXfYIzaPIZ+LXdFn4lVRyYERnG5izF1uIkfXQwLZf41FABAl
         7Y0XiddKCQATBN5/fWgdYohE74aiIyjOBdYxok0nF84yNLGi12esvw/oLKFm6M1taU
         bdq2NOeeHl/tBDOyEIFVTeTNSRGDPcCi/DhjZOfqHhTXBG6l/Ybt0X6MvnpzWoYk0l
         VUoEgKOnD4mywUj5U6YZxc4xdL+wXwRemIGzJpNYuGbY/byQG5duWFdN3lq1SJGd+I
         XudWYuKpvxrTTbwV+ueOa1GTc+lBBYLi1z8FIShyiW4ch0J9s9Oua4l+L2fMJP0fMf
         Evo1xkW9zwvqg==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4.9.y 2/2] HID: uhid: Over-ride the default maximum data buffer value with our own
Date:   Mon, 20 Mar 2023 13:09:57 +0000
Message-Id: <20230320130957.2772257-2-lee@kernel.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230320130957.2772257-1-lee@kernel.org>
References: <20230320130957.2772257-1-lee@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1c5d4221240a233df2440fe75c881465cdf8da07 upstream.

The default maximum data buffer size for this interface is UHID_DATA_MAX
(4k).  When data buffers are being processed, ensure this value is used
when ensuring the sanity, rather than a value between the user provided
value and HID_MAX_BUFFER_SIZE (16k).

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/hid/uhid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index f7705a057f0f4..ff13dbbdf675b 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -400,6 +400,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

