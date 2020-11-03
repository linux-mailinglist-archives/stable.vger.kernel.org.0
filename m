Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484CE2A527C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbgKCUu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:50:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731793AbgKCUu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E0A820719;
        Tue,  3 Nov 2020 20:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436626;
        bh=6b8Zad7jOreNIBtR21Pp7q5CgMaXPTJhitl42m2QMR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBul79fJNY9t49NzWsUahuk/axZTELd4mAb84woLXTVdKDdodT8AtsMZtn9XSw+9a
         H37cBMypN8Kquo9chy356FRi9cNsIlJf75vPFE+nyRZ7XEBXMyA1aAsV3pm6i6JH8y
         rT36rtoTEN7EDIe1oFpDhhxLCtoaRbZRkW9xFZD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artur Molchanov <arturmolchanov@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.9 331/391] net/sunrpc: Fix return value for sysctl sunrpc.transports
Date:   Tue,  3 Nov 2020 21:36:22 +0100
Message-Id: <20201103203409.457535281@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artur Molchanov <arturmolchanov@gmail.com>

commit c09f56b8f68d4d536bff518227aea323b835b2ce upstream.

Fix returning value for sysctl sunrpc.transports.
Return error code from sysctl proc_handler function proc_do_xprt instead of number of the written bytes.
Otherwise sysctl returns random garbage for this key.

Since v1:
- Handle negative returned value from memory_read_from_buffer as an error

Signed-off-by: Artur Molchanov <arturmolchanov@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/sysctl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -70,7 +70,13 @@ static int proc_do_xprt(struct ctl_table
 		return 0;
 	}
 	len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
-	return memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
+	*lenp = memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
+
+	if (*lenp < 0) {
+		*lenp = 0;
+		return -EINVAL;
+	}
+	return 0;
 }
 
 static int


