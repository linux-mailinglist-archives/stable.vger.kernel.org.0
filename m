Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2CF20D6FC
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732686AbgF2TZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732669AbgF2TZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC04D2540E;
        Mon, 29 Jun 2020 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445360;
        bh=E+UNJVGrva68eXJn+LCdpez1aQGF2KWOGq6upO0Ng/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DArmL8+Y8+nUNoaYpciK+JjOEt5Vj1w21q+kni6tFCFX84EagJNaU1w6hm+xQSQoZ
         sVGMvy0N/zCLOus1HzlcxTuhNcFjf43zSPf5iZwF1Yk3Z4tQq6HzXc1Z1lXKPxw1nr
         C0ekIDZazUGvAB/EPGGr0IktYBmBGQEOLPzYy3Qc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 117/191] media: dvb_frontend: fix wrong cast in compat_ioctl
Date:   Mon, 29 Jun 2020 11:38:53 -0400
Message-Id: <20200629154007.2495120-118-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>

commit 5c6c9c4830b76d851d38829611b3c3e4be0f5cdf upstream

FE_GET_PROPERTY has always failed as following situations:
  - Use compatible ioctl
  - The array of 'struct dtv_property' has 2 or more items

This patch fixes wrong cast to a pointer 'struct dtv_property' from a
pointer of 2nd or after item of 'struct compat_dtv_property' array.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 34f55a2ba071d..740dedf033616 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2081,7 +2081,7 @@ static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
 		}
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(
-			    fe, &getp, (struct dtv_property *)tvp + i, file);
+			    fe, &getp, (struct dtv_property *)(tvp + i), file);
 			if (err < 0) {
 				kfree(tvp);
 				return err;
-- 
2.25.1

