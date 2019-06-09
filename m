Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13293A986
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388149AbfFIRBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388131AbfFIRBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:01:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E0CD208C0;
        Sun,  9 Jun 2019 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099712;
        bh=UT5ptIzvBWmArzRHvLDDWZswCaWyxEW9/R4B4KcsSDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcwdO+4ohZGs154fSE2S+pSbIC8I2mVM/FXh+Q84/yhTA4uBBKsqB9PtcD/WfOzdi
         /DBMe2wI3hkhq8i9Y/Fs+6SzTk1YpvJTfw+V+tC07Ip2CBH21GIK3U584QVq+A1/KT
         KoJqFyPWA5p/PwdDcKXOmDb98lH1uCQPwzq/9KWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo YU <tsu.yubo@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 096/241] powerpc/boot: Fix missing check of lseek() return value
Date:   Sun,  9 Jun 2019 18:40:38 +0200
Message-Id: <20190609164150.565716531@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5d085ec04a000fefb5182d3b03ee46ca96d8389b ]

This is detected by Coverity scan: CID: 1440481

Signed-off-by: Bo YU <tsu.yubo@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/addnote.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/addnote.c b/arch/powerpc/boot/addnote.c
index 9d9f6f334d3cc..3da3e2b1b51bc 100644
--- a/arch/powerpc/boot/addnote.c
+++ b/arch/powerpc/boot/addnote.c
@@ -223,7 +223,11 @@ main(int ac, char **av)
 	PUT_16(E_PHNUM, np + 2);
 
 	/* write back */
-	lseek(fd, (long) 0, SEEK_SET);
+	i = lseek(fd, (long) 0, SEEK_SET);
+	if (i < 0) {
+		perror("lseek");
+		exit(1);
+	}
 	i = write(fd, buf, n);
 	if (i < 0) {
 		perror("write");
-- 
2.20.1



