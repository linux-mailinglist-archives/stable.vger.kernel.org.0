Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640844831C9
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbiACOV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiACOVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:21:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD208C06179B;
        Mon,  3 Jan 2022 06:21:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 53125CE1106;
        Mon,  3 Jan 2022 14:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE81C36AEB;
        Mon,  3 Jan 2022 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219705;
        bh=kZQSglxbd2SRfF5dyFhvrX8een9kNkioVEwsan94ckU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9ureTDwFOi24a7SFUS48SbFlIplPRVsm/lu94kukxb0C+PK/rw9YaxqYrJ+0k9kt
         XZAjZISYcZBhAvG4xjNQCx40gHT+3VQn4B280EU4pHeWAQpNQ/HA7FE6DPigS76XW2
         cq545wZAKASiHEcFxvfmChP+ETaT6KVFY8cOUx8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 04/11] nfc: uapi: use kernel size_t to fix user-space builds
Date:   Mon,  3 Jan 2022 15:21:15 +0100
Message-Id: <20220103142050.922750370@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142050.763904028@linuxfoundation.org>
References: <20220103142050.763904028@linuxfoundation.org>
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


