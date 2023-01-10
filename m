Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B24664A11
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjAJS3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239415AbjAJS2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:28:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE6785C89;
        Tue, 10 Jan 2023 10:24:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D9F8B81903;
        Tue, 10 Jan 2023 18:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F39C433D2;
        Tue, 10 Jan 2023 18:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375051;
        bh=5vqMnOjPB/EzvYDjxxL+uagrVqeIhA4cDaoRhifpY2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FF+BctLHB/64TNC1oOMfGhC9C2xnciTPJrcU6Q/1GK+GOTjGWxzNfRtRMTFg8sYeC
         czPqucOPtNOAiTiLytTsqjlfEfIlmEKC9Ts6PnE5duonV1SGR/3DQx5WRUh7ASZhPx
         H4SCTa1FKLXjQHlxXEMD+660IFXMC7DF9kX1A+ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 060/290] media: stv0288: use explicitly signed char
Date:   Tue, 10 Jan 2023 19:02:32 +0100
Message-Id: <20230110180033.702470964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
 


