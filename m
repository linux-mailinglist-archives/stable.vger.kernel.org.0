Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1007C21FA9F
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgGNSyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730732AbgGNSyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:54:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65A2922BED;
        Tue, 14 Jul 2020 18:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752851;
        bh=WZm9NVwm/5hzx3Z8PKdERAEM9pbyT8kA/yFB5RQ6bAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcbN8Q4rOYFXKUoSu1OMStUqeEK279AlGJxTUlFO/vci0+css9jOkp4b9kTYokDxm
         MGSemkPPI2Hx1z0+N4XjltcZQkbQUg6ThA5Z98N9+Nq3MK1Yb6Zdc5V2eXEBxsl0vg
         zUapohUiYHdmE1SkXlmj/ma4YbfGMwxmbssfVtlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 010/166] gpu: host1x: Clean up debugfs in error handling path
Date:   Tue, 14 Jul 2020 20:42:55 +0200
Message-Id: <20200714184116.376338634@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 109be8b23fb2ec8e2d309325ee3b7a49eab63961 ]

host1x_debug_init() must be reverted in an error handling path.

This is already fixed in the remove function since commit 44156eee91ba
("gpu: host1x: Clean up debugfs on removal")

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index d24344e919227..3c0f151847bae 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -468,11 +468,12 @@ static int host1x_probe(struct platform_device *pdev)
 
 	err = host1x_register(host);
 	if (err < 0)
-		goto deinit_intr;
+		goto deinit_debugfs;
 
 	return 0;
 
-deinit_intr:
+deinit_debugfs:
+	host1x_debug_deinit(host);
 	host1x_intr_deinit(host);
 deinit_syncpt:
 	host1x_syncpt_deinit(host);
-- 
2.25.1



