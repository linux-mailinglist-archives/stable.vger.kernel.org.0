Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7806431C53
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhJRNkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233674AbhJRNig (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:38:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62377610A1;
        Mon, 18 Oct 2021 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563932;
        bh=czaI13gQk7wRy9J0Hi5zKCZKM6yOkAkNqxw0VBmSeSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGo6WtnJHOYw/89TV5fypRFw4vBxTOYZYEH98KqI+Yhj8EJx8PA7qR0Re0B0D9BI8
         8a/CyX0Oc6Wl13BqzPiA5sfJYTvruwdqGYygbm0WNWNvv4msnntbx+j0kYMxp4NnBJ
         q7EahB46FeazlVpnu3uD+RHeNALPHtU2i74Q+SAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 53/69] nfc: fix error handling of nfc_proto_register()
Date:   Mon, 18 Oct 2021 15:24:51 +0200
Message-Id: <20211018132331.242568414@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
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
@@ -60,6 +60,9 @@ int nfc_proto_register(const struct nfc_
 		proto_tab[nfc_proto->id] = nfc_proto;
 	write_unlock(&proto_tab_lock);
 
+	if (rc)
+		proto_unregister(nfc_proto->proto);
+
 	return rc;
 }
 EXPORT_SYMBOL(nfc_proto_register);


