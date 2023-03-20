Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AEE6C12C4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjCTNJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjCTNJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:09:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31117BDF5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA65DB80DD3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDEEC433D2;
        Mon, 20 Mar 2023 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679317771;
        bh=7B3qRcTjumQDLkls6mq+fbRzckajF3H35IG9NvnQmHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+Yu03AHyd3LkhiJ3MvzW2rYBTbQ9Lw3StmQdr4tx5RlgAranYX5TTJzmh1TyYR1g
         WzCEZW2cqz7N9KVmMPpArD9Iu8SQ09CgtepZFMPfUMSFCZxypNoiQf4T9W90q3CWnE
         Spuqr6f3TRyckc3Q2WCQMcNnkXgOLAQ7qSJfKnOE1Guw79Fdk7KWb3K6YjTUA2fO7k
         AYIsH4zk+SsM8L5KUha26jrUrGbSXUmwrhKJvWaZ65kLJRbM7pp6aX6prmIVqC2Pr/
         YoKHJuYirDklS8z4SqlUk+4TAipxSYsGVPucOGeqKDxbXXiCUeXGgKI67cDFyNDWXb
         VM9eNdW3ukQHQ==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4.14.y 2/2] HID: uhid: Over-ride the default maximum data buffer value with our own
Date:   Mon, 20 Mar 2023 13:09:23 +0000
Message-Id: <20230320130923.2771901-2-lee@kernel.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230320130923.2771901-1-lee@kernel.org>
References: <20230320130923.2771901-1-lee@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 333b6a769189c..b7efc5c055be1 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -399,6 +399,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

