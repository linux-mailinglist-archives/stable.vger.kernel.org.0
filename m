Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE1935BCAA
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbhDLIo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237638AbhDLIoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:44:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5BCE60241;
        Mon, 12 Apr 2021 08:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217037;
        bh=jnUE0CaMOYiyxx0A85k2dEb6Q3912c1bB9IlNE7W4bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsRCCArY3WWNBNP6ESjNLVQSzKxu9rX7ut4/Bday5zGVXQAgkpd1nN7FJx2+1/K8C
         ciCFzfTXrJo0CoXnssbhyX2GtbUtAue69aSjJxMRCmb3iqdDpQb1KR+Crof681Ftdv
         xy1WrnRcMnkFJRRhoBtI8de9SRdCF4oq39SkDkX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/66] s390/cpcmd: fix inline assembly register clobbering
Date:   Mon, 12 Apr 2021 10:40:53 +0200
Message-Id: <20210412083959.634901673@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
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



