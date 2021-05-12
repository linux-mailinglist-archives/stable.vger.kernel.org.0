Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9137CCA5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbhELQn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243132AbhELQgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1614F61CCB;
        Wed, 12 May 2021 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835255;
        bh=Sc2+fszKB70vsfZLub3ol4BHs4BQr+egnCgAZHPvA/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0DF+QfaV0zULiTmVAXOZrIqzTWJPY22z89j+ZXkA9h2bDNiPK4CJp6guwUE0ZPt+
         y9IrRjfKJJvPzTVVEt/IJO6oizxSHiJWzW6BmVU5lBWiKaV0604caV6Jl0/B9uvZtG
         8zkjGaOXXlxrFlpWk5hMDL3pxcvZkmSvkbAdECYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dong Aisheng <aisheng.dong@nxp.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 271/677] PM / devfreq: Use more accurate returned new_freq as resume_freq
Date:   Wed, 12 May 2021 16:45:17 +0200
Message-Id: <20210512144846.228904504@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index e4be0435c9ba..59ba59bea0f5 100644
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



