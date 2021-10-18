Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5F7431D38
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhJRNtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232736AbhJRNrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:47:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 516006136A;
        Mon, 18 Oct 2021 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564185;
        bh=F6/j8CSR2cmasNkSLypwl3nDj6yUpxbHCMsipKhXnyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ak6SplnjeB0wkoXhWKsFoYM7kEoVX6aUDkxrpfyQ8zJLOWxjlF3XynX0QB1QNFz0W
         su8XBRLfa/3NMKwA+lLnw9KMzkZlRECRx8U6Gf1SxqyF0AVqhZ2EiLZhJsnrv9auAd
         sp6/EUMukSgzEqpmQ5gQ/f99aCjMEMkM68ZKWYpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 080/103] NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
Date:   Mon, 18 Oct 2021 15:24:56 +0200
Message-Id: <20211018132337.441069012@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
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
@@ -277,6 +277,7 @@ int digital_tg_configure_hw(struct nfc_d
 static int digital_tg_listen_mdaa(struct nfc_digital_dev *ddev, u8 rf_tech)
 {
 	struct digital_tg_mdaa_params *params;
+	int rc;
 
 	params = kzalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
@@ -291,8 +292,12 @@ static int digital_tg_listen_mdaa(struct
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


