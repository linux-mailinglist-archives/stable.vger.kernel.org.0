Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E95431B58
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhJRNc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhJRNaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:30:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B70E16058D;
        Mon, 18 Oct 2021 13:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563712;
        bh=spT+mTz6Sq3sdyfzZk69VBXSZ2sJLsDvjbKHAmns0aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cU+sIbKUKqyW2WUJrhxmTt51znU0KsE/J/5bAZKMrPEa857zj9Fq4QWFqhQSz9M8j
         uhXRa2yA2Vfid/3PyGhlogv3Eh0/4yRNGlo+MNpPkH+xK/zfI+xDjoAvAQUXKr6tWf
         2FigO0ijuJqsggTKvTnjZT+1CNQOWUnC4ex0M0bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Florian fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 35/50] net: korina: select CRC32
Date:   Mon, 18 Oct 2021 15:24:42 +0200
Message-Id: <20211018132327.692643815@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 427f974d9727ca681085ddcd0530c97ab5811ae0 upstream.

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/net/ethernet/korina.o: in function `korina_multicast_list':
  korina.c:(.text+0x1af): undefined reference to `crc32_le'

Fixes: ef11291bcd5f9 ("Add support the Korina (IDT RC32434) Ethernet MAC")
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Florian fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211012152509.21771-1-vegard.nossum@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -98,6 +98,7 @@ config JME
 config KORINA
 	tristate "Korina (IDT RC32434) Ethernet support"
 	depends on MIKROTIK_RB532
+	select CRC32
 	---help---
 	  If you have a Mikrotik RouterBoard 500 or IDT RC32434
 	  based system say Y. Otherwise say N.


