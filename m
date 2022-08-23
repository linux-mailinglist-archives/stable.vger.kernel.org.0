Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77A559DD64
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355038AbiHWKnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355654AbiHWKkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDA0A74D7;
        Tue, 23 Aug 2022 02:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD61B81C53;
        Tue, 23 Aug 2022 09:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A58C433D6;
        Tue, 23 Aug 2022 09:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245690;
        bh=bCxOf+Tw6FCeLVi8ztxNIf2iE72I9R5m0AUtL9Ft5Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DV0/jbXqgYUsVHKAXPtd9B2a73oq2wC3w7QShEkDs//C1PTW27dvLditgpp5TGiQZ
         WPF4c8PMsFRzTjZw3NbvTtZ7bY553zw1nQJ98bCR+ff89+8h1+W+eQmTZ5+/UPiIdq
         SGJo9ylnPhuuBb94SJaqZyaCNtyAhG1F1WKen2FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/287] tty: n_gsm: fix DM command
Date:   Tue, 23 Aug 2022 10:25:27 +0200
Message-Id: <20220823080106.005042114@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 18a948c7d90995d127785e308fa7b701df4c499f ]

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.3.3 defines the DM response. There exists
no DM command. However, the current implementation incorrectly sends DM as
command in case of unexpected UIH frames in gsm_queue().
Correct this behavior by always sending DM as response.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220707113223.3685-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 43491df37a2d..727707e02551 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1892,7 +1892,7 @@ static void gsm_queue(struct gsm_mux *gsm)
 			goto invalid;
 #endif
 		if (dlci == NULL || dlci->state != DLCI_OPEN) {
-			gsm_command(gsm, address, DM|PF);
+			gsm_response(gsm, address, DM|PF);
 			return;
 		}
 		dlci->data(dlci, gsm->buf, gsm->len);
-- 
2.35.1



