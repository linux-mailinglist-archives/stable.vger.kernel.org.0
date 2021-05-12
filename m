Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B573437C89C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhELQLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238638AbhELQFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3888261CED;
        Wed, 12 May 2021 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833683;
        bh=NnUGC9+zGpms/HExz7KSj/gytAxWQWEBbGsvgB1qj5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMqESuUUddX80/XcE2I9JypQkbPN5kDXGuwR4OusAOoeGpCPPKBAjQ2UMBd+KL6Pg
         SgXyva/boYz5KyvZ9eoULVKgeVaXeLC5sbTs7477dDpgQMKEVKBV9TdECATef5Sfwh
         YQ3vyfHfcU/JbBBJjl9Q0mXTjOBs3eRwv6aICE5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dong Aisheng <aisheng.dong@nxp.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 246/601] PM / devfreq: Use more accurate returned new_freq as resume_freq
Date:   Wed, 12 May 2021 16:45:23 +0200
Message-Id: <20210512144835.933529273@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

[ Upstream commit 62453f1ba5d5def9d58e140a50f3f168f028da38 ]

Use the more accurate returned new_freq as resume_freq.
It's the same as how devfreq->previous_freq was updated.

Fixes: 83f8ca45afbf0 ("PM / devfreq: add support for suspend/resume of a devfreq device")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 7473405b9c23..6459dacb0697 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -387,7 +387,7 @@ static int devfreq_set_target(struct devfreq *devfreq, unsigned long new_freq,
 	devfreq->previous_freq = new_freq;
 
 	if (devfreq->suspend_freq)
-		devfreq->resume_freq = cur_freq;
+		devfreq->resume_freq = new_freq;
 
 	return err;
 }
-- 
2.30.2



