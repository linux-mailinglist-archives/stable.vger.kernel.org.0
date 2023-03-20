Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3FD6C164B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjCTPEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjCTPEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:04:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAD52917D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C3FEB80ECC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB21C433EF;
        Mon, 20 Mar 2023 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324383;
        bh=zRzH58ejUhK6wY3BxAR+pEpxct2xpD07IXcjBjoBI1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZVTuFNjug/1yrzn5YN1p9LXNg3IpBlQfSMonqLDeTwoDiGBhg5NgRZmyNsEmzonF
         XjDC1n9vsw57kB+Dilg/7xzAMzQkwBBdmup9eOUaZpvwvM9HYirqXe/8/AZ693XDFc
         ZnJEU5z+BpZxEo6BJl5e2jIB0Wczm3VwUsuhaUck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, lee@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 36/36] HID: uhid: Over-ride the default maximum data buffer value with our own
Date:   Mon, 20 Mar 2023 15:55:02 +0100
Message-Id: <20230320145425.591476278@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lee Jones <lee@kernel.org>

commit 1c5d4221240a233df2440fe75c881465cdf8da07 upstream.

The default maximum data buffer size for this interface is UHID_DATA_MAX
(4k).  When data buffers are being processed, ensure this value is used
when ensuring the sanity, rather than a value between the user provided
value and HID_MAX_BUFFER_SIZE (16k).

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/uhid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -398,6 +398,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 


