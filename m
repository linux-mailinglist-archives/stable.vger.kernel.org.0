Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7F81F051
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbfEOL1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731887AbfEOL1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5503F20818;
        Wed, 15 May 2019 11:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919659;
        bh=CtEvnSd2nG5iRuhN/TSb86nmcmFmzPZaO4SzsCdw7A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sthSIuDtmZvzDNMQKtjkiBhb5IKWA2OkPuXCtzeOO0+3nThtcjlny5Y+/Wi648u+e
         Ego7huj0DVhKDbJqnQX8pJAA5yxSCoHlCxGd2+pVfbBwK+ClO6hVaV/9cji5AT+2Bg
         5HCugZ4/fcecXIh8F10Nryplon+tEjcPHfHjgDr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Christian Rund <Christian.Rund@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 046/137] s390/pkey: add one more argument space for debug feature entry
Date:   Wed, 15 May 2019 12:55:27 +0200
Message-Id: <20190515090656.791861565@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6b1f16ba730d4c0cda1247568c3a1bf4fa3a2f2f ]

The debug feature entries have been used with up to 5 arguents
(including the pointer to the format string) but there was only
space reserved for 4 arguemnts. So now the registration does
reserve space for 5 times a long value.

This fixes a sometime appearing weired value as the last
value of an debug feature entry like this:

... pkey_sec2protkey zcrypt_send_cprb (cardnr=10 domain=12)
   failed with errno -2143346254

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reported-by: Christian Rund <Christian.Rund@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 2f92bbed4bf68..097e890e0d6d9 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -51,7 +51,8 @@ static debug_info_t *debug_info;
 
 static void __init pkey_debug_init(void)
 {
-	debug_info = debug_register("pkey", 1, 1, 4 * sizeof(long));
+	/* 5 arguments per dbf entry (including the format string ptr) */
+	debug_info = debug_register("pkey", 1, 1, 5 * sizeof(long));
 	debug_register_view(debug_info, &debug_sprintf_view);
 	debug_set_level(debug_info, 3);
 }
-- 
2.20.1



