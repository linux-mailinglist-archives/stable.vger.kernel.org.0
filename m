Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D3A4726ED
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbhLMJ4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:56:08 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44118 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbhLMJyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DCFA6CE0E86;
        Mon, 13 Dec 2021 09:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6225DC34600;
        Mon, 13 Dec 2021 09:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389243;
        bh=YuVJlIGSlCkVhtXj8FaAbmuuXCq70y9BGZekMbL5gyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vr76wly59UJ6rt0+8A0No0sOEM4OCu4bMvtPEvdedfYCTv9M/Fiz6800Ky6l3W1qF
         35yTR9zhWK2WGdN01+j1YEsdOP4SnljkQRSZJyB56dCaVQYU25ljX6bHTg9xvvQiZ+
         ez4vPkrxDq9KguyPJzuzES55or2ZKbLV9BtZDZwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 033/171] nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done
Date:   Mon, 13 Dec 2021 10:29:08 +0100
Message-Id: <20211213092946.177905131@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 4cd8371a234d051f9c9557fcbb1f8c523b1c0d10 upstream.

The done() netlink callback nfc_genl_dump_ses_done() should check if
received argument is non-NULL, because its allocation could fail earlier
in dumpit() (nfc_genl_dump_ses()).

Fixes: ac22ac466a65 ("NFC: Add a GET_SE netlink API")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211209081307.57337-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1392,8 +1392,10 @@ static int nfc_genl_dump_ses_done(struct
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 
-	nfc_device_iter_exit(iter);
-	kfree(iter);
+	if (iter) {
+		nfc_device_iter_exit(iter);
+		kfree(iter);
+	}
 
 	return 0;
 }


