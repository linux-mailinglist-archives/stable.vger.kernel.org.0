Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC8B3E7EF2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhHJRgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232253AbhHJRdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A4E61075;
        Tue, 10 Aug 2021 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616798;
        bh=SryW2t5Ze+b9tM3zx8bHTZ7bmm+Zqps8jt+VAt59OcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=td8SUrclf9GvviuIdw9pqZyjNuUbajJYK0JomuYhlp+vnM4BVfJ3XE6UNqOdBxeXe
         aomIBwmU28JI85zReNCSDS5Ez58rwUApOKeahOTkLXEIlhrtBrnbHepw99g15VoktO
         brH4drklsm3ddkztjZdKZz8FBcxxEZvkbhy2G0+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/54] alpha: Send stop IPI to send to online CPUs
Date:   Tue, 10 Aug 2021 19:30:46 +0200
Message-Id: <20210810172945.923147335@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit caace6ca4e06f09413fb8f8a63319594cfb7d47d ]

This issue was noticed while debugging a shutdown issue where some
secondary CPUs are not being shutdown correctly.  A fix for that [1] requires
that secondary cpus be offlined using the cpu_online_mask so that the
stop operation is a no-op if CPU HOTPLUG is disabled.  I, like the author in
[1] looked at the architectures and found that alpha is one of two
architectures that executes smp_send_stop() on all possible CPUs.

On alpha, smp_send_stop() sends an IPI to all possible CPUs but only needs
to send them to online CPUs.

Send the stop IPI to only the online CPUs.

[1] https://lkml.org/lkml/2020/1/10/250

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index d0dccae53ba9..8a89b9adb4fe 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -585,7 +585,7 @@ void
 smp_send_stop(void)
 {
 	cpumask_t to_whom;
-	cpumask_copy(&to_whom, cpu_possible_mask);
+	cpumask_copy(&to_whom, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &to_whom);
 #ifdef DEBUG_IPI_MSG
 	if (hard_smp_processor_id() != boot_cpu_id)
-- 
2.30.2



