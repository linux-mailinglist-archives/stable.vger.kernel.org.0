Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D42329AE70
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJ0OAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753246AbgJ0N7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:59:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD922068D;
        Tue, 27 Oct 2020 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807163;
        bh=jqDXK0s6p9Ni/uBdvRk9fAiRHa1Efno5M6IXDNS++3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwEhsAqAsQaaF/0ytXt/RoBtH54Ib6cDw6f2PJS4vsWeT6TS0rRCqGmmV6AKES3+s
         iyD70Fw8sqCIx3cZH0rLj4Vw4vBpsQjCVf7KstUAtLyLZ/N4FkECBEU+765+FI/uF1
         IzRWBA3QMsfAkOd2rgDSUYrzo4/z7wya1wabolKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 025/112] media: tc358743: initialize variable
Date:   Tue, 27 Oct 2020 14:48:55 +0100
Message-Id: <20201027134901.755445472@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 274cf92d5dff5c2fec1a518078542ffe70d07646 ]

clang static analysis flags this error

tc358743.c:1468:9: warning: Branch condition evaluates
  to a garbage value
        return handled ? IRQ_HANDLED : IRQ_NONE;
               ^~~~~~~
handled should be initialized to false.

Fixes: d747b806abf4 ("[media] tc358743: add direct interrupt handling")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358743.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index bc630a7197761..1e95fdb61041b 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1325,7 +1325,7 @@ static int tc358743_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
 {
 	struct tc358743_state *state = dev_id;
-	bool handled;
+	bool handled = false;
 
 	tc358743_isr(&state->sd, 0, &handled);
 
-- 
2.25.1



