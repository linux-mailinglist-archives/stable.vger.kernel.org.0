Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C03409430
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344902AbhIMO2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344267AbhIMO0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 552F061B5E;
        Mon, 13 Sep 2021 13:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540965;
        bh=hlZCErq6/PJuwsCPLLzVeydPlwvbHm2q8eaWhHa1HEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDcGFtRH/bh5whbPyayTz0XZ1NaOIg+ToyqfwZSmilTn0LlXebp3SQU/qSpxth4yf
         /A/tw+1A9jaFxiz3zQnvMPAU8I5OHgac4bC8SlJwMoC1zT9rxGUHvUxrmLLNoC3H5m
         47Fuydd2pZwQLVqAsVtrDSjFQ5hHLdUtdqPlDm9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 108/334] firmware: fix theoretical UAF race with firmware cache and resume
Date:   Mon, 13 Sep 2021 15:12:42 +0200
Message-Id: <20210913131117.028416558@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 3ecc8cb7c092b2f50e21d2aaaae35b8221ee7214 ]

This race was discovered when I carefully analyzed the code to locate
another firmware-related UAF issue. It can be triggered only when the
firmware load operation is executed during suspend. This possibility is
almost impossible because there are few firmware load and suspend actions
in the actual environment.

		CPU0			CPU1
__device_uncache_fw_images():		assign_fw():
					fw_cache_piggyback_on_request()
					<----- P0
	spin_lock(&fwc->name_lock);
	...
	list_del(&fce->list);
	spin_unlock(&fwc->name_lock);

	uncache_firmware(fce->name);
					<----- P1
					kref_get(&fw_priv->ref);

If CPU1 is interrupted at position P0, the new 'fce' has been added to the
list fwc->fw_names by the fw_cache_piggyback_on_request(). In this case,
CPU0 executes __device_uncache_fw_images() and will be able to see it when
it traverses list fwc->fw_names. Before CPU1 executes kref_get() at P1, if
CPU0 further executes uncache_firmware(), the count of fw_priv->ref may
decrease to 0, causing fw_priv to be released in advance.

Move kref_get() to the lock protection range of fwc->name_lock to fix it.

Fixes: ac39b3ea73aa ("firmware loader: let caching firmware piggyback on loading firmware")
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210719064531.3733-2-thunder.leizhen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/main.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 68c549d71230..bdbedc6660a8 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -165,7 +165,7 @@ static inline int fw_state_wait(struct fw_priv *fw_priv)
 	return __fw_state_wait_common(fw_priv, MAX_SCHEDULE_TIMEOUT);
 }
 
-static int fw_cache_piggyback_on_request(const char *name);
+static void fw_cache_piggyback_on_request(struct fw_priv *fw_priv);
 
 static struct fw_priv *__allocate_fw_priv(const char *fw_name,
 					  struct firmware_cache *fwc,
@@ -707,10 +707,8 @@ int assign_fw(struct firmware *fw, struct device *device)
 	 * on request firmware.
 	 */
 	if (!(fw_priv->opt_flags & FW_OPT_NOCACHE) &&
-	    fw_priv->fwc->state == FW_LOADER_START_CACHE) {
-		if (fw_cache_piggyback_on_request(fw_priv->fw_name))
-			kref_get(&fw_priv->ref);
-	}
+	    fw_priv->fwc->state == FW_LOADER_START_CACHE)
+		fw_cache_piggyback_on_request(fw_priv);
 
 	/* pass the pages buffer to driver at the last minute */
 	fw_set_page_data(fw_priv, fw);
@@ -1259,11 +1257,11 @@ static int __fw_entry_found(const char *name)
 	return 0;
 }
 
-static int fw_cache_piggyback_on_request(const char *name)
+static void fw_cache_piggyback_on_request(struct fw_priv *fw_priv)
 {
-	struct firmware_cache *fwc = &fw_cache;
+	const char *name = fw_priv->fw_name;
+	struct firmware_cache *fwc = fw_priv->fwc;
 	struct fw_cache_entry *fce;
-	int ret = 0;
 
 	spin_lock(&fwc->name_lock);
 	if (__fw_entry_found(name))
@@ -1271,13 +1269,12 @@ static int fw_cache_piggyback_on_request(const char *name)
 
 	fce = alloc_fw_cache_entry(name);
 	if (fce) {
-		ret = 1;
 		list_add(&fce->list, &fwc->fw_names);
+		kref_get(&fw_priv->ref);
 		pr_debug("%s: fw: %s\n", __func__, name);
 	}
 found:
 	spin_unlock(&fwc->name_lock);
-	return ret;
 }
 
 static void free_fw_cache_entry(struct fw_cache_entry *fce)
@@ -1508,9 +1505,8 @@ static inline void unregister_fw_pm_ops(void)
 	unregister_pm_notifier(&fw_cache.pm_notify);
 }
 #else
-static int fw_cache_piggyback_on_request(const char *name)
+static void fw_cache_piggyback_on_request(struct fw_priv *fw_priv)
 {
-	return 0;
 }
 static inline int register_fw_pm_ops(void)
 {
-- 
2.30.2



