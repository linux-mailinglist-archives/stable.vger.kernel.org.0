Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7F6551A3F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243601AbiFTNAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243505AbiFTM5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:57:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7A71AF1E;
        Mon, 20 Jun 2022 05:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 663E6B811A5;
        Mon, 20 Jun 2022 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C72C3411B;
        Mon, 20 Jun 2022 12:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729717;
        bh=3xskMTnqAoA7ji7EWzaiuRyYBc2XRfwajg78zpssRZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXGbXBko07XMOj+SQ2I2RI35PWtHfjqelH4nZnJzFj95IP6rV/wT1/wkz4dyxS1D7
         FiYziR1GY5U7crCgOyfj30sb2+pEeBRDhqx22v+jmmCd7xxe5eFyi4wkBYAu19QecW
         K89A6BgbjxFUrXHjcI3OoKUXefrqIG7yDWOQ1wBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phillip Potter <phil@philpotter.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 052/141] staging: r8188eu: fix rtw_alloc_hwxmits error detection for now
Date:   Mon, 20 Jun 2022 14:49:50 +0200
Message-Id: <20220620124731.073717226@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 5b7419ae1d208cab1e2826d473d8dab045aa75c7 ]

In _rtw_init_xmit_priv, we use the res variable to store the error
return from the newly converted rtw_alloc_hwxmits function. Sadly, the
calling function interprets res using _SUCCESS and _FAIL still, meaning
we change the semantics of the variable, even in the success case.

This leads to the following on boot:
r8188eu 1-2:1.0: _rtw_init_xmit_priv failed

In the long term, we should reverse these semantics, but for now, this
fixes the driver. Also, inside rtw_alloc_hwxmits remove the if blocks,
as HWXMIT_ENTRY is always 4.

Fixes: f94b47c6bde6 ("staging: r8188eu: add check for kzalloc")
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20220521204741.921-1-phil@philpotter.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/core/rtw_xmit.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/r8188eu/core/rtw_xmit.c b/drivers/staging/r8188eu/core/rtw_xmit.c
index 2ee92bbe66a0..ea5c88904961 100644
--- a/drivers/staging/r8188eu/core/rtw_xmit.c
+++ b/drivers/staging/r8188eu/core/rtw_xmit.c
@@ -178,8 +178,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 
 	pxmitpriv->free_xmit_extbuf_cnt = num_xmit_extbuf;
 
-	res = rtw_alloc_hwxmits(padapter);
-	if (res) {
+	if (rtw_alloc_hwxmits(padapter)) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -1492,19 +1491,10 @@ int rtw_alloc_hwxmits(struct adapter *padapter)
 
 	hwxmits = pxmitpriv->hwxmits;
 
-	if (pxmitpriv->hwxmit_entry == 5) {
-		hwxmits[0] .sta_queue = &pxmitpriv->bm_pending;
-		hwxmits[1] .sta_queue = &pxmitpriv->vo_pending;
-		hwxmits[2] .sta_queue = &pxmitpriv->vi_pending;
-		hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
-		hwxmits[4] .sta_queue = &pxmitpriv->be_pending;
-	} else if (pxmitpriv->hwxmit_entry == 4) {
-		hwxmits[0] .sta_queue = &pxmitpriv->vo_pending;
-		hwxmits[1] .sta_queue = &pxmitpriv->vi_pending;
-		hwxmits[2] .sta_queue = &pxmitpriv->be_pending;
-		hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
-	} else {
-	}
+	hwxmits[0].sta_queue = &pxmitpriv->vo_pending;
+	hwxmits[1].sta_queue = &pxmitpriv->vi_pending;
+	hwxmits[2].sta_queue = &pxmitpriv->be_pending;
+	hwxmits[3].sta_queue = &pxmitpriv->bk_pending;
 
 	return 0;
 }
-- 
2.35.1



