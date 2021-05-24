Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA91C38EA2C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhEXOw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233191AbhEXOux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685C06140A;
        Mon, 24 May 2021 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867673;
        bh=b2hoTEC5uqobuuzMRsBFsNEWCV8ogZnhjo5R2n1ILIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+aNFyX5Gjr29kGgiHHxgyNud/TebfNwAACYe9pyXVDYGwj0H5DFkxtrNPSkzbSCF
         0tjmIaGJEpLQCTAkwnBiRmb+zDwGdoLa8pL25h8esWBkPBWD4jwEdzYSrep0B+PF3r
         ijzvwj/Er2KELZ3FFez251wSTED0urHj8RwSc3saTuFCJi43d5DE+HD2rzm8I+/mR9
         YtS3JZ+cPcmfU+Yyy7mAl+BKwJ7X5dIoFd+Jjvda/h4p+SxLm6lJn5ppFJDa9QYRkr
         lRSIoxboE/4BR0epluouy/eYnB9S9dMe/t3egGSvlFzEE/m4asa7UWd0x4P1Ghyk1O
         CriarqDA6/MwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/62] serial: max310x: unregister uart driver in case of failure and abort
Date:   Mon, 24 May 2021 10:46:48 -0400
Message-Id: <20210524144744.2497894-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atul Gopinathan <atulgopinathan@gmail.com>

[ Upstream commit 3890e3dea315f1a257d1b940a2a4e2fa16a7b095 ]

The macro "spi_register_driver" invokes the function
"__spi_register_driver()" which has a return type of int and can fail,
returning a negative value in such a case. This is currently ignored and
the init() function yields success even if the spi driver failed to
register.

Fix this by collecting the return value of "__spi_register_driver()" and
also unregister the uart driver in case of failure.

Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-12-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index f60b7b86d099..5bf8dd6198bb 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1527,10 +1527,12 @@ static int __init max310x_uart_init(void)
 		return ret;
 
 #ifdef CONFIG_SPI_MASTER
-	spi_register_driver(&max310x_spi_driver);
+	ret = spi_register_driver(&max310x_spi_driver);
+	if (ret)
+		uart_unregister_driver(&max310x_uart);
 #endif
 
-	return 0;
+	return ret;
 }
 module_init(max310x_uart_init);
 
-- 
2.30.2

