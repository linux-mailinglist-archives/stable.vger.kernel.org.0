Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42E730C020
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhBBNuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:50:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232716AbhBBNsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:48:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9430264F9E;
        Tue,  2 Feb 2021 13:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273328;
        bh=PGd/ruN+HHZjVqmOeWjoQMeQjg65nvPHxIIrBAaap1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cW/VhNapMj9S2Wg0kn/xRWxdHC0RyHVnXocQsYDipr9yp7hJF7EP9Ehj7LsHNgMKH
         ct4xpTgJxQej3ePpr/cTV5XL+cNlZ5OeziImQWZsRd5GW0P6zII9vza69GG3kG+iC6
         Naau1zdA/L+mKdJTq5CKzxEKx3TfCmX7ILbrd0kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Iurman <justin.iurman@uliege.be>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 065/142] uapi: fix big endian definition of ipv6_rpl_sr_hdr
Date:   Tue,  2 Feb 2021 14:37:08 +0100
Message-Id: <20210202133000.404017293@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Iurman <justin.iurman@uliege.be>

commit 07d46d93c9acdfe0614071d73c415dd5f745cc6e upstream.

Following RFC 6554 [1], the current order of fields is wrong for big
endian definition. Indeed, here is how the header looks like:

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| CmprI | CmprE |  Pad  |               Reserved                |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

This patch reorders fields so that big endian definition is now correct.

  [1] https://tools.ietf.org/html/rfc6554#section-3

Fixes: cfa933d938d8 ("include: uapi: linux: add rpl sr header definition")
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/rpl.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/rpl.h
+++ b/include/uapi/linux/rpl.h
@@ -28,10 +28,10 @@ struct ipv6_rpl_sr_hdr {
 		pad:4,
 		reserved1:16;
 #elif defined(__BIG_ENDIAN_BITFIELD)
-	__u32	reserved:20,
+	__u32	cmpri:4,
+		cmpre:4,
 		pad:4,
-		cmpri:4,
-		cmpre:4;
+		reserved:20;
 #else
 #error  "Please fix <asm/byteorder.h>"
 #endif


