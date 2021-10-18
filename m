Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1D1431B63
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhJRNcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhJRNbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23D496136A;
        Mon, 18 Oct 2021 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563719;
        bh=mIfWHTo6F5vNmIUpGiI4Mgv2twSJ0V9JjEE+iJXG1q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYNf+4T+IFKRaizpfv9QLNLuLNgl+pnPlTBUEO3/3Xl2VmmtqoN3anM6dBAlF88or
         EuEzUkgZ1I4FES2wOb2CmYZj6R1K4lwmfebqt0s6qMb0sGRktgwSucxGykBCVzwabb
         lZMNrOBfE3fGrFxVRWMYNhaYCpKIKAcTz0qHtF5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 38/50] nfc: fix error handling of nfc_proto_register()
Date:   Mon, 18 Oct 2021 15:24:45 +0200
Message-Id: <20211018132327.785476316@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 0911ab31896f0e908540746414a77dd63912748d upstream.

When nfc proto id is using, nfc_proto_register() return -EBUSY error
code, but forgot to unregister proto. Fix it by adding proto_unregister()
in the error handling case.

Fixes: c7fe3b52c128 ("NFC: add NFC socket family")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211013034932.2833737-1-william.xuanziyang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/af_nfc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/nfc/af_nfc.c
+++ b/net/nfc/af_nfc.c
@@ -72,6 +72,9 @@ int nfc_proto_register(const struct nfc_
 		proto_tab[nfc_proto->id] = nfc_proto;
 	write_unlock(&proto_tab_lock);
 
+	if (rc)
+		proto_unregister(nfc_proto->proto);
+
 	return rc;
 }
 EXPORT_SYMBOL(nfc_proto_register);


