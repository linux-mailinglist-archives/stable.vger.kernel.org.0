Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5055135BDB0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbhDLIw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhDLItr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 337566135A;
        Mon, 12 Apr 2021 08:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217326;
        bh=jnUE0CaMOYiyxx0A85k2dEb6Q3912c1bB9IlNE7W4bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GglbFrC+AXE3lyMUGtimNlS8nCMfsTRNikZj5nyR2ovC+hc/iRThyg42QMaHQRKaQ
         LimELUUu6BPgTW4DIwcSi5LolxDQP28u7GcbgDO2Cu7kFOUUY1Nf2s1IFxUKqPP2HU
         5BZKHztbfMRTCdIeTycSo8W2UGxhAISPvluID2Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/111] s390/cpcmd: fix inline assembly register clobbering
Date:   Mon, 12 Apr 2021 10:41:03 +0200
Message-Id: <20210412084007.087884494@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 7a2f91441b2c1d81b77c1cd816a4659f4abc9cbe ]

Register variables initialized using arithmetic. That leads to
kasan instrumentaton code corrupting the registers contents.
Follow GCC guidlines and use temporary variables for assigning
init values to register variables.

Fixes: 94c12cc7d196 ("[S390] Inline assembly cleanup.")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://gcc.gnu.org/onlinedocs/gcc-10.2.0/gcc/Local-Register-Variables.html
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/cpcmd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/cpcmd.c b/arch/s390/kernel/cpcmd.c
index af013b4244d3..2da027359798 100644
--- a/arch/s390/kernel/cpcmd.c
+++ b/arch/s390/kernel/cpcmd.c
@@ -37,10 +37,12 @@ static int diag8_noresponse(int cmdlen)
 
 static int diag8_response(int cmdlen, char *response, int *rlen)
 {
+	unsigned long _cmdlen = cmdlen | 0x40000000L;
+	unsigned long _rlen = *rlen;
 	register unsigned long reg2 asm ("2") = (addr_t) cpcmd_buf;
 	register unsigned long reg3 asm ("3") = (addr_t) response;
-	register unsigned long reg4 asm ("4") = cmdlen | 0x40000000L;
-	register unsigned long reg5 asm ("5") = *rlen;
+	register unsigned long reg4 asm ("4") = _cmdlen;
+	register unsigned long reg5 asm ("5") = _rlen;
 
 	asm volatile(
 		"	diag	%2,%0,0x8\n"
-- 
2.30.2



