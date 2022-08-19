Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E61659A1E1
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352580AbiHSQ0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352717AbiHSQZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:25:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C669FDD;
        Fri, 19 Aug 2022 09:03:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D782EB82802;
        Fri, 19 Aug 2022 16:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280F6C433D6;
        Fri, 19 Aug 2022 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924995;
        bh=Vi5nOn57Hq/yjy93n2CxGZ9yBwsNUVNFG9Sh/CociKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqaHVLIKX/Zch4xP356lPUFfsM8OKREO4nwHFsHQGLPIhqhwll8LujUgIteTzFzP3
         upH4rV6NDwCXwx3RrDMJ/fKmHvwvujWO/6taXrBD/+dGOMa90wgormX0qz8uj8Cgao
         QIarSUi93EXRWb4E+hvQZ9TUl1BXh7sBXjZMRGFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/545] intel_th: msu-sink: Potential dereference of null pointer
Date:   Fri, 19 Aug 2022 17:41:20 +0200
Message-Id: <20220819153843.230782415@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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



