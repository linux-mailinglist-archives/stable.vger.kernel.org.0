Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC324C758A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbiB1RzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbiB1RyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6649197;
        Mon, 28 Feb 2022 09:42:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D9AF609EE;
        Mon, 28 Feb 2022 17:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FBBC340E7;
        Mon, 28 Feb 2022 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070140;
        bh=ThmOWQ9P4vhkVAIPX2uyg+wv57DOHbh0zPVKdFXk6w0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSlbWs7Kfiw6TLIpdprrqgIykifbjD1xa3/CGldwpyq0hMAW2I4dG43vdL/sWuPts
         R8uzfFfrwvjeeyRqTZTwoquITaodjsy9aVFsoBSKDFfRYxEzJvGy5MQfw2xRzIs2Mo
         MvixAIUQ8IinjlI5gHqKiIRDzBQQI75HO3KIUK2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.15 129/139] tty: n_gsm: fix proper link termination after failed open
Date:   Mon, 28 Feb 2022 18:25:03 +0100
Message-Id: <20220228172401.238529496@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: daniel.starke@siemens.com <daniel.starke@siemens.com>

commit e3b7468f082d106459e86e8dc6fb9bdd65553433 upstream.

Trying to open a DLCI by sending a SABM frame may fail with a timeout.
The link is closed on the initiator side without informing the responder
about this event. The responder assumes the link is open after sending a
UA frame to answer the SABM frame. The link gets stuck in a half open
state.

This patch fixes this by initiating the proper link termination procedure
after link setup timeout instead of silently closing it down.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220218073123.2121-3-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1488,7 +1488,7 @@ static void gsm_dlci_t1(struct timer_lis
 			dlci->mode = DLCI_MODE_ADM;
 			gsm_dlci_open(dlci);
 		} else {
-			gsm_dlci_close(dlci);
+			gsm_dlci_begin_close(dlci); /* prevent half open link */
 		}
 
 		break;


