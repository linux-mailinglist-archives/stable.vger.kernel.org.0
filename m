Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D107A29B6D3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368715AbgJ0P1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797738AbgJ0PZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A81AD22202;
        Tue, 27 Oct 2020 15:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812308;
        bh=V3aP/bAmjKvZth6bzJQoWBRnwTTaQ6YPbPgawguOf2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/eVTSkobQihLzzDsAOnIB+8N6imBsh77BcqDPgzIHIShIhM/r4wBQGvxcQGvj6aD
         C1SB8fPpEZkZMo+I/pbmAWAKxvbzhxkvtSVkp77Wt0AgLXjBQaN1lf+uxs/mN9iyDK
         PqZ+xfRffUYdPWBO1s9OOzRxg+vdfCcFLOM8MIfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 163/757] media: tc358743: initialize variable
Date:   Tue, 27 Oct 2020 14:46:53 +0100
Message-Id: <20201027135458.239833490@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index dbbab75f135ec..211caade9f998 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1461,7 +1461,7 @@ static int tc358743_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
 {
 	struct tc358743_state *state = dev_id;
-	bool handled;
+	bool handled = false;
 
 	tc358743_isr(&state->sd, 0, &handled);
 
-- 
2.25.1



