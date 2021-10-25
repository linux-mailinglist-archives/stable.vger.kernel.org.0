Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29D4439F28
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhJYTR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234233AbhJYTRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:17:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DC1360F70;
        Mon, 25 Oct 2021 19:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189313;
        bh=C5FP8kKROJgbrrJ2hju5tkxPdk9lu+Bz/41Cb4lW+sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wn/QU8YaanVkrtaYi8wsUyvOYoQ4H3uhYKtyHYCdbGYPbFUGOQSEvWPvuqs05BmeG
         FUpCz0yMMP1Ld0twQG6Z/yPJCBIEaNWqRk9KUW7g7GJpBp/wV/N4fkUbELT22sNiWA
         aob8kDhEDgb1eLuWBgvgi1L2MhjwMGilG//7vgwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 18/44] NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
Date:   Mon, 25 Oct 2021 21:13:59 +0200
Message-Id: <20211025190932.448696255@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 58e7dcc9ca29c14e44267a4d0ea61e3229124907 upstream.

'params' is allocated in digital_tg_listen_mdaa(), but not free when
digital_send_cmd() failed, which will cause memory leak. Fix it by
freeing 'params' if digital_send_cmd() return failed.

Fixes: 1c7a4c24fbfd ("NFC Digital: Add target NFC-DEP support")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/digital_core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -280,6 +280,7 @@ int digital_tg_configure_hw(struct nfc_d
 static int digital_tg_listen_mdaa(struct nfc_digital_dev *ddev, u8 rf_tech)
 {
 	struct digital_tg_mdaa_params *params;
+	int rc;
 
 	params = kzalloc(sizeof(struct digital_tg_mdaa_params), GFP_KERNEL);
 	if (!params)
@@ -294,8 +295,12 @@ static int digital_tg_listen_mdaa(struct
 	get_random_bytes(params->nfcid2 + 2, NFC_NFCID2_MAXSIZE - 2);
 	params->sc = DIGITAL_SENSF_FELICA_SC;
 
-	return digital_send_cmd(ddev, DIGITAL_CMD_TG_LISTEN_MDAA, NULL, params,
-				500, digital_tg_recv_atr_req, NULL);
+	rc = digital_send_cmd(ddev, DIGITAL_CMD_TG_LISTEN_MDAA, NULL, params,
+			      500, digital_tg_recv_atr_req, NULL);
+	if (rc)
+		kfree(params);
+
+	return rc;
 }
 
 static int digital_tg_listen_md(struct nfc_digital_dev *ddev, u8 rf_tech)


