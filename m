Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D22E51A73D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354758AbiEDRC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355619AbiEDRAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EB54BB8B;
        Wed,  4 May 2022 09:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF79617BD;
        Wed,  4 May 2022 16:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C65C385AF;
        Wed,  4 May 2022 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683117;
        bh=BvmIjTtTWEk5XrrW7SiDfkdntqy8Ebp0VljKqKVynZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1nZU0HsX5/454wT/AeC+/XoVVNhB1p2k47dmLBpyIFhUrgyXYUChsEl2YkWei6bc
         Px0YGhoHSaDle3ComiWYW2nl8wBtYP+1szoI7Gt23vG9HdvXjiXv/cw4Nf7r2OowV+
         Yp21ObWJSIMOBRGFHSznYHQocK8oWAGXWWGBXubA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.10 121/129] tty: n_gsm: fix insufficient txframe size
Date:   Wed,  4 May 2022 18:45:13 +0200
Message-Id: <20220504153031.058349843@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

commit 535bf600de75a859698892ee873521a48d289ec1 upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.7.2 states that the maximum frame size
(N1) refers to the length of the information field (i.e. user payload).
However, 'txframe' stores the whole frame including frame header, checksum
and start/end flags. We also need to consider the byte stuffing overhead.
Define constant for the protocol overhead and adjust the 'txframe' size
calculation accordingly to reserve enough space for a complete mux frame
including byte stuffing for advanced option mode. Note that no byte
stuffing is applied to the start and end flag.
Also use MAX_MTU instead of MAX_MRU as this buffer is used for data
transmission.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-8-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -72,6 +72,8 @@ module_param(debug, int, 0600);
  */
 #define MAX_MRU 1500
 #define MAX_MTU 1500
+/* SOF, ADDR, CTRL, LEN1, LEN2, ..., FCS, EOF */
+#define PROT_OVERHEAD 7
 #define	GSM_NET_TX_TIMEOUT (HZ*10)
 
 /**
@@ -2191,7 +2193,7 @@ static struct gsm_mux *gsm_alloc_mux(voi
 		kfree(gsm);
 		return NULL;
 	}
-	gsm->txframe = kmalloc(2 * MAX_MRU + 2, GFP_KERNEL);
+	gsm->txframe = kmalloc(2 * (MAX_MTU + PROT_OVERHEAD - 1), GFP_KERNEL);
 	if (gsm->txframe == NULL) {
 		kfree(gsm->buf);
 		kfree(gsm);


