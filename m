Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A2A194D36
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgCZXYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbgCZXYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E79220774;
        Thu, 26 Mar 2020 23:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265043;
        bh=sKbjwMLJiBOphC69hyUcwuxnGfiE7NbpZaWocYhiKBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZ/H7YMzKQonndCgykCf0nkpaYYAiRtwcTjWHIhsnMtOS1s5JqVP7UPSaytWNr0yc
         +aA7AR7u/Sbc+VFlXJGyrauaCv85MMm5ng3FYSeZxo5gWzDB6dZ2ul0xwm1XRpmnqT
         Cip/uSiprVQH0ob9Y31qSjD1OTkGfoPIhC+FWUVs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.5 05/28] staging: wfx: fix warning about freeing in-use mutex during device unregister
Date:   Thu, 26 Mar 2020 19:23:34 -0400
Message-Id: <20200326232357.7516-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232357.7516-1-sashal@kernel.org>
References: <20200326232357.7516-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit bab0a0b03442a62fe3abefcb2169e0b9ff95990c ]

After hif_shutdown(), communication with the chip is no more possible.
It the only request that never reply. Therefore, hif_cmd.lock is never
unlocked. hif_shutdown() unlock itself hif_cmd.lock to avoid a potential
warning during disposal of device. hif_cmd.key_renew_lock should also
been unlocked for the same reason.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200310101356.182818-2-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/hif_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wfx/hif_tx.c b/drivers/staging/wfx/hif_tx.c
index cb7cddcb98159..16e7d190430f3 100644
--- a/drivers/staging/wfx/hif_tx.c
+++ b/drivers/staging/wfx/hif_tx.c
@@ -141,6 +141,7 @@ int hif_shutdown(struct wfx_dev *wdev)
 	else
 		control_reg_write(wdev, 0);
 	mutex_unlock(&wdev->hif_cmd.lock);
+	mutex_unlock(&wdev->hif_cmd.key_renew_lock);
 	kfree(hif);
 	return ret;
 }
-- 
2.20.1

