Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 728879E162
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfH0IAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730351AbfH0IAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:00:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96E47217F5;
        Tue, 27 Aug 2019 08:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892818;
        bh=mmRLWluwhVprgaKSs4nQV6TYB0RRn5wKy+LaxHGc4DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dl0qgtotKw7gqfMomFp/esPpUL0wx9LzbJhGbiQ8jdgHPvbKplehcFOi8gLi5C67
         HXqMUknA2ekZXMmRLJZirg7mY6R5p/WUj5UDlsYo8oKgSRWsTF4UPg+Xa44OfoTWDO
         QFtRR3hKWkRrKv9IrskVn6PD4B71qv+6k4wX5BaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 025/162] ASoC: dapm: fix a memory leak bug
Date:   Tue, 27 Aug 2019 09:49:13 +0200
Message-Id: <20190827072739.183222945@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 45004d66f2a28d78f543fb2ffbc133e31dc2d162 ]

In snd_soc_dapm_new_control_unlocked(), a kernel buffer is allocated in
dapm_cnew_widget() to hold the new dapm widget. Then, different actions are
taken according to the id of the widget, i.e., 'w->id'. If any failure
occurs during this process, snd_soc_dapm_new_control_unlocked() should be
terminated by going to the 'request_failed' label. However, the allocated
kernel buffer is not freed on this code path, leading to a memory leak bug.

To fix the above issue, free the buffer before returning from
snd_soc_dapm_new_control_unlocked() through the 'request_failed' label.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Link: https://lore.kernel.org/r/1563803864-2809-1-git-send-email-wang6495@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 835ce1ff188d9..f40adb604c25b 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3705,6 +3705,8 @@ request_failed:
 		dev_err(dapm->dev, "ASoC: Failed to request %s: %d\n",
 			w->name, ret);
 
+	kfree_const(w->sname);
+	kfree(w);
 	return ERR_PTR(ret);
 }
 
-- 
2.20.1



