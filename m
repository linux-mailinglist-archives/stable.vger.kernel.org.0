Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AAD649FF2
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiLLNRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiLLNQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:16:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780C012A99
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:16:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20B2CB80D38
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D1FC433EF;
        Mon, 12 Dec 2022 13:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850995;
        bh=sO1ed7ZnBP7kTwzCaWyFndvh/VR+YDPGV8JfbbOd36I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viHCjguyIWvKWv3f6BTeSAQPXwhuXsJQsvtkuOapLwFDunhz57pp6GhkutWs87C7q
         yDBKMuP8Na027+CSbCxOv1a1PCCIXDzYFLG8MPNt2QGT/oXEPMZLatPxfUdePYXIeB
         APLNZTiLkex8cTJMidWMbn0RpJoyP4D9btrxUppM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anastasia Belova <abelova@astralinux.ru>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 057/106] HID: hid-lg4ff: Add check for empty lbuf
Date:   Mon, 12 Dec 2022 14:10:00 +0100
Message-Id: <20221212130927.371713370@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Anastasia Belova <abelova@astralinux.ru>

commit d180b6496143cd360c5d5f58ae4b9a8229c1f344 upstream.

If an empty buf is received, lbuf is also empty. So lbuf is
accessed by index -1.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: f31a2de3fe36 ("HID: hid-lg4ff: Allow switching of Logitech gaming wheels between compatibility modes")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lg4ff.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -872,6 +872,12 @@ static ssize_t lg4ff_alternate_modes_sto
 		return -ENOMEM;
 
 	i = strlen(lbuf);
+
+	if (i == 0) {
+		kfree(lbuf);
+		return -EINVAL;
+	}
+
 	if (lbuf[i-1] == '\n') {
 		if (i == 1) {
 			kfree(lbuf);


