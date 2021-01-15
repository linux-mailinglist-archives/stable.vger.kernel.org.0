Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474A62F799A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733075AbhAOMil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388200AbhAOMig (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D048221F7;
        Fri, 15 Jan 2021 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714301;
        bh=kWfJGl5jZNZXUtHXPL9S0LFXMELg73Fctac7xDcDaz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQ9KTBoRedLKDaFD9E4bEtZjsIwhg3NFzu6aQ7wacrm/BlQtaRTCL/Aj4aJuXZEue
         XYl6+pFp5mpkW/EOOeZYaVpleaXtwx26WGSUsmhPSnNJpStrPd9NyYtyb6LrICHgi0
         iyr9P1zBX/Yhp9T2odyiXpsCBu3qWMNwyW37E0YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 075/103] phy: dp83640: select CONFIG_CRC32
Date:   Fri, 15 Jan 2021 13:28:08 +0100
Message-Id: <20210115122009.657296909@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f9d6f94132f01d2a552dcbab54fa56496638186d upstream.

Without crc32, this driver fails to link:

arm-linux-gnueabi-ld: drivers/net/phy/dp83640.o: in function `match':
dp83640.c:(.text+0x476c): undefined reference to `crc32_le'

Fixes: 539e44d26855 ("dp83640: Include hash in timestamp/packet matching")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ptp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -64,6 +64,7 @@ config DP83640_PHY
 	depends on NETWORK_PHY_TIMESTAMPING
 	depends on PHYLIB
 	depends on PTP_1588_CLOCK
+	select CRC32
 	help
 	  Supports the DP83640 PHYTER with IEEE 1588 features.
 


