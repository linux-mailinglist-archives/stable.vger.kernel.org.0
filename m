Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125E3548BA1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355793AbiFMM5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355132AbiFMMzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D681AE74;
        Mon, 13 Jun 2022 04:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCA6460B6B;
        Mon, 13 Jun 2022 11:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E71C34114;
        Mon, 13 Jun 2022 11:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118926;
        bh=0R9cUiJJLlj1dZmF0CiC0DRn4+vSv1qX+ATJ4iTqCag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYXOhFlHIIJNGA/tfJU7Ra8aedNSnXy+38HKpSio+LOIxcYNaW4wTnTkYJE9XJCzg
         C6JXkH8UCIqu+73KWWH5G7mKCeAtrm/LqSvzO47HjRPQsVFY/Tw57I1MbiLjZeAx5s
         7XMDndd2Xp08JmwvemNAlWT8mJNeXq3xZghxsoUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/247] tty: n_gsm: Dont ignore write return value in gsmld_output()
Date:   Mon, 13 Jun 2022 12:09:12 +0200
Message-Id: <20220613094924.470403861@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9136c68346d096697935b9840782f7051d5796c5 ]

We currently have gsmld_output() ignore the return value from device
write. This means we will lose packets if device write returns 0 or
an error.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210930060624.46523-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 1767503de744..0722860b6f54 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -692,7 +692,7 @@ static void gsm_data_kick(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 			print_hex_dump_bytes("gsm_data_kick: ",
 					     DUMP_PREFIX_OFFSET,
 					     gsm->txframe, len);
-		if (gsmld_output(gsm, gsm->txframe, len) < 0)
+		if (gsmld_output(gsm, gsm->txframe, len) <= 0)
 			break;
 		/* FIXME: Can eliminate one SOF in many more cases */
 		gsm->tx_bytes -= msg->len;
@@ -2373,8 +2373,7 @@ static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
 	if (debug & 4)
 		print_hex_dump_bytes("gsmld_output: ", DUMP_PREFIX_OFFSET,
 				     data, len);
-	gsm->tty->ops->write(gsm->tty, data, len);
-	return len;
+	return gsm->tty->ops->write(gsm->tty, data, len);
 }
 
 /**
-- 
2.35.1



