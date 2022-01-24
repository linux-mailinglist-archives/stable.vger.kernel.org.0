Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068E7499A87
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573356AbiAXVou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54792 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455746AbiAXVgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:36:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFC3F61469;
        Mon, 24 Jan 2022 21:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E717C340E4;
        Mon, 24 Jan 2022 21:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060161;
        bh=tCklUFkTz/9x3T08B8bbRuJKvWtGxMtJjmqMXxKUWro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2Q4hGZ5Dd70ks7O5cYrnaejs5x+tzqbPPs2iGKQUoSodizmQcOafpJJlykg4K3wk
         SkyOL1WeUzL2WsLF75MXem8h8CWrfiuS9dx79vATPQMyxH5mYyo+iPR8kHq1mpJ8Pa
         TPMlVM3rwpln7cHPo/dgQ02utm8x9IIF8e2CX3YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.16 0859/1039] drm/tegra: submit: Add missing pm_runtime_mark_last_busy()
Date:   Mon, 24 Jan 2022 19:44:08 +0100
Message-Id: <20220124184154.165277301@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit a21115dd38c6cf396ba39aefd561e7903ca6149d upstream.

Runtime PM auto-suspension doesn't work without pm_runtime_mark_last_busy(),
add it.

Cc: <stable@vger.kernel.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/submit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -475,8 +475,10 @@ static void release_job(struct host1x_jo
 	kfree(job_data->used_mappings);
 	kfree(job_data);
 
-	if (pm_runtime_enabled(client->base.dev))
+	if (pm_runtime_enabled(client->base.dev)) {
+		pm_runtime_mark_last_busy(client->base.dev);
 		pm_runtime_put_autosuspend(client->base.dev);
+	}
 }
 
 int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,


