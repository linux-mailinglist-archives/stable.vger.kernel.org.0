Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547372E3DCA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436560AbgL1OUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408006AbgL1OUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C9A8224D2;
        Mon, 28 Dec 2020 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165164;
        bh=dsO4pAir/3Nd1Q/udkQLs/3ftxCvTKnhFW5oc9/Dqu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFIQTk2PDVdLVw1amZERM+PIokfC3txzOIyTXTbFRFSGZqfBv5uAGHWkD3YfKORBg
         XOYOpjxR6HdUFNOM9iu3IBdK5f0A+Vxc2AQYsEE86wJlByMPLL7pFGGOwRzJRlrATG
         QcnwUQDX2Ejk6iOnFRKSSAc7BYHU3h4cxtxZEjsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/717] um: Monitor error events in IRQ controller
Date:   Mon, 28 Dec 2020 13:47:12 +0100
Message-Id: <20201228125041.764461551@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

[ Upstream commit e3a01cbee9c5f2c6fc813dd6af007716e60257e7 ]

Ensure that file closes, connection closes, etc are propagated
as interrupts in the interrupt controller.

Fixes: ff6a17989c08 ("Epoll based IRQ controller")
Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/os-Linux/irq.c b/arch/um/os-Linux/irq.c
index d508310ee5e1e..f1732c308c615 100644
--- a/arch/um/os-Linux/irq.c
+++ b/arch/um/os-Linux/irq.c
@@ -48,7 +48,7 @@ int os_epoll_triggered(int index, int events)
 int os_event_mask(int irq_type)
 {
 	if (irq_type == IRQ_READ)
-		return EPOLLIN | EPOLLPRI;
+		return EPOLLIN | EPOLLPRI | EPOLLERR | EPOLLHUP | EPOLLRDHUP;
 	if (irq_type == IRQ_WRITE)
 		return EPOLLOUT;
 	return 0;
-- 
2.27.0



