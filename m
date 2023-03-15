Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192716BB2F3
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjCOMkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjCOMkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:40:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810498EA09
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E90CB81DF9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA24EC433D2;
        Wed, 15 Mar 2023 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883892;
        bh=XuyHaZuG0ru7yipTj0ogoYWBoD0KKQgXfqhXjejDRiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsKeGKkVR+x+M5kEpyr+UA2qrYG9eqm4j1irZe73GAA3gj1B1UaoIbJ7ct3Q5+NqV
         LdrDqlYRpttBwIN0kVpvEY3+au0ZGS8B5wj1/jHkasyRjhkfo215IoChtWEo/H6mXm
         V47ZbtuBNGs4kORpL2sNzQPYCDrxjxQrGhX6b7xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lee Jones <lee@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.2 027/141] HID: uhid: Over-ride the default maximum data buffer value with our own
Date:   Wed, 15 Mar 2023 13:12:10 +0100
Message-Id: <20230315115740.806122561@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/uhid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -395,6 +395,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 


