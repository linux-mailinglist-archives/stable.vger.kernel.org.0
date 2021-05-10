Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C04B3782A5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhEJKgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhEJKeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58DBC61490;
        Mon, 10 May 2021 10:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642477;
        bh=6g2XKRRArM4saSLPY4VUkIIpd6tY+pCZaErkAo72feE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tw/Fmw4NVa60+C/BwA1TdxbeTVADCBkuFUkLtaHlqiAWSb00FpU7k+OTjYJSZTCR
         fhBthUeAF7KsyFTInwSILp9r8UaDMM5cnC7KHLk741f45ETS5KQi+Mh6jB90dQvp03
         0T7u7PlmJTonV15VGx6EKO1KUtBR8u8KFViYfzAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/184] media: platform: sti: Fix runtime PM imbalance in regs_show
Date:   Mon, 10 May 2021 12:20:04 +0200
Message-Id: <20210510101953.793223245@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 69306a947b3ae21e0d1cbfc9508f00fec86c7297 ]

pm_runtime_get_sync() will increase the runtime PM counter
even it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/bdisp/bdisp-debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c b/drivers/media/platform/sti/bdisp/bdisp-debug.c
index 77ca7517fa3e..bae62af82643 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
@@ -480,7 +480,7 @@ static int regs_show(struct seq_file *s, void *data)
 	int ret;
 	unsigned int i;
 
-	ret = pm_runtime_get_sync(bdisp->dev);
+	ret = pm_runtime_resume_and_get(bdisp->dev);
 	if (ret < 0) {
 		seq_puts(s, "Cannot wake up IP\n");
 		return 0;
-- 
2.30.2



