Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465F34831E0
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbiACOWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:22:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53674 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiACOW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:22:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FA3D6114D;
        Mon,  3 Jan 2022 14:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAACC36AEB;
        Mon,  3 Jan 2022 14:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219745;
        bh=kZQSglxbd2SRfF5dyFhvrX8een9kNkioVEwsan94ckU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mb4fnSZC3bBjQ7l26z8cJu4Gp+/CXObTprnjP0g99Ik1sjnAFUgCAReyQkC/yBTcX
         GWtXJTitVf9MIpwwXTHWWRbH0iElgh5MvQMGNBwXsvrJCJCxqMc9vQbSoOXqvR6rtF
         us7BiaGvD/LbsgpHaaypxu8pqlE9oe8wh1F1sT4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 06/13] nfc: uapi: use kernel size_t to fix user-space builds
Date:   Mon,  3 Jan 2022 15:21:22 +0100
Message-Id: <20220103142052.172522769@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
References: <20220103142051.979780231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 79b69a83705e621b258ac6d8ae6d3bfdb4b930aa upstream.

Fix user-space builds if it includes /usr/include/linux/nfc.h before
some of other headers:

  /usr/include/linux/nfc.h:281:9: error: unknown type name ‘size_t’
    281 |         size_t service_name_len;
        |         ^~~~~~

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/nfc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/nfc.h
+++ b/include/uapi/linux/nfc.h
@@ -276,7 +276,7 @@ struct sockaddr_nfc_llcp {
 	__u8 dsap; /* Destination SAP, if known */
 	__u8 ssap; /* Source SAP to be bound to */
 	char service_name[NFC_LLCP_MAX_SERVICE_NAME]; /* Service name URI */;
-	size_t service_name_len;
+	__kernel_size_t service_name_len;
 };
 
 /* NFC socket protocols */


