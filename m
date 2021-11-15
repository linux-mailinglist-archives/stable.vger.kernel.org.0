Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFC645117F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbhKOTJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243916AbhKOTGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:06:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A04633EE;
        Mon, 15 Nov 2021 18:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000226;
        bh=AlDYZYESXTj9g84izod3EgH2s/APmTwHtMQWSyBmrBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpekkhPYjNiW61nGbsVgsnwr7Jli3srQWfYuANKKf9VUgNnjbACfGGeL8b/wJh+fu
         sJg6t1+wJ5Twu+GVAMhzeTjS9cAwekwA200Fv3Vw59NJysY/2Ma7UsVmg9d5aazwPD
         4TICax4TK416STBvvFKrbeWDgNzZ8s+OhD0eZak0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 584/849] soundwire: debugfs: use controller id and link_id for debugfs
Date:   Mon, 15 Nov 2021 18:01:07 +0100
Message-Id: <20211115165440.008308478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 75eac387a2539aa6c6bbee3affa23435f2096396 ]

link_id can be zero and if we have multiple controller instances
in a system like Qualcomm debugfs will end-up with duplicate namespace
resulting in incorrect debugfs entries.

Using bus-id and link-id combination should give a unique debugfs directory
entry and should fix below warning too.
"debugfs: Directory 'master-0' with parent 'soundwire' already present!"

Fixes: bf03473d5bcc ("soundwire: add debugfs support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210907105332.1257-1-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/debugfs.c b/drivers/soundwire/debugfs.c
index b6cad0d59b7b9..49900cd207bc7 100644
--- a/drivers/soundwire/debugfs.c
+++ b/drivers/soundwire/debugfs.c
@@ -19,7 +19,7 @@ void sdw_bus_debugfs_init(struct sdw_bus *bus)
 		return;
 
 	/* create the debugfs master-N */
-	snprintf(name, sizeof(name), "master-%d", bus->link_id);
+	snprintf(name, sizeof(name), "master-%d-%d", bus->id, bus->link_id);
 	bus->debugfs = debugfs_create_dir(name, sdw_debugfs_root);
 }
 
-- 
2.33.0



