Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9333D3788BC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhEJLXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237224AbhEJLLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9990D6162B;
        Mon, 10 May 2021 11:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644896;
        bh=8JuOBfHGY6464xmuus0V/491IaJ6X4Av8CBmTmKKVJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsBML95ULNUHdNEz7gDEzrXkh5szNAzh2/6gf6WILN0DKUQp5sDyTyh/VP/8oghj3
         c8/zbj8qICrY/wyywU/I7rtAjnWKpQsXchD1CwaMbLuvf6edlSO0CHbB50MJJXMBSD
         5ADbbJcXlN/uPZEpq5SzzVkbPI4DJG4uRRFNotpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 234/384] media: platform: sti: Fix runtime PM imbalance in regs_show
Date:   Mon, 10 May 2021 12:20:23 +0200
Message-Id: <20210510102022.603813508@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index 2b270093009c..a27f638df11c 100644
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



