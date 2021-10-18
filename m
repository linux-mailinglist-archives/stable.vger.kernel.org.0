Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9D9431AE4
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhJRN3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231804AbhJRN3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0138261372;
        Mon, 18 Oct 2021 13:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563609;
        bh=BwV6JUfUV0XNuNYtl6MUBSVDD3+tMVqifVU/2j3WBRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCKGhzk+/QNe4I4CzIEjCd2XHiiD6oXJoYUBvuK5OGcKOeDyx1pnux+Su5BjNYbv0
         d6SJRMpNeUhvOMSzNpJKfzyDyCFiXJrfySgZTCqc5FwaZlaTIJgC4trZ9D/9jGPNlY
         +AzqQNCPjgMM5exrB1gBobAGwt2JEab/DlgI+ypA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 32/39] NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
Date:   Mon, 18 Oct 2021 15:24:41 +0200
Message-Id: <20211018132326.473847930@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
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
@@ -286,6 +286,7 @@ int digital_tg_configure_hw(struct nfc_d
 static int digital_tg_listen_mdaa(struct nfc_digital_dev *ddev, u8 rf_tech)
 {
 	struct digital_tg_mdaa_params *params;
+	int rc;
 
 	params = kzalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
@@ -300,8 +301,12 @@ static int digital_tg_listen_mdaa(struct
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


