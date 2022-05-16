Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5016527EEF
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 09:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbiEPH4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 03:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241409AbiEPH4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 03:56:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E79B871
        for <stable@vger.kernel.org>; Mon, 16 May 2022 00:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7CD07CE0B39
        for <stable@vger.kernel.org>; Mon, 16 May 2022 07:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D3DC385B8;
        Mon, 16 May 2022 07:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652687776;
        bh=KIU9qozEo3r0hET0DG4/u1r1VuFLa70UhYmr97eyyUE=;
        h=Subject:To:Cc:From:Date:From;
        b=aEB9sotVcF2/3X2VBDzxD+qU9ytjLJQ3PmCWhUanokCfOd36xSz/gvoyfXUkd4Joj
         UOZbzuh2sYtb1td59Gj9IsU05QmbNzeyLNDOoQFb9fiWLW1So5DT/Sv+aPhdth37U0
         C3Fo8aCme9X+fQsPIaVn315HuypmIZo6sWPKWsO0=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix buffer over-read in gsm_dlci_data()" failed to apply to 4.9-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 09:56:10 +0200
Message-ID: <165268777022860@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
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

