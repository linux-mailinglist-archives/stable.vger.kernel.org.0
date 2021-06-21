Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761643AF09D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhFUQu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhFUQtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3507161463;
        Mon, 21 Jun 2021 16:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293254;
        bh=nO/5Ne9fSc9iVoUhsDEATIjEcjgDkPyKt7rroixZULs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpuO3ynQN+ARvoWV7McFWVl3zxcSE++ELUUxa9GhPNCfKXgE9Wzb8xVcEoDdKb1ix
         4RXlgWyGrsaiSkhyMuJPFuz9R8C5/NVsHY4KD7nnUes8ZheWi+EGbYjpoPG1ODs05E
         EOSyXIP0YQSMGIJ7ZaKLjROM4YSI/9Q1+1Qwy0c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.12 155/178] cfg80211: shut down interfaces on failed resume
Date:   Mon, 21 Jun 2021 18:16:09 +0200
Message-Id: <20210621154928.032405403@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 65bec836da8394b1d56bdec2c478dcac21cf12a4 upstream.

If resume fails, we should shut down all interfaces as the
hardware is probably dead. This was/is already done now in
mac80211, but we need to change that due to locking issues,
so move it here and do it without the wiphy lock held.

Cc: stable@vger.kernel.org
Fixes: 2fe8ef106238 ("cfg80211: change netdev registration/unregistration semantics")
Link: https://lore.kernel.org/r/20210608113226.d564ca69de7c.I2e3c3e5d410b72a4f63bade4fb075df041b3d92f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -133,6 +133,10 @@ static int wiphy_resume(struct device *d
 	if (rdev->wiphy.registered && rdev->ops->resume)
 		ret = rdev_resume(rdev);
 	wiphy_unlock(&rdev->wiphy);
+
+	if (ret)
+		cfg80211_shutdown_all_interfaces(&rdev->wiphy);
+
 	rtnl_unlock();
 
 	return ret;


