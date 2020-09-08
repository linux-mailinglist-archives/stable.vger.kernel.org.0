Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EAB2619CC
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731435AbgIHS0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731260AbgIHQKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:10:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F5F222EB;
        Tue,  8 Sep 2020 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579632;
        bh=fU1AnG/zaMBACK60HxI1F2TW0+tRRCj8Ydg7utsqoww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPGYbVoC3eK8uFQUqLJZLs5ym9jGpmDbuS80D1bJW2y6j5tHrEOlWFOVeZEktydgD
         2vhC7NbgZ8sTU4EbAXB2JlSsJ844fLE735bW8AZKE5McRmLhiLuya2SRt4C14onYho
         KuIB6Tske2p6Qh5a4FBa2gE2hlTVKmRukYK//qiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.8 158/186] mips/oprofile: Fix fallthrough placement
Date:   Tue,  8 Sep 2020 17:25:00 +0200
Message-Id: <20200908152249.321591016@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

commit 91dbd73a1739039fa7e9fe5c0169f2817a7f7670 upstream.

We want neither
"
include/linux/compiler_attributes.h:201:41: warning: statement will never
be executed [-Wswitch-unreachable]
  201 | # define fallthrough __attribute__((__fallthrough__))
      |                      ^~~~~~~~~~~~~
"
nor
"
include/linux/compiler_attributes.h:201:41: warning: attribute
'fallthrough' not preceding a case label or default label
  201 | # define fallthrough __attribute__((__fallthrough__))
      |                      ^~~~~~~~~~~~~
"

It's not worth adding one more macro. Let's simply place the fallthrough
in between the expansions.

Fixes: c9b029903466 ("MIPS: Use fallthrough for arch/mips")
Cc: stable@vger.kernel.org
Signed-off-by: He Zhe <zhe.he@windriver.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/oprofile/op_model_mipsxx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -245,7 +245,6 @@ static int mipsxx_perfcount_handler(void
 
 	switch (counters) {
 #define HANDLE_COUNTER(n)						\
-	fallthrough;							\
 	case n + 1:							\
 		control = r_c0_perfctrl ## n();				\
 		counter = r_c0_perfcntr ## n();				\
@@ -256,8 +255,11 @@ static int mipsxx_perfcount_handler(void
 			handled = IRQ_HANDLED;				\
 		}
 	HANDLE_COUNTER(3)
+	fallthrough;
 	HANDLE_COUNTER(2)
+	fallthrough;
 	HANDLE_COUNTER(1)
+	fallthrough;
 	HANDLE_COUNTER(0)
 	}
 


