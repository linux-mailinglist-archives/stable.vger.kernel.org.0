Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8461ACB6A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896137AbgDPNdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896549AbgDPNcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E723E2222C;
        Thu, 16 Apr 2020 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043898;
        bh=fVibvqL9DMu1Yg/IVcb6cWJg7YBQvJjwZVNu2jm5AaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0WJil4sqgcoR5FJZvTOuLlE2hoDQvc+F/p+ahTfIGAqDpG21T1A7UD8tS0lJDlCh
         J1t2kyQwl2r702hT6SQA1Y42AbJsRX+M3sGU/uj/Mg15WEAHkE8tWExV/dMfe3gJrA
         SxBm0rh7O1eD+5sYg73W8J/PNFTq7qBHjRmBt9eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/146] misc: echo: Remove unnecessary parentheses and simplify check for zero
Date:   Thu, 16 Apr 2020 15:24:46 +0200
Message-Id: <20200416131302.195343029@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 85dc2c65e6c975baaf36ea30f2ccc0a36a8c8add ]

Clang warns when multiple pairs of parentheses are used for a single
conditional statement.

drivers/misc/echo/echo.c:384:27: warning: equality comparison with
extraneous parentheses [-Wparentheses-equality]
        if ((ec->nonupdate_dwell == 0)) {
             ~~~~~~~~~~~~~~~~~~~~^~~~
drivers/misc/echo/echo.c:384:27: note: remove extraneous parentheses
around the comparison to silence this warning
        if ((ec->nonupdate_dwell == 0)) {
            ~                    ^   ~
drivers/misc/echo/echo.c:384:27: note: use '=' to turn this equality
comparison into an assignment
        if ((ec->nonupdate_dwell == 0)) {
                                 ^~
                                 =
1 warning generated.

Remove them and while we're at it, simplify the zero check as '!var' is
used more than 'var == 0'.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/echo/echo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/echo/echo.c b/drivers/misc/echo/echo.c
index 8a5adc0d2e887..3ebe5d75ad6a2 100644
--- a/drivers/misc/echo/echo.c
+++ b/drivers/misc/echo/echo.c
@@ -381,7 +381,7 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
 	 */
 	ec->factor = 0;
 	ec->shift = 0;
-	if ((ec->nonupdate_dwell == 0)) {
+	if (!ec->nonupdate_dwell) {
 		int p, logp, shift;
 
 		/* Determine:
-- 
2.20.1



