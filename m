Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415BB38A544
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhETKPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235714AbhETKMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:12:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D76C36195E;
        Thu, 20 May 2021 09:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503827;
        bh=DsBOTJL5ir0zrcnF3XcMFfXwg59YIrtgqteA1mt4Cyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ia6eLYpbf/3I2CHQ547ooCSDRkmjKTQWFgcL0hCm3cN6kGz4y3fHAzkdwPiEvpZMa
         MCKGBjTM0j+RgTwQp/lxHsqJf28h4n43G7hbfzxbVM7ASoV4DhyLl4xRClR1rzv5MZ
         2BeXpGBDgVwcIGbBsENujunq+JHbA2o6F3QRKeE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 396/425] usb: sl811-hcd: improve misleading indentation
Date:   Thu, 20 May 2021 11:22:45 +0200
Message-Id: <20210520092144.416966837@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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


