Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2C32BFA
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfFCJN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbfFCJN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:13:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE23B276DB;
        Mon,  3 Jun 2019 09:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553205;
        bh=N1GD6wogL0wc3ROCjL0Tr4+i1aVNnoY969QvokdKYgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWe+tStIlF9TfwDhkKdPpt9jPcwlROqXMQ9poC4KKEMfGJ/9ZNoLaKDoMAO5hfYZB
         5cCW47QmvEOq6xk/Ln/626oLmYb1gF7y4MHgZ28bRCw+6cYhMI4aSZHzuORFR4o9Xk
         3zcU5xTcyVaAb8gJ7KHXcI0E1nbN2Sr8NtXt/eWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 22/40] tipc: Avoid copying bytes beyond the supplied data
Date:   Mon,  3 Jun 2019 11:09:15 +0200
Message-Id: <20190603090523.981084133@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

TLV_SET is called with a data pointer and a len parameter that tells us
how many bytes are pointed to by data. When invoking memcpy() we need
to careful to only copy len bytes.

Previously we would copy TLV_LENGTH(len) bytes which would copy an extra
4 bytes past the end of the data pointer which newer GCC versions
complain about.

 In file included from test.c:17:
 In function 'TLV_SET',
     inlined from 'test' at test.c:186:5:
 /usr/include/linux/tipc_config.h:317:3:
 warning: 'memcpy' forming offset [33, 36] is out of the bounds [0, 32]
 of object 'bearer_name' with type 'char[32]' [-Warray-bounds]
     memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 test.c: In function 'test':
 test.c::161:10: note:
 'bearer_name' declared here
     char bearer_name[TIPC_MAX_BEARER_NAME];
          ^~~~~~~~~~~

We still want to ensure any padding bytes at the end are initialised, do
this with a explicit memset() rather than copy bytes past the end of
data. Apply the same logic to TCM_SET.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/tipc_config.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/tipc_config.h
+++ b/include/uapi/linux/tipc_config.h
@@ -307,8 +307,10 @@ static inline int TLV_SET(void *tlv, __u
 	tlv_ptr = (struct tlv_desc *)tlv;
 	tlv_ptr->tlv_type = htons(type);
 	tlv_ptr->tlv_len  = htons(tlv_len);
-	if (len && data)
-		memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
+	if (len && data) {
+		memcpy(TLV_DATA(tlv_ptr), data, len);
+		memset(TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - tlv_len);
+	}
 	return TLV_SPACE(len);
 }
 
@@ -405,8 +407,10 @@ static inline int TCM_SET(void *msg, __u
 	tcm_hdr->tcm_len   = htonl(msg_len);
 	tcm_hdr->tcm_type  = htons(cmd);
 	tcm_hdr->tcm_flags = htons(flags);
-	if (data_len && data)
+	if (data_len && data) {
 		memcpy(TCM_DATA(msg), data, data_len);
+		memset(TCM_DATA(msg) + data_len, 0, TCM_SPACE(data_len) - msg_len);
+	}
 	return TCM_SPACE(data_len);
 }
 


