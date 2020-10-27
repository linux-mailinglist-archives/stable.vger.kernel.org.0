Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA1629B388
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775724AbgJ0OxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772437AbgJ0OuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:50:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19310207DE;
        Tue, 27 Oct 2020 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810218;
        bh=r0Kd9LdRGLX1hEVXAH6dDtEBZdTcwVQLImYqqGjor1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHqxUvsuX3DvPaSTnP0fxDIqDkwKbeHLRllAf3Xma5QkjYKg8udQyigw78IKqwahc
         OMdYMOoK1EmeWiTD05aUEMcMmlkFW71p4slarXIZzgRqipO8N35dIDDuoe4IlR2slb
         G+I3eWQOjwJzre3vwGSF1QabE3GvyoYtC8vcGLdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dominik Maier <dmaier@sect.tu-berlin.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.8 062/633] cifs: remove bogus debug code
Date:   Tue, 27 Oct 2020 14:46:45 +0100
Message-Id: <20201027135525.601645925@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d367cb960ce88914898cbfa43645c2e43ede9465 upstream.

The "end" pointer is either NULL or it points to the next byte to parse.
If there isn't a next byte then dereferencing "end" is an off-by-one out
of bounds error.  And, of course, if it's NULL that leads to an Oops.
Printing "*end" doesn't seem very useful so let's delete this code.

Also for the last debug statement, I noticed that it should be printing
"sequence_end" instead of "end" so fix that as well.

Reported-by: Dominik Maier <dmaier@sect.tu-berlin.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/asn1.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -530,8 +530,8 @@ decode_negTokenInit(unsigned char *secur
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
 		   || (tag != ASN1_EOC)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d) exit 0\n",
-			 cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p exit 0\n",
+			 cls, con, tag, end);
 		return 0;
 	}
 
@@ -541,8 +541,8 @@ decode_negTokenInit(unsigned char *secur
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
 		   || (tag != ASN1_SEQ)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d) exit 1\n",
-			 cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p exit 1\n",
+			 cls, con, tag, end);
 		return 0;
 	}
 
@@ -552,8 +552,8 @@ decode_negTokenInit(unsigned char *secur
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
 		   || (tag != ASN1_EOC)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d) exit 0\n",
-			 cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p exit 0\n",
+			 cls, con, tag, end);
 		return 0;
 	}
 
@@ -564,8 +564,8 @@ decode_negTokenInit(unsigned char *secur
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
 		   || (tag != ASN1_SEQ)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d) exit 1\n",
-			 cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d sequence_end = %p exit 1\n",
+			 cls, con, tag, sequence_end);
 		return 0;
 	}
 


