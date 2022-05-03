Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852225185A3
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbiECNkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235693AbiECNkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:40:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356892613C
        for <stable@vger.kernel.org>; Tue,  3 May 2022 06:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7A40B81EC8
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA23C385A9;
        Tue,  3 May 2022 13:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651585031;
        bh=4kuOKoU7rv8qXFkwcMSA0oECCM4BE+E/oVcSIXOkE80=;
        h=Subject:To:Cc:From:Date:From;
        b=ZKRxAOY9HcggLiRJORAY0Jqp2p7Q1ucI9XQnK3UxeLGLdl8SZxrn8yy3HwEiscVFJ
         0OOh9FzqkaQxPXLSGdvy6OWgp1oLEnyhjFi64Bn6H0Nxfd/I+kHuyCGjvBQ19kKORf
         Wy1TNFkDqBHJ+sK8SlL/oa0mNzGcJj8nKC6Tpsa0=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix missing tty wakeup in convergence layer type" failed to apply to 5.4-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 15:37:09 +0200
Message-ID: <1651585029138103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1adf6fee58ca25fb6720b8d34c919dcf5425cc9c Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Thu, 14 Apr 2022 02:42:19 -0700
Subject: [PATCH] tty: n_gsm: fix missing tty wakeup in convergence layer type
 2

gsm_control_modem() informs the virtual tty that more data can be written
after receiving a control signal octet via modem status command (MSC).
However, gsm_dlci_data() fails to do the same after receiving a control
signal octet from the convergence layer type 2 header.
Add tty_wakeup() in gsm_dlci_data() for convergence layer type 2 to fix
this.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-14-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 23418ee93156..f3fb66be8513 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1615,6 +1615,7 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 		tty = tty_port_tty_get(port);
 		if (tty) {
 			gsm_process_modem(tty, dlci, modem, slen);
+			tty_wakeup(tty);
 			tty_kref_put(tty);
 		}
 		fallthrough;

