Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9582A65D83F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjADQNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbjADQMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:12:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D897541D45
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 891C4B8172E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9D1C433F0;
        Wed,  4 Jan 2023 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848717;
        bh=9XuYlRIEDjmQwcnNQIA5o7zDXieqzksQaqZ9e7qGtHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+pS0tYK+auUB9BsuPeUshGCB1jtYFoL2lxpiF11w2kGlnaGF8YQtE1JxdMhvrVyG
         xoaQEJ6lN2TEDeteyZLT8/MORfh6jIo3uYduB6HF3P5UAXyAQBC/+w4PptcqV46QVH
         dfTWgup6yQ7aUAHxmUsUvFmhpi08vP/fDzVz68dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fan Ni <fan.ni@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.0 003/177] cxl/region: Fix memdev reuse check
Date:   Wed,  4 Jan 2023 17:04:54 +0100
Message-Id: <20230104160507.758214184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fan Ni <fan.ni@samsung.com>

commit f04facfb993de47e2133b2b842d72b97b1c50162 upstream.

Due to a typo, the check of whether or not a memdev has already been
used as a target for the region (above code piece) will always be
skipped. Given a memdev with more than one HDM decoder, an interleaved
region can be created that maps multiple HPAs to the same DPA. According
to CXL spec 3.0 8.1.3.8.4, "Aliasing (mapping more than one Host
Physical Address (HPA) to a single Device Physical Address) is
forbidden."

Fix this by using existing iterator for memdev reuse check.

Cc: <stable@vger.kernel.org>
Fixes: 384e624bb211 ("cxl/region: Attach endpoint decoders")
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Link: https://lore.kernel.org/r/20221107212153.745993-1-fan.ni@samsung.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1225,7 +1225,7 @@ static int cxl_region_attach(struct cxl_
 		struct cxl_endpoint_decoder *cxled_target;
 		struct cxl_memdev *cxlmd_target;
 
-		cxled_target = p->targets[pos];
+		cxled_target = p->targets[i];
 		if (!cxled_target)
 			continue;
 


