Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F70C593B6F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbiHOTg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344292AbiHOTg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:36:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A912FFEF;
        Mon, 15 Aug 2022 11:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CE9E61124;
        Mon, 15 Aug 2022 18:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD2FC433C1;
        Mon, 15 Aug 2022 18:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589148;
        bh=FpEssARrHd+5ZVfgg7cLzg1C9xRJKUF7HbOY7INY68k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXqlbTbQl5C2zBZ6XSt/evvb4oJLHedJh4+eMQMV3Vor/CsJ8fhQWq7+im84W+WGs
         qLY1PM0CkE4vqkwWQqeyRf2nh728AWTWZA1ENty53xXlUoS/InVbVm/wC+zP8L27dI
         RtoEyq6lCSzoCoEFvDUgpsysZVg9RSu6gy5YU5+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 597/779] tty: n_gsm: fix DM command
Date:   Mon, 15 Aug 2022 20:04:01 +0200
Message-Id: <20220815180402.873018444@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 35504e7e6a35..7a82fff7f5fe 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2148,7 +2148,7 @@ static void gsm_queue(struct gsm_mux *gsm)
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



