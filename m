Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9251A9C4
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357299AbiEDRT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357862AbiEDRPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87159554B2;
        Wed,  4 May 2022 09:59:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E9AD6191D;
        Wed,  4 May 2022 16:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983EAC385AF;
        Wed,  4 May 2022 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683544;
        bh=7cNWoDllzlhlhBT0AEDDuXRENPZ9G9LkpZELR4gvMbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ0hpDz3wLHlt2MIen9ABqHWNAbGS9mPDcFFjTLE7V59ndso2UsT4F/WUPTcLsLRq
         t+jYXHjbLJbYFVNt7fzuKlIEnv1r7gIHVgOZfK3Ub2SkQvh6MjhRaEUUpohXCBR7Ac
         zrEnCw+oByu6DY+zmMguLRjBzuWiMOfY7YahxAkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 215/225] tty: n_gsm: fix missing tty wakeup in convergence layer type 2
Date:   Wed,  4 May 2022 18:47:33 +0200
Message-Id: <20220504153129.137505333@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Daniel Starke <daniel.starke@siemens.com>

commit 1adf6fee58ca25fb6720b8d34c919dcf5425cc9c upstream.

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
---
 drivers/tty/n_gsm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1615,6 +1615,7 @@ static void gsm_dlci_data(struct gsm_dlc
 		tty = tty_port_tty_get(port);
 		if (tty) {
 			gsm_process_modem(tty, dlci, modem, slen);
+			tty_wakeup(tty);
 			tty_kref_put(tty);
 		}
 		fallthrough;


