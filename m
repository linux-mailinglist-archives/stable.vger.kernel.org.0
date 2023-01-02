Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D56565B0CA
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjABL2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbjABL1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:27:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BDF6364
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88ECDB80D15
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEAEC433EF;
        Mon,  2 Jan 2023 11:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658797;
        bh=/3wnFo0UrdVoMtBPjWnxF8rHsHAMOwFok+VQ/C03w6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sr7Cnt/TyJDgMsdY+ELagv7cDKYubj9vO9L7KzBEzFMG7Yko+BG764s0rWSEZwcKO
         p2T2i0XudEUYA5GcRHR/xV2n93WozdZ0Hjk7UGPyMAdD35ctCbpYW8jk86SOeH5AP3
         CfsV2LpHguLcs7Me8wUSkTeVdtLC0apKsmVrEhZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 46/71] kmsan: export kmsan_handle_urb
Date:   Mon,  2 Jan 2023 12:22:11 +0100
Message-Id: <20230102110553.422799334@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 7ba594d700998bafa96a75360d2e060aa39156d2 upstream.

USB support can be in a loadable module, and this causes a link failure
with KMSAN:

ERROR: modpost: "kmsan_handle_urb" [drivers/usb/core/usbcore.ko] undefined!

Export the symbol so it can be used by this module.

Link: https://lkml.kernel.org/r/20221215162710.3802378-1-arnd@kernel.org
Fixes: 553a80188a5d ("kmsan: handle memory sent to/from USB")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmsan/hooks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 35f6b6e6a908..3807502766a3 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -260,6 +260,7 @@ void kmsan_handle_urb(const struct urb *urb, bool is_out)
 					       urb->transfer_buffer_length,
 					       /*checked*/ false);
 }
+EXPORT_SYMBOL_GPL(kmsan_handle_urb);
 
 static void kmsan_handle_dma_page(const void *addr, size_t size,
 				  enum dma_data_direction dir)
-- 
2.39.0



