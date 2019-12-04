Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F041E113373
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbfLDSLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:11:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731478AbfLDSLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:11:37 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CC1820863;
        Wed,  4 Dec 2019 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483096;
        bh=ET+DFIQMOkHhXcT1P7hHhRmwzDhIgs682udKVkzTbRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPd9lJpYGREEr1ToqiE23p/bvKEn4yxjp010VQtZEWoebG92+7zKb5y9qGH/bTFAw
         2U+izhKfc0aolUu6Zx6X+IjpNHvKTMbyUrj+RgyX4NOWTnKD/tPiaactTtKkfKMwxM
         C/aHciRdDMdW5Qdn+NfTxrIhD4/VOfzrOMC1NFpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/125] powerpc/xmon: fix dump_segments()
Date:   Wed,  4 Dec 2019 18:55:56 +0100
Message-Id: <20191204175322.101953708@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 32c8c4c621897199e690760c2d57054f8b84b6e6 ]

mfsrin() takes segment num from bits 31-28 (IBM bits 0-3).

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
[mpe: Clarify bit numbering]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 687e8b8bf5c67..899288b71145e 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -3043,7 +3043,7 @@ void dump_segments(void)
 
 	printf("sr0-15 =");
 	for (i = 0; i < 16; ++i)
-		printf(" %x", mfsrin(i));
+		printf(" %x", mfsrin(i << 28));
 	printf("\n");
 }
 #endif
-- 
2.20.1



