Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34B16C12A1
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjCTNFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjCTNFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F541517E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F0AB614DE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F168DC433A4;
        Mon, 20 Mar 2023 13:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679317546;
        bh=p2pewpzcztSUrqiSKmn1uWH3cobl4oMrZjoO8haPdpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMqZsaD45CA9RFfDypn/70hLc1etH7oLxtPnQG51vOehyirbKEnDoLftAgKPTNrUu
         F0L7CtZSumE8HOw6vcrDf+Uafg+mMDz4GhEU6xXFYvSCu/8SEuHjh83NWZcV3T5XvF
         hBjcjpNPXcbQ6rQD+bLJ7fqIuJbyCAi5oxmsrLNCNQ14zcdswtWwQ+XBllqgYRvXZS
         b1y50F5LhwbMo8TeYP1fei/rBA2FbHdARrKdHDt3NmwFwGydMbLhqRR7sR7o7//Tk2
         yFvLMLMC6AKhQNJeYz6bY+1fjQmS42KYi0DymNykqmJVtonNxUZL+aS2EOpgSzAHnz
         KtvmL6s7WvoIg==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5.15.y 2/2] HID: uhid: Over-ride the default maximum data buffer value with our own
Date:   Mon, 20 Mar 2023 13:05:35 +0000
Message-Id: <20230320130535.2769860-2-lee@kernel.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230320130535.2769860-1-lee@kernel.org>
References: <20230320130535.2769860-1-lee@kernel.org>
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
index fc06d8bb42e0f..ba0ca652b9dab 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -395,6 +395,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

