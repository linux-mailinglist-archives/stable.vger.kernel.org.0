Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129F3548C7F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347305AbiFMLGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351825AbiFMLFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:05:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C3E32EFC;
        Mon, 13 Jun 2022 03:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7632CB80EA3;
        Mon, 13 Jun 2022 10:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C4AC34114;
        Mon, 13 Jun 2022 10:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116448;
        bh=nVupM//GcVfdw+hww8CqjX+lzfcmuKSUcgzb2+JIjKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cT0iTqzjQCYN4+3W/y/38rFaOMBDLHxBbO8zvZop5IbSJ65oM9w1tZzOowuExprcj
         xxvD3DfzxkLON3h/Jc+yaF6yiQB5Opg53WdqIubbsBmdpybf9TEgiH6zm8cOYOoJAK
         AbXUrqBm8hg0BksdKsTqgrQn8c9JN+8ayRMXZufw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/411] drm/vc4: txp: Dont set TXP_VSTART_AT_EOF
Date:   Mon, 13 Jun 2022 12:06:01 +0200
Message-Id: <20220613094931.319898681@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 234998df929f14d00cbf2f1e81a7facb69fd9266 ]

The TXP_VSTART_AT_EOF will generate a second VSTART signal to the HVS.
However, the HVS waits for VSTART to enable the FIFO and will thus start
filling the FIFO before the start of the frame.

This leads to corruption at the beginning of the first frame, and
content from the previous frame at the beginning of the next frames.

Since one VSTART is enough, let's get rid of it.

Fixes: 008095e065a8 ("drm/vc4: Add support for the transposer block")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20220328153659.2382206-3-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_txp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_txp.c b/drivers/gpu/drm/vc4/vc4_txp.c
index bf720206727f..2342b49c16dd 100644
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -285,7 +285,7 @@ static void vc4_txp_connector_atomic_commit(struct drm_connector *conn,
 	if (WARN_ON(i == ARRAY_SIZE(drm_fmts)))
 		return;
 
-	ctrl = TXP_GO | TXP_VSTART_AT_EOF | TXP_EI |
+	ctrl = TXP_GO | TXP_EI |
 	       VC4_SET_FIELD(0xf, TXP_BYTE_ENABLE) |
 	       VC4_SET_FIELD(txp_fmts[i], TXP_FORMAT);
 
-- 
2.35.1



