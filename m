Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A03148347
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404761AbgAXLes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404554AbgAXLer (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:34:47 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B8D1214AF;
        Fri, 24 Jan 2020 11:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865687;
        bh=W2BbV80fV5kcpEqWWvIsJPKoZwQoUK2B7KmrxaYr6+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CH/kY4ncBRM26DCEy/Qgm/Rw9V3ZOVmgxGNifz3B37gCJSgIpUSd1jpp4IZNrz11U
         IK49omo9md3H6fHt6plBoxJe5XQZ/13nfsZ6SQe6UzoKAzT7jehTThnaSJIjA+2LnW
         KesJjiLg/XBko6iwKke/x34cXmwpZP/zXo61G1ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 599/639] net: avoid possible false sharing in sk_leave_memory_pressure()
Date:   Fri, 24 Jan 2020 10:32:49 +0100
Message-Id: <20200124093204.391643194@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 503978aca46124cd714703e180b9c8292ba50ba7 ]

As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
a C compiler can legally transform :

if (memory_pressure && *memory_pressure)
        *memory_pressure = 0;

to :

if (memory_pressure)
        *memory_pressure = 0;

Fixes: 0604475119de ("tcp: add TCPMemoryPressuresChrono counter")
Fixes: 180d8cd942ce ("foundations of per-cgroup memory pressure controlling.")
Fixes: 3ab224be6d69 ("[NET] CORE: Introducing new memory accounting interface.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bbde5f6a7dc91..b9ec14f2c729a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2179,8 +2179,8 @@ static void sk_leave_memory_pressure(struct sock *sk)
 	} else {
 		unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
 
-		if (memory_pressure && *memory_pressure)
-			*memory_pressure = 0;
+		if (memory_pressure && READ_ONCE(*memory_pressure))
+			WRITE_ONCE(*memory_pressure, 0);
 	}
 }
 
-- 
2.20.1



