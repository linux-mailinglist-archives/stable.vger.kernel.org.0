Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6E5938E8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343798AbiHOTOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343790AbiHOTNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9E651429;
        Mon, 15 Aug 2022 11:37:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C54F6113D;
        Mon, 15 Aug 2022 18:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4224DC433D7;
        Mon, 15 Aug 2022 18:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588650;
        bh=Vi5nOn57Hq/yjy93n2CxGZ9yBwsNUVNFG9Sh/CociKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuNWWr5BoPdv9NymjfIOHdAs+hnZ4rZwQoF8Lh1bfBKOxw98gJYqKVA/zjAJTO0ul
         tD0XQd/2SAFhC0NnmipAjL0joFrzfqclxU/oyJWAaJYs30gxe84rRI1TN2zVjbOYbu
         6MqG/wCC6AShyXlPSyK8TQzNH+6otCOzAuHdJ6I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 472/779] intel_th: msu-sink: Potential dereference of null pointer
Date:   Mon, 15 Aug 2022 20:01:56 +0200
Message-Id: <20220815180357.464305629@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 82f76a4a720791d889de775b5f7541d601efc8bd ]

The return value of dma_alloc_coherent() needs to be checked.
To avoid use of null pointer in sg_set_buf() in case of the failure of
alloc.

Fixes: f220df66f676 ("intel_th: msu-sink: An example msu buffer "sink"")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20220705082637.59979-3-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/msu-sink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwtracing/intel_th/msu-sink.c b/drivers/hwtracing/intel_th/msu-sink.c
index 2c7f5116be12..891b28ea25fe 100644
--- a/drivers/hwtracing/intel_th/msu-sink.c
+++ b/drivers/hwtracing/intel_th/msu-sink.c
@@ -71,6 +71,9 @@ static int msu_sink_alloc_window(void *data, struct sg_table **sgt, size_t size)
 		block = dma_alloc_coherent(priv->dev->parent->parent,
 					   PAGE_SIZE, &sg_dma_address(sg_ptr),
 					   GFP_KERNEL);
+		if (!block)
+			return -ENOMEM;
+
 		sg_set_buf(sg_ptr, block, PAGE_SIZE);
 	}
 
-- 
2.35.1



