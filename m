Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD3159D541
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244531AbiHWIdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiHWIcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E8FF72;
        Tue, 23 Aug 2022 01:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A76A6129A;
        Tue, 23 Aug 2022 08:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133C9C433D6;
        Tue, 23 Aug 2022 08:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242566;
        bh=/eYVGXAuKL4bcGDnI5yMXcniIu7V/yBLApdzeAGaCAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYUH1k+PRQuQrclGFKKk0XJUzIusvtJ5HmND0l/tNxF8P6y21dQsEvr7g9WIU8PtP
         GL4ZcAdgOQUOHSAGWM2LO1JOi+nCKnZ4kVb951G6VGtXEN8iQ/WGbjvvukHgUDcMuo
         d6psQmtofzdoFNPS273Idg+EYP2vuS8De3HjUmGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.19 138/365] tools/testing/cxl: Fix decoder default state
Date:   Tue, 23 Aug 2022 10:00:39 +0200
Message-Id: <20220823080123.987647295@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

commit 08f8d040a11d539481b9aee7b482430561281a28 upstream.

The 'enabled' state is reserved for committed decoders. By default,
cxl_test decoders are uncommitted at init time.

Fixes: 7c7d68db0254 ("tools/testing/cxl: Enumerate mock decoders")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/165603888091.551046.6312322707378021172.stgit@dwillia2-xfh
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/cxl/test/cxl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 91444279f9a2..6e086fbc5c5b 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -466,7 +466,6 @@ static int mock_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 			.end = -1,
 		};
 
-		cxld->flags = CXL_DECODER_F_ENABLE;
 		cxld->interleave_ways = min_not_zero(target_count, 1);
 		cxld->interleave_granularity = SZ_4K;
 		cxld->target_type = CXL_DECODER_EXPANDER;
-- 
2.37.2



