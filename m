Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374604C74A0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbiB1RqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbiB1Rnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B629AE62;
        Mon, 28 Feb 2022 09:35:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58852614B9;
        Mon, 28 Feb 2022 17:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3AFC340E7;
        Mon, 28 Feb 2022 17:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069734;
        bh=v5QaB1hFhjLaOCClqrmwreuVmYnWVQQ3HcouUHL0f/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QR4Uv8UgwKGBO4Xwy6U4hUW4SO4zZFgmG3ngkAYtUdW9u3qpmSlvQT4YJZd+ko8BE
         v32CIfPOxYW9PO9v6c+05JoBSl3jgzT5XOs5FX4rGBGRH5vLQkTVjoQgsBk1Gi5k/p
         bbQCaocqa0fI3cmeqMeuwlPleWNxEpY4ntlKqcTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.10 74/80] tty: n_gsm: fix encoding of control signal octet bit DV
Date:   Mon, 28 Feb 2022 18:24:55 +0100
Message-Id: <20220228172320.674874690@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
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

commit 737b0ef3be6b319d6c1fd64193d1603311969326 upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.4.6.3.7 describes the encoding of the
control signal octet used by the MSC (modem status command). The same
encoding is also used in convergence layer type 2 as described in chapter
5.5.2. Table 7 and 24 both require the DV (data valid) bit to be set 1 for
outgoing control signal octets sent by the DTE (data terminal equipment),
i.e. for the initiator side.
Currently, the DV bit is only set if CD (carrier detect) is on, regardless
of the side.

This patch fixes this behavior by setting the DV bit on the initiator side
unconditionally.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220218073123.2121-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -434,7 +434,7 @@ static u8 gsm_encode_modem(const struct
 		modembits |= MDM_RTR;
 	if (dlci->modem_tx & TIOCM_RI)
 		modembits |= MDM_IC;
-	if (dlci->modem_tx & TIOCM_CD)
+	if (dlci->modem_tx & TIOCM_CD || dlci->gsm->initiator)
 		modembits |= MDM_DV;
 	return modembits;
 }


