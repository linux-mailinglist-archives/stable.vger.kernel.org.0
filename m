Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BF046389A
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244471AbhK3PFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243214AbhK3O6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:58:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23713C0613B7;
        Tue, 30 Nov 2021 06:51:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7060CCE1A5B;
        Tue, 30 Nov 2021 14:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A00C53FCF;
        Tue, 30 Nov 2021 14:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283907;
        bh=0NDsr83+EogaVnAmGrqnMsG/gXmouT8EdiQm/ybL3W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNrxbFLpfQzrGO7YcILMDjm/6TBS1uY4hZp3ev/dkHKKt2OrdGH+Dvw9gQ7JfSeW+
         0ZTH42p1yyKgu0m0A+TOG3ritbyUc2ekR87EwZhW71fR7am5DOoCxn5xYngFtXa73K
         HlGxElJCmWrDL55Hckac39r0x/HlHuN8dV7uxlcMMaD2nd/0CdTZZG+TvAhtYxMeaJ
         TdjX+QQWEsytomB8ReY56fGBnRWAJdVSW1AUXwLljAFm0S3sKqVPbXoMrKpPbNRhUR
         rt7tR3/rUJp3eztFbJS/dd1pzFLhrEvpQursvSWqXVG9/c+8X3pEAGvKbyAeLjtLT4
         jMMxWsymbVTtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, xen-devel@lists.xenproject.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 38/43] xen: flag xen_snd_front to be not essential for system boot
Date:   Tue, 30 Nov 2021 09:50:15 -0500
Message-Id: <20211130145022.945517-38-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit de6da33e6cb79abd4a5721b65b9a7dbed24378f8 ]

The Xen pv sound driver is not essential for booting. Set the respective
flag.

[boris: replace semicolon with comma]

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211022064800.14978-6-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/xen/xen_snd_front.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/xen/xen_snd_front.c b/sound/xen/xen_snd_front.c
index 228d820312973..33ebba73f6c08 100644
--- a/sound/xen/xen_snd_front.c
+++ b/sound/xen/xen_snd_front.c
@@ -358,6 +358,7 @@ static struct xenbus_driver xen_driver = {
 	.probe = xen_drv_probe,
 	.remove = xen_drv_remove,
 	.otherend_changed = sndback_changed,
+	.not_essential = true,
 };
 
 static int __init xen_drv_init(void)
-- 
2.33.0

