Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EDF521736
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240962AbiEJNX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243691AbiEJNWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:22:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A2E5252B;
        Tue, 10 May 2022 06:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4587CE1EE5;
        Tue, 10 May 2022 13:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1482C385C2;
        Tue, 10 May 2022 13:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188557;
        bh=W34MZk3EtXVGP67+Bx2iGoR3kmpNyZe266vZTLgpJd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSNKP9NkLS7uTzWOzJshsg7NB9hUfrGEUTPt1Urr3w1Re5Qz2Usc/QAs5eJUJcoCH
         VsITLHVV7C+z7ygOq6qfFfEpSiyyNOgcc8XMjVfj7WI5d6DPXxPsj/7Hp5BLGxOFpw
         wkC3QQwLHwSkPVa90ykuttQH9Uaao041tHmsn3YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 4.14 47/78] tty: n_gsm: fix malformed counter for out of frame data
Date:   Tue, 10 May 2022 15:07:33 +0200
Message-Id: <20220510130733.930598618@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
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
@@ -1973,7 +1973,8 @@ static void gsm1_receive(struct gsm_mux
 		}
 		/* Any partial frame was a runt so go back to start */
 		if (gsm->state != GSM_START) {
-			gsm->malformed++;
+			if (gsm->state != GSM_SEARCH)
+				gsm->malformed++;
 			gsm->state = GSM_START;
 		}
 		/* A SOF in GSM_START means we are still reading idling or


