Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426D54CFAEF
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiCGKXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242007AbiCGKVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:21:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD58290FF8;
        Mon,  7 Mar 2022 01:58:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C568B80E70;
        Mon,  7 Mar 2022 09:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B452FC340E9;
        Mon,  7 Mar 2022 09:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647107;
        bh=HCZQOoGRn4DtMQg9lFdPkGCgGX0eb4zGvQTDiXAj+MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uewEWSPheBLLyqGLrHRxSpeM8ad+ZbPBpVY7qE5dVITqt2pfVTy2NOQY4jRqX5NxB
         4iBTeGAjXeq2sMmrwZbybH/FykukghAAK7RyOM4dBYHFE2Q29cIiHpa5jIg9PnN0py
         gKy8/x5DvTHcBtMJ7s3PMf2LIgd4p8uhSRyu3qos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 149/186] iavf: Add trace while removing device
Date:   Mon,  7 Mar 2022 10:19:47 +0100
Message-Id: <20220307091658.242060505@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit bdb9e5c7aec73a7b8b5acab37587b6de1203e68d ]

Add kernel trace that device was removed.
Currently there is no such information.
I.e. Host admin removes a PCI device from a VM,
than on VM shall be info about the event.

This patch adds info log to iavf_remove function.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 5ff6d0de654e..fff9e9c7f76e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4005,6 +4005,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
 		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 
+	dev_info(&adapter->pdev->dev, "Removing device\n");
 	/* Shut down all the garbage mashers on the detention level */
 	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
-- 
2.34.1



