Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25465499215
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380985AbiAXURX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52018 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379794AbiAXUMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:12:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A935B81218;
        Mon, 24 Jan 2022 20:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFB0C340E7;
        Mon, 24 Jan 2022 20:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055157;
        bh=ZysuhQ7Pz6OFnxju1Jqcw21yLpfW3eWSCctuI/N59A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQAe9faIuVNjxB0fa2Qff8Gr0T83Uu/strL9xrk2k9SJtfQg8GLwSpi8hieayFSrb
         qfC7ztdgcqs4jU7mGK8ACKQv6QrOe6gfbGFpmKDsl/0L77I0YCa3lG1T+N3uyx3OF7
         m67ZkheK6Bdj/qTRcomViWgMcNHwCnaZ3DzXcdH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Bhaumik Bhatt <quic_bbhatt@quicinc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.15 059/846] bus: mhi: core: Fix reading wake_capable channel configuration
Date:   Mon, 24 Jan 2022 19:32:56 +0100
Message-Id: <20220124184102.997191555@linuxfoundation.org>
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


