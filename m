Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5729D15ACE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfEGFtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbfEGFkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A95C20578;
        Tue,  7 May 2019 05:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207634;
        bh=vJiiGf5Sbzi6bUUBQCpuymz7/VsovrdQydGy4HPfTEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UXjeop/SvOvjpM/6U38A0U6j1SIfnlt53OvZyKz19iE7isKxmcYVFJKGAOqdmvYe
         WCLIxMrofFlkAEwZamWkAJ03dKCuqdRXWdkdLX53kfCVsPQSEgDxVPNptcjQLKCOF4
         rskDeFOb3AN0oaSDO91ts2k9CU3kMnO0UDkPn0R8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Pitre <nicolas.pitre@linaro.org>,
        Nicolas Pitre <nico@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH AUTOSEL 4.14 70/95] vt: always call notifier with the console lock held
Date:   Tue,  7 May 2019 01:37:59 -0400
Message-Id: <20190507053826.31622-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

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
index 1fb5e7f409c4..6ff921cf9a9e 100644
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

