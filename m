Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F397538A140
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhETJ3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhETJ2A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:28:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AB516024A;
        Thu, 20 May 2021 09:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502793;
        bh=DsBOTJL5ir0zrcnF3XcMFfXwg59YIrtgqteA1mt4Cyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAo3FYaZCWNpiCqSAMKRDunKxCCIv3UP8D5ReAADyrQARcAfAL2FGO8WzY3xWAp0G
         poc+lAKOgg4JngjrUuZ36wZuy5HB2Pq+r+NUmDwZyhTruwLT+U/tJ+xWhUAEUdrsec
         YvEHb9dtBgG6acFjMFyF6BG7T49/gdueZ+kEP3Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 05/47] usb: sl811-hcd: improve misleading indentation
Date:   Thu, 20 May 2021 11:22:03 +0200
Message-Id: <20210520092053.735115102@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 8460f6003a1d2633737b89c4f69d6f4c0c7c65a3 upstream.

gcc-11 now warns about a confusingly indented code block:

drivers/usb/host/sl811-hcd.c: In function ‘sl811h_hub_control’:
drivers/usb/host/sl811-hcd.c:1291:9: error: this ‘if’ clause does not guard... [-Werror=misleading-indentation]
 1291 |         if (*(u16*)(buf+2))     /* only if wPortChange is interesting */
      |         ^~
drivers/usb/host/sl811-hcd.c:1295:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the ‘if’
 1295 |                 break;

Rewrite this to use a single if() block with the __is_defined() macro.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210322164244.827589-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/sl811-hcd.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1287,11 +1287,10 @@ sl811h_hub_control(
 			goto error;
 		put_unaligned_le32(sl811->port1, buf);
 
-#ifndef	VERBOSE
-	if (*(u16*)(buf+2))	/* only if wPortChange is interesting */
-#endif
-		dev_dbg(hcd->self.controller, "GetPortStatus %08x\n",
-			sl811->port1);
+		if (__is_defined(VERBOSE) ||
+		    *(u16*)(buf+2)) /* only if wPortChange is interesting */
+			dev_dbg(hcd->self.controller, "GetPortStatus %08x\n",
+				sl811->port1);
 		break;
 	case SetPortFeature:
 		if (wIndex != 1 || wLength != 0)


