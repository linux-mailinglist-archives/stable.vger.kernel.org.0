Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58E110BFB2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfK0Uft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfK0Uft (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:35:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF0F7207DD;
        Wed, 27 Nov 2019 20:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886948;
        bh=D6JT7FvDOOq9sWuwoDemas30vIqXwcUFtXk+E/9t1d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0l7jFV4DWJEKiyScQchP5HpNID8P55vWWkHdqALAaIfA8O+LmyV7L5+Ws55wmwDK
         bwdZzrijb0ndzhGkfR7E1TIvbXKe2sQWWfJ+zKnFYIlULvwyVM59MCrqHD6RaS+lxJ
         TSAfRhisIpvrEoNJ6wI4yWzU/5Q/yjlQQ7qlevpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 053/132] rtc: s35390a: Change bufs type to u8 in s35390a_init
Date:   Wed, 27 Nov 2019 21:30:44 +0100
Message-Id: <20191127202951.811690952@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit ef0f02fd69a02b50e468a4ddbe33e3d81671e248 ]

Clang warns:

drivers/rtc/rtc-s35390a.c:124:27: warning: implicit conversion from
'int' to 'char' changes value from 192 to -64 [-Wconstant-conversion]
        buf = S35390A_FLAG_RESET | S35390A_FLAG_24H;
            ~ ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~
1 warning generated.

Update buf to be an unsigned 8-bit integer, which matches the buf member
in struct i2c_msg.

https://github.com/ClangBuiltLinux/linux/issues/145
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 00662dd28d66a..9a931efd50d36 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -106,7 +106,7 @@ static int s35390a_get_reg(struct s35390a *s35390a, int reg, char *buf, int len)
  */
 static int s35390a_reset(struct s35390a *s35390a, char *status1)
 {
-	char buf;
+	u8 buf;
 	int ret;
 	unsigned initcount = 0;
 
-- 
2.20.1



