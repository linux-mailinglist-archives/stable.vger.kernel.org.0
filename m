Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281F0499656
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359554AbiAXVDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:03:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48982 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442839AbiAXUzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:55:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CA816091C;
        Mon, 24 Jan 2022 20:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0C6C340E5;
        Mon, 24 Jan 2022 20:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057730;
        bh=ZysuhQ7Pz6OFnxju1Jqcw21yLpfW3eWSCctuI/N59A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rj4OPZATGG8MX/u9rdnGo5zB0EAFxQI3eTA7CqTMl2SOJOASaladN5IpdFjAZbmSc
         dSVVB2RmFQLA4NRUkeOMKi2RO2Nsz9tkic/XIj0R+8IYdVRSf9DzS0sgSYr1GKQzK0
         vDv4HReNo+NBSAv78IWlFVacqaxHEBRZW3aCWYjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Bhaumik Bhatt <quic_bbhatt@quicinc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.16 0061/1039] bus: mhi: core: Fix reading wake_capable channel configuration
Date:   Mon, 24 Jan 2022 19:30:50 +0100
Message-Id: <20220124184127.196002038@linuxfoundation.org>
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

From: Bhaumik Bhatt <quic_bbhatt@quicinc.com>

commit 42c4668f7efe1485dfc382517b412c0c6ab102b8 upstream.

The 'wake-capable' entry in channel configuration is not set when
parsing the configuration specified by the controller driver. Add
the missing entry to ensure channel is correctly specified as a
'wake-capable' channel.

Link: https://lore.kernel.org/r/1638320491-13382-1-git-send-email-quic_bbhatt@quicinc.com
Fixes: 0cbf260820fa ("bus: mhi: core: Add support for registering MHI controllers")
Cc: stable@vger.kernel.org
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bhaumik Bhatt <quic_bbhatt@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20211216081227.237749-7-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -788,6 +788,7 @@ static int parse_ch_cfg(struct mhi_contr
 		mhi_chan->offload_ch = ch_cfg->offload_channel;
 		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
 		mhi_chan->pre_alloc = ch_cfg->auto_queue;
+		mhi_chan->wake_capable = ch_cfg->wake_capable;
 
 		/*
 		 * If MHI host allocates buffers, then the channel direction


