Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25BD59E175
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbiHWL1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351614AbiHWLZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:25:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60994B089C;
        Tue, 23 Aug 2022 02:24:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7C07B81B1F;
        Tue, 23 Aug 2022 09:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119E9C433C1;
        Tue, 23 Aug 2022 09:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246643;
        bh=Vi5nOn57Hq/yjy93n2CxGZ9yBwsNUVNFG9Sh/CociKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piRW6RXEEFG8vEkI9oSgaF8yDc9L8OQgwfP5f0skutdaNs9Otde9J8MK5UjT9iDbh
         gmNjAl6/pbGhAdbm/SuD0CthdU04t58BrAjj5hsQvmilozsQKMMejBwOU4MUDjMc50
         rsAt111Ub3Fv5PubD+CdJ7thMxgxbu4SVPVxk47E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/389] intel_th: msu-sink: Potential dereference of null pointer
Date:   Tue, 23 Aug 2022 10:24:13 +0200
Message-Id: <20220823080122.954653463@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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



