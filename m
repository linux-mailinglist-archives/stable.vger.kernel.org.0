Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E2F498B4D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346442AbiAXTMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35704 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347237AbiAXTJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:09:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B92B2B81215;
        Mon, 24 Jan 2022 19:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8A2C340E5;
        Mon, 24 Jan 2022 19:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051396;
        bh=f7zDL95n+kg9huLTEOAIIEnuKev+HlSFHBWny+tfZwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r46hArvCvL4qSxHREiHq7qk+IL+0kFpunyOeyfgVt3dRSqxVCjyHlaPbnUZUwRo1/
         PdFxiENcTfjYZ6aBtKY5I16kjFrd4J4fqCB8MBpzlU+LLxe9CEnt8Zi0VSaNbpzOXH
         Y7YssVuZDOUFiR1roQclSto4m88GgfZTZJpS1LsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 115/186] iwlwifi: remove module loading failure message
Date:   Mon, 24 Jan 2022 19:43:10 +0100
Message-Id: <20220124183940.810839510@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6518f83ffa51131daaf439b66094f684da3fb0ae ]

When CONFIG_DEBUG_TEST_DRIVER_REMOVE is set, iwlwifi crashes
when the opmode module cannot be loaded, due to completing
the completion before using drv->dev, which can then already
be freed.

Fix this by removing the (fairly useless) message. Moving the
completion later causes a deadlock instead, so that's not an
option.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20211210091245.289008-2-luca@coelho.fi
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 95101f66a886e..ade3c27050471 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1494,15 +1494,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * else from proceeding if the module fails to load
 	 * or hangs loading.
 	 */
-	if (load_module) {
+	if (load_module)
 		request_module("%s", op->name);
-#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
-		if (err)
-			IWL_ERR(drv,
-				"failed to load module %s (error %d), is dynamic loading enabled?\n",
-				op->name, err);
-#endif
-	}
 	failure = false;
 	goto free;
 
-- 
2.34.1



