Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8BC106371
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfKVF4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:56:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbfKVF4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF3BA2071B;
        Fri, 22 Nov 2019 05:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402205;
        bh=vL+/RDK10ml6Tv/n+U2H4e/OwtvIvXxku6Fqr6Xlm1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgrdgTFu/glSc2X1OF69fmyJawzW5jsE9F0afJlxIw3uf24gXEKe/GJj0lLZnmKvS
         EVEFGHBOu1GHTUB3TWqisgDcV8N7MyxU24u5DUKsOz+cjL5Q7F6osshLZ8uDAsYX82
         q6MhPfGH7cbmT2ghhc/XAHV/13We6OOcQtIyvvvk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 054/127] powerpc/xmon: fix dump_segments()
Date:   Fri, 22 Nov 2019 00:54:32 -0500
Message-Id: <20191122055544.3299-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5a739588aa505..51a53fd517229 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -3293,7 +3293,7 @@ void dump_segments(void)
 
 	printf("sr0-15 =");
 	for (i = 0; i < 16; ++i)
-		printf(" %x", mfsrin(i));
+		printf(" %x", mfsrin(i << 28));
 	printf("\n");
 }
 #endif
-- 
2.20.1

