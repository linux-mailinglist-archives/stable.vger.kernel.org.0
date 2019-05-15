Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666F31F187
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfEOLy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730637AbfEOLSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57F2820818;
        Wed, 15 May 2019 11:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919116;
        bh=Gi0mXYSUl7AGjIwZHG2n41VtWx97EL72PQKIdzQj5wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Amg/CLWs00vML6Rt8wHqcU9DMeiE5ul+td380OoIulxdBhJyXh+BlvYHiDrRrkchG
         IdM9e6M4QckhS9oLnkqry9SgDTmjmRBohT0XPCMqMZ4j3HZEipQt8E4naiO/TT++82
         bGOaUaHErd13Ks8vz4jasc8QcahG7obTx4aAx8X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@linaro.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 073/115] vt: always call notifier with the console lock held
Date:   Wed, 15 May 2019 12:55:53 +0200
Message-Id: <20190515090704.731040228@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7e1d226345f89ad5d0216a9092c81386c89b4983 ]

Every invocation of notify_write() and notify_update() is performed
under the console lock, except for one case. Let's fix that.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/tty/vt/vt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 1fb5e7f409c4a..6ff921cf9a9e4 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2435,8 +2435,8 @@ static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int co
 	}
 	con_flush(vc, draw_from, draw_to, &draw_x);
 	console_conditional_schedule();
-	console_unlock();
 	notify_update(vc);
+	console_unlock();
 	return n;
 }
 
-- 
2.20.1



