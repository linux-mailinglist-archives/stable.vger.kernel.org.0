Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78CD64A19B
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiLLNnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiLLNmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:42:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C4E13E9A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:41:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C95E4B80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81C7C433EF;
        Mon, 12 Dec 2022 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852501;
        bh=B02Xl/Vk+ZCvOu6JD5ou0WLDErMGsFL62UNRQOE5/bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBE9ExHgJpCpAbb2t/W7MBzUoOpKekVHALBH4zFQ2getlJ00qbdNZu4aE0Ef4bMSh
         ELNgpxtelmEOYjbsmRZK6Rt98OCMyJKIF6SYkO+rtK97OsoONh5vu6M+20TpI8EbZt
         YXo6HC8xs4OAUuYKnWxXolwcWP8O/evxwRlQDI0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.0 067/157] HID: uclogic: Fix frame templates for big endian architectures
Date:   Mon, 12 Dec 2022 14:16:55 +0100
Message-Id: <20221212130937.283092000@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: José Expósito <jose.exposito89@gmail.com>

commit a6f4f1662711bd03308371d9649783a5be596898 upstream.

When parsing a frame template with a placeholder indicating the number
of buttons present on the frame its value was incorrectly set on big
endian architectures due to double little endian conversion.

In order to reproduce the issue and verify the fix, run the HID KUnit
tests on the PowerPC architecture:

  $ ./tools/testing/kunit/kunit.py run --kunitconfig=drivers/hid \
    --arch=powerpc --cross_compile=powerpc64-linux-gnu-

Fixes: 867c89254425 ("HID: uclogic: Allow to generate frame templates")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-uclogic-rdesc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-uclogic-rdesc.c
+++ b/drivers/hid/hid-uclogic-rdesc.c
@@ -1119,7 +1119,7 @@ __u8 *uclogic_rdesc_template_apply(const
 			   p[sizeof(btn_head)] < param_num) {
 			v = param_list[p[sizeof(btn_head)]];
 			put_unaligned((__u8)0x2A, p); /* Usage Maximum */
-			put_unaligned_le16((__force u16)cpu_to_le16(v), p + 1);
+			put_unaligned((__force u16)cpu_to_le16(v), (s16 *)(p + 1));
 			p += sizeof(btn_head) + 1;
 		} else {
 			p++;


