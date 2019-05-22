Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B730B26C23
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbfEVTbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387541AbfEVTbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:31:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7B8420879;
        Wed, 22 May 2019 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553494;
        bh=NiqXvwojC1D7C1RXV3saA1gnnXcxvKec8v+zqiUIXuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvEZL4xRbcqiqtQ83tR8Jv79fbyUjRaDSFqNKdVp1S/Tb5QYzZyXFpPH4CZzSz4ow
         prRMR5OyR1irI3+c8QN08t3cphtWI0Vy6jKVSU5mD1Q+XitMCOLAq5cJDCmuunVEkH
         xAUivBy9GNFEOHvQEOG9mco07k7MXkeCKB5u0t1s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bo YU <tsu.yubo@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 04/92] powerpc/boot: Fix missing check of lseek() return value
Date:   Wed, 22 May 2019 15:29:59 -0400
Message-Id: <20190522193127.27079-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193127.27079-1-sashal@kernel.org>
References: <20190522193127.27079-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bo YU <tsu.yubo@gmail.com>

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

