Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFB91063DF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfKVGNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:13:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbfKVGNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C621B20708;
        Fri, 22 Nov 2019 06:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403216;
        bh=CsJ6NMkhQ1MqGC/QkU81r69PevTmEsSjctnV4K7BBFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojTy7NDR6CN8/MaW9ZFi4QaKueVrbANU/57x2/HnvX4SrNn5RMzQcnMFyCr/hg1Ka
         Bi85M9K7zNh5owlNDjUJsN9Rg30ZrvHZcoCQNr27PcewZaT42q52EohM1+HHx74N5s
         DznCFxzXyVlSYDJ1Lsm1T7GqJchvarFhnaSBmVC8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 31/68] powerpc/xmon: fix dump_segments()
Date:   Fri, 22 Nov 2019 01:12:24 -0500
Message-Id: <20191122061301.4947-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
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
index 83619ebede93d..dc2ebc20a96f8 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -2840,7 +2840,7 @@ void dump_segments(void)
 
 	printf("sr0-15 =");
 	for (i = 0; i < 16; ++i)
-		printf(" %x", mfsrin(i));
+		printf(" %x", mfsrin(i << 28));
 	printf("\n");
 }
 #endif
-- 
2.20.1

