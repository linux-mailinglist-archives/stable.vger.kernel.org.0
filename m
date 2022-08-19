Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40EF59A22C
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353065AbiHSQc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353365AbiHSQb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4057811DF66;
        Fri, 19 Aug 2022 09:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB3B7612DF;
        Fri, 19 Aug 2022 16:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB496C433D6;
        Fri, 19 Aug 2022 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925134;
        bh=Za0Azl4NUkOLxjsN8UNe5yuo9otj5wpPiE41bAZ7fu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gn+QIO7w+kF97StUGkEmaEcbbqJUKAoYDCCuOE83oFamRlNloMZ/nX5LzkiCQM48C
         R7DLSM3Y2xOMyVcsnM/n271laQFV/7PzD6sn7Zd4z0Jp3GUZXtpDZzghkL7FPE1+Q3
         /CBRfyMMVsTYn/j3RNAebeVmv+R2HK2e0XKz+Wfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/545] tty: n_gsm: fix wrong T1 retry count handling
Date:   Fri, 19 Aug 2022 17:42:44 +0200
Message-Id: <20220819153847.047153638@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit f30e10caa80aa1f35508bc17fc302dbbde9a833c ]

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.7.3 states that the valid range for the
maximum number of retransmissions (N2) is from 0 to 255 (both including).
gsm_dlci_t1() handles this number incorrectly by performing N2 - 1
retransmission attempts. Setting N2 to zero results in more than 255
retransmission attempts.
Fix gsm_dlci_t1() to comply with 3GPP 27.010.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220707113223.3685-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 969c0de788f8..3f100f7abdb7 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1550,8 +1550,8 @@ static void gsm_dlci_t1(struct timer_list *t)
 
 	switch (dlci->state) {
 	case DLCI_OPENING:
-		dlci->retries--;
 		if (dlci->retries) {
+			dlci->retries--;
 			gsm_command(dlci->gsm, dlci->addr, SABM|PF);
 			mod_timer(&dlci->t1, jiffies + gsm->t1 * HZ / 100);
 		} else if (!dlci->addr && gsm->control == (DM | PF)) {
@@ -1566,8 +1566,8 @@ static void gsm_dlci_t1(struct timer_list *t)
 
 		break;
 	case DLCI_CLOSING:
-		dlci->retries--;
 		if (dlci->retries) {
+			dlci->retries--;
 			gsm_command(dlci->gsm, dlci->addr, DISC|PF);
 			mod_timer(&dlci->t1, jiffies + gsm->t1 * HZ / 100);
 		} else
-- 
2.35.1



