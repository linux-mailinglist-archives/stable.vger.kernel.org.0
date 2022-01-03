Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1B94832D1
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiACObA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiACO34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595EEC0619DA;
        Mon,  3 Jan 2022 06:29:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE3D161117;
        Mon,  3 Jan 2022 14:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C350DC36AEB;
        Mon,  3 Jan 2022 14:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220169;
        bh=6uZ5RRlyZ/Ssvt9ME2JBVJM3wvIu6RYNKVaTMYpt1YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3hO9RWw6aNNLbSeMFfcgdmhprMEEBlyLh/UL0K3+AQTdUO39KJM29AjD71GjQ/ys
         G9YVQGkJqRwPWFovTRNTQZhV/7d5lrRYZPPMxO4v7FY0RFU9eWYGABU14bzVA6j40S
         Wao5fyvcB2xSQ+F5KJ9fdEPaxQQPofuPconQqKcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 33/48] nfc: uapi: use kernel size_t to fix user-space builds
Date:   Mon,  3 Jan 2022 15:24:10 +0100
Message-Id: <20220103142054.588196295@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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
@@ -278,7 +278,7 @@ struct sockaddr_nfc_llcp {
 	__u8 dsap; /* Destination SAP, if known */
 	__u8 ssap; /* Source SAP to be bound to */
 	char service_name[NFC_LLCP_MAX_SERVICE_NAME]; /* Service name URI */;
-	size_t service_name_len;
+	__kernel_size_t service_name_len;
 };
 
 /* NFC socket protocols */


