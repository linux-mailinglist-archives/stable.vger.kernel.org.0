Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5563AA66
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbfFIQw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732188AbfFIQwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 642B8204EC;
        Sun,  9 Jun 2019 16:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099143;
        bh=WO/xY2whLhZsYeG3CtK+RlKKS6z8EIAXONDnC5MVslk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBfoRpIuumpP4kOQsUGfpw5jON1uVTPdPaqUsCScLs3SPHP/fzoW+9qxshAVn9woy
         mU6pZm1VwYxT69l7bXSBiP7hRIEaYEnfPFsrY8UF7V/q6TEDX0AGhmz6KB9tW+W217
         i78dUjPmI4JeV3FjhV7a4SyILQem7R+wRdGm2Otk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 07/83] tipc: Avoid copying bytes beyond the supplied data
Date:   Sun,  9 Jun 2019 18:41:37 +0200
Message-Id: <20190609164128.247977077@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
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
@@ -301,8 +301,10 @@ static inline int TLV_SET(void *tlv, __u
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
 
@@ -399,8 +401,10 @@ static inline int TCM_SET(void *msg, __u
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
 


