Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFF9527EF0
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 09:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241449AbiEPH4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 03:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241378AbiEPH4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 03:56:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4CDB33
        for <stable@vger.kernel.org>; Mon, 16 May 2022 00:56:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0FA96117F
        for <stable@vger.kernel.org>; Mon, 16 May 2022 07:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21A1C385AA;
        Mon, 16 May 2022 07:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652687760;
        bh=87QH2OLQtcc98z3dYbqS8EDBhUJsl8o8Euu1GFNWZFc=;
        h=Subject:To:Cc:From:Date:From;
        b=PgmfksMLnyA7/NxBZ2t05zovAFuJlqnR8J6nCaP73Kf/Myp1KCd+qZwNFiZlqKTQQ
         U/zCnU7rDxhLwqLGWatw42CdRkRB6MyxOHkYLHp+y+0JVsVCJTNHFU9yw/xYUCrQFT
         CwcifuYKMYd1wuN/vTL0j6MGZAVFh93MnK2qgESs=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix buffer over-read in gsm_dlci_data()" failed to apply to 5.10-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 09:55:57 +0200
Message-ID: <1652687757127212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fd442e5ba30aaa75ea47b32149e7a3110dc20a46 Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Wed, 4 May 2022 10:17:31 +0200
Subject: [PATCH] tty: n_gsm: fix buffer over-read in gsm_dlci_data()

'len' is decreased after each octet that has its EA bit set to 0, which
means that the value is encoded with additional octets. However, the final
octet does not decreases 'len' which results in 'len' being one byte too
long. A buffer over-read may occur in tty_insert_flip_string() as it tries
to read one byte more than the passed content size of 'data'.
Decrease 'len' also for the final octet which has the EA bit set to 1 to
write the correct number of bytes from the internal receive buffer to the
virtual tty.

Fixes: 2e124b4a390c ("TTY: switch tty_flip_buffer_push")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220504081733.3494-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index a38b922bcbc1..9b0b435cf26e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1658,6 +1658,7 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 			if (len == 0)
 				return;
 		}
+		len--;
 		slen++;
 		tty = tty_port_tty_get(port);
 		if (tty) {

