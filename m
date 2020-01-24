Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472C5147D7A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgAXKBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731304AbgAXKBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:01:05 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE4720709;
        Fri, 24 Jan 2020 10:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860064;
        bh=A/WSb3YoZMC+j/wj/BzLNT0u35Mo3Ns/MRf3DCyPS6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMB8tw8a1HGzfbbgToXdNOAqcixLVWJJhEZsLZ0gBXXb49RA6BCQmC2qTinwpAQYk
         K5hfOrha9cXOj6d/2Yp8pyK/AaV2TtUUyYumM8XNJq8K5CFfSJuAfQiAVOZ6rJP25a
         ZnqiYRW4THWP1oCnsFXztYnrZY15kH9eUTmL7irU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 250/343] rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
Date:   Fri, 24 Jan 2020 10:31:08 +0100
Message-Id: <20200124092952.951854279@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3427beb6375d04e9627c67343872e79341a684ea ]

With gcc 4.1:

    net/rxrpc/output.c: In function ‘rxrpc_send_data_packet’:
    net/rxrpc/output.c:338: warning: ‘ret’ may be used uninitialized in this function

Indeed, if the first jump to the send_fragmentable label is made, and
the address family is not handled in the switch() statement, ret will be
used uninitialized.

Fix this by BUG()'ing as is done in other places in rxrpc where internal
support for future address families will need adding.  It should not be
possible to reach this normally as the address families are checked
up-front.

Fixes: 5a924b8951f835b5 ("rxrpc: Don't store the rxrpc header in the Tx queue sk_buffs")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 5b67cb5d47f0e..edddbacf33bc8 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -404,6 +404,9 @@ send_fragmentable:
 		}
 		break;
 #endif
+
+	default:
+		BUG();
 	}
 
 	up_write(&conn->params.local->defrag_sem);
-- 
2.20.1



