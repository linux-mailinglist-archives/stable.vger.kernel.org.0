Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605396C12BE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCTNHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjCTNHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8631E9DC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A969614E1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B9DC433D2;
        Mon, 20 Mar 2023 13:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679317669;
        bh=p2pewpzcztSUrqiSKmn1uWH3cobl4oMrZjoO8haPdpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBGTSauEaneDeDz6ukRgQ2tZhlYsiDs5AYyxlIjhG95PVFMDUm+YaPNoVGYD6s9YS
         9ak5tNbzXqzVnP49aXLQirS7W5EpxjyCJNWR2fo40N4ikrhvqVc75RXVlzbpiG5Qdf
         YE+M0L/kA2AmvnqKzL/AsPoduLZDzyxtnPNxurtgqa/3yrBPQT5UXcPya+FJXzZ0mP
         ouLNny8SPttz8XeJqaL1WKPbUTCn0PotFo/H3OAsPCAaXDmR2cjg+4BtaDDQWd8uDI
         T9SpBgkM6JlAtGUYUSXZdfr1WbaWiHjhwvMV6jdS9JRD5ANZo5+ColowzNxRXysryG
         OQfJ70TXJHv+A==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5.4.y 2/2] HID: uhid: Over-ride the default maximum data buffer value with our own
Date:   Mon, 20 Mar 2023 13:07:41 +0000
Message-Id: <20230320130741.2770940-2-lee@kernel.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230320130741.2770940-1-lee@kernel.org>
References: <20230320130741.2770940-1-lee@kernel.org>
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

