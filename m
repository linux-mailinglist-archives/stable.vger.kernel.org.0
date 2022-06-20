Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD47551BCF
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347207AbiFTNkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346868AbiFTNhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:37:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8F71EED5;
        Mon, 20 Jun 2022 06:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02F7461530;
        Mon, 20 Jun 2022 13:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D95C3411B;
        Mon, 20 Jun 2022 13:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730153;
        bh=VmzrdTalkZ1e7h5WNGtmce8uYkWuo+f4GTUMFFiHh6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08ooVufFFXTEw193yi1qnyZ5f0W8uCL64PwPn9IoUmBi7wRC/uip9cOjkBBiHzBjW
         r698ZE/hJL360Sp+u7g/QLd0CUXjJ6nePLshdMO8OcvmTeeOBVvJwL/vFCzkAIKsg9
         VEt3wwW4k13w/K9Q6EJmHF0qVJ267DXvi6KvyqBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/84] i40e: Fix adding ADQ filter to TC0
Date:   Mon, 20 Jun 2022 14:51:01 +0200
Message-Id: <20220620124722.019022285@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

[ Upstream commit c3238d36c3a2be0a29a9d848d6c51e1b14be6692 ]

Procedure of configure tc flower filters erroneously allows to create
filters on TC0 where unfiltered packets are also directed by default.
Issue was caused by insufficient checks of hw_tc parameter specifying
the hardware traffic class to pass matching packets to.

Fix checking hw_tc parameter which blocks creation of filters on TC0.

Fixes: 2f4b411a3d67 ("i40e: Enable cloud filters via tc-flower")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4a18a7c7dd4c..614f3e995100 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8163,6 +8163,11 @@ static int i40e_configure_clsflower(struct i40e_vsi *vsi,
 		return -EOPNOTSUPP;
 	}
 
+	if (!tc) {
+		dev_err(&pf->pdev->dev, "Unable to add filter because of invalid destination");
+		return -EINVAL;
+	}
+
 	if (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state) ||
 	    test_bit(__I40E_RESET_INTR_RECEIVED, pf->state))
 		return -EBUSY;
-- 
2.35.1



