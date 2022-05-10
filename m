Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641985216A1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbiEJNQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241535AbiEJNQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:16:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FF73EF23;
        Tue, 10 May 2022 06:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DA6B615F8;
        Tue, 10 May 2022 13:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F1BC385A6;
        Tue, 10 May 2022 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188325;
        bh=5JcHX9Wa3Mes2Izs1ipgsGcdg9EM9TbFHe/TyofPpc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3TBl+jvjbqOv5mwMuT7X1b5Pu0g//OQJmYLEpZlcr+A3dAf4G0U0/NrQ0EZAkwU9
         22w+xzTB2zOD4eOxOZMBIUQ4g+EuLtZRh3X25hUn7GJzJu1cIn/FZnN6k9yV0NhzpT
         3OP7p8PUlMma3LjwvOpe9ssxiX/HM52DWSM9Ggk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 4.9 37/66] tty: n_gsm: fix malformed counter for out of frame data
Date:   Tue, 10 May 2022 15:07:27 +0200
Message-Id: <20220510130730.857381555@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

commit a24b4b2f660b7ddf3f484b37600bba382cb28a9d upstream.

The gsm_mux field 'malformed' represents the number of malformed frames
received. However, gsm1_receive() also increases this counter for any out
of frame byte.
Fix this by ignoring out of frame data for the malformed counter.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-7-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1977,7 +1977,8 @@ static void gsm1_receive(struct gsm_mux
 		}
 		/* Any partial frame was a runt so go back to start */
 		if (gsm->state != GSM_START) {
-			gsm->malformed++;
+			if (gsm->state != GSM_SEARCH)
+				gsm->malformed++;
 			gsm->state = GSM_START;
 		}
 		/* A SOF in GSM_START means we are still reading idling or


