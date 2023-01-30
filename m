Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7826810BF
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbjA3OGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbjA3OGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01043B3FC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CC32B81147
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF662C433EF;
        Mon, 30 Jan 2023 14:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087575;
        bh=U/lwOAL+YJtkYh4tjFQwx2ocQnXIi7voxxR1RleyGC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U07tGjVBLq2kpU37ZnidQ3TbUqUMXh534ihkH++nTsxdFw/cxyqBlkkRvwYpi4o+L
         sh+so/rTBE4mkRb2HAqMakCSciGJXIJkSMBr1jmx67zINNX3cm9zQM///KdeW+xbuR
         V5ZtjDfk2VO6BlpV2jeGZUdtaH2B2+VwUvKXei6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Assmann <sassmann@kpanic.de>,
        Michal Schmidt <mschmidt@redhat.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 253/313] iavf: schedule watchdog immediately when changing primary MAC
Date:   Mon, 30 Jan 2023 14:51:28 +0100
Message-Id: <20230130134348.498442206@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit e2b53ea5a7c1fb484277ad12cd075f502cf03b04 ]

iavf_replace_primary_mac() utilizes queue_work() to schedule the
watchdog task but that only ensures that the watchdog task is queued
to run. To make sure the watchdog is executed asap use
mod_delayed_work().

Without this patch it may take up to 2s until the watchdog task gets
executed, which may cause long delays when setting the MAC address.

Fixes: a3e839d539e0 ("iavf: Add usage of new virtchnl format to set default MAC")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index efc7735ece30..3dad834b9b8e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1033,7 +1033,7 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,
 
 	/* schedule the watchdog task to immediately process the request */
 	if (f) {
-		queue_work(adapter->wq, &adapter->watchdog_task.work);
+		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 		return 0;
 	}
 	return -ENOMEM;
-- 
2.39.0



