Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8515E499DA3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585866AbiAXWZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582535AbiAXWPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:15:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825D4C049660;
        Mon, 24 Jan 2022 12:44:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 483D2B8121C;
        Mon, 24 Jan 2022 20:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB8FC340E5;
        Mon, 24 Jan 2022 20:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057063;
        bh=tCklUFkTz/9x3T08B8bbRuJKvWtGxMtJjmqMXxKUWro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIxtypzwNp9brmHqh2q+2EbnvCvP1PMoW9h+jrqyDLSZriInVAOrdb0bTHr+DSfDG
         92LbaMVTCYt9fl+AceqqkuTwIuqOs58DwC7fjxn4jqZjhFpa6ey+MZUbsA8/KztJFq
         SvPzQ08ZYNsteq6R4INHU9WY954UU9NE8CkDgRh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 690/846] drm/tegra: submit: Add missing pm_runtime_mark_last_busy()
Date:   Mon, 24 Jan 2022 19:43:27 +0100
Message-Id: <20220124184124.857537440@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


