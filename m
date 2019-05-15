Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9191F103
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbfEOLTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbfEOLTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E6F20862;
        Wed, 15 May 2019 11:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919172;
        bh=7V09QRjt60ZoGduRDcBVlYnjKvUofVsyA/iKeUO4JdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQIF0Vs+9BRDxFFTnLvnaiooGE9umLyDHfKgledFUTQLB2nbi9icpkT1V8CcesEOf
         9RevlfTErlloQupWksiInPzj9/fQj8wpJmJ3Si0/CReOpqpiuK5qHl279DTkUaUOuk
         rA7VrNv04g98QZ3/72Mla1XYMrdtCvYjX/Oymybw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 092/115] nfc: nci: Potential off by one in ->pipes[] array
Date:   Wed, 15 May 2019 12:56:12 +0200
Message-Id: <20190515090705.919773981@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6491d698396fd5da4941980a35ca7c162a672016 ]

This is similar to commit e285d5bfb7e9 ("NFC: Fix the number of pipes")
where we changed NFC_HCI_MAX_PIPES from 127 to 128.

As the comment next to the define explains, the pipe identifier is 7
bits long.  The highest possible pipe is 127, but the number of possible
pipes is 128.  As the code is now, then there is potential for an
out of bounds array access:

    net/nfc/nci/hci.c:297 nci_hci_cmd_received() warn: array off by one?
    'ndev->hci_dev->pipes[pipe]' '0-127 == 127'

Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 include/net/nfc/nci_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 87499b6b35d6d..df5c69db68afc 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -166,7 +166,7 @@ struct nci_conn_info {
  * According to specification 102 622 chapter 4.4 Pipes,
  * the pipe identifier is 7 bits long.
  */
-#define NCI_HCI_MAX_PIPES          127
+#define NCI_HCI_MAX_PIPES          128
 
 struct nci_hci_gate {
 	u8 gate;
-- 
2.20.1



