Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E3A566AB2
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiGEMBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbiGEMAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:00:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BB218374;
        Tue,  5 Jul 2022 05:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA7B7B817CC;
        Tue,  5 Jul 2022 12:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3268DC341CB;
        Tue,  5 Jul 2022 12:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022444;
        bh=IcjmW3CAugrd2BO89KzfYurHCbYolgfhJ8RSBNK+o58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsawS7kUQZf3rLb7a2dNX9XbU3AIZaIdNCMxuMtkfyjOe8YN+Ii3vfHEIe7oi7wMl
         Ynw7iSZI59IQenZZNwxjYqFCWd933gzX56GayDqorDTU9vpl07vDu/FX6yoDmaV3vc
         Lo0uhGary2RIlW6t5BOcWBBmCUDSkgLBqa0VaW04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Ye <chris.ye@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4.14 01/29] nvdimm: Fix badblocks clear off-by-one error
Date:   Tue,  5 Jul 2022 13:57:49 +0200
Message-Id: <20220705115606.379999939@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
References: <20220705115606.333669144@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Ye <chris.ye@intel.com>

commit ef9102004a87cb3f8b26e000a095a261fc0467d3 upstream.

nvdimm_clear_badblocks_region() validates badblock clearing requests
against the span of the region, however it compares the inclusive
badblock request range to the exclusive region range. Fix up the
off-by-one error.

Fixes: 23f498448362 ("libnvdimm: rework region badblocks clearing")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Ye <chris.ye@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/165404219489.2445897.9792886413715690399.stgit@dwillia2-xfh
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -192,8 +192,8 @@ static int nvdimm_clear_badblocks_region
 	ndr_end = nd_region->ndr_start + nd_region->ndr_size - 1;
 
 	/* make sure we are in the region */
-	if (ctx->phys < nd_region->ndr_start
-			|| (ctx->phys + ctx->cleared) > ndr_end)
+	if (ctx->phys < nd_region->ndr_start ||
+	    (ctx->phys + ctx->cleared - 1) > ndr_end)
 		return 0;
 
 	sector = (ctx->phys - nd_region->ndr_start) / 512;


