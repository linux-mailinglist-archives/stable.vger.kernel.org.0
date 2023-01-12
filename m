Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B7C66774B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbjALOle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239798AbjALOkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:40:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD7858D2A;
        Thu, 12 Jan 2023 06:30:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5985BB81E70;
        Thu, 12 Jan 2023 14:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21C6C433F0;
        Thu, 12 Jan 2023 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533843;
        bh=5vqMnOjPB/EzvYDjxxL+uagrVqeIhA4cDaoRhifpY2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmtU1NtcBJIHeWNCP67wW18bNwwksXg0BfxTgZwf1EmwmatgoS4lTkMnBNf2LSLQr
         9NqkTta86NFpKim+1DLUUs8AhOA8DreyTPDqAK2wvszCpcm0QplFejnnf8RcJ45sGJ
         sBTrD2P+ga/1CueBoVEtz03diuYvFwlbHF8CMOIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 610/783] media: stv0288: use explicitly signed char
Date:   Thu, 12 Jan 2023 14:55:26 +0100
Message-Id: <20230112135552.533060919@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 7392134428c92a4cb541bd5c8f4f5c8d2e88364d upstream.

With char becoming unsigned by default, and with `char` alone being
ambiguous and based on architecture, signed chars need to be marked
explicitly as such. Use `s8` and `u8` types here, since that's what
surrounding code does. This fixes:

drivers/media/dvb-frontends/stv0288.c:471 stv0288_set_frontend() warn: assigning (-9) to unsigned variable 'tm'
drivers/media/dvb-frontends/stv0288.c:471 stv0288_set_frontend() warn: we never enter this loop

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/stv0288.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -440,9 +440,8 @@ static int stv0288_set_frontend(struct d
 	struct stv0288_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	char tm;
-	unsigned char tda[3];
-	u8 reg, time_out = 0;
+	u8 tda[3], reg, time_out = 0;
+	s8 tm;
 
 	dprintk("%s : FE_SET_FRONTEND\n", __func__);
 


