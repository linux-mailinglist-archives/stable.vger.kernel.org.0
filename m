Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF074F3827
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376382AbiDELVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349425AbiDEJtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD822BFD;
        Tue,  5 Apr 2022 02:45:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 068D8B818F3;
        Tue,  5 Apr 2022 09:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8FCC385A1;
        Tue,  5 Apr 2022 09:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151931;
        bh=MMP6k/LNUR1jVifTaiPGoAePLM2M7XdwQlkDS3TOkuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ahvqw/D85LTq4YZpIhKbGjbec1BZfBKVRTXX/zOnXq72fH9BPihDCn7qdJOPaqQlF
         ofBROGXliKuFT0KaKnEC1CAOD1H3eVX8SYQhKcza7GU1WlY4bsGlJCBPEhu8TTVNP2
         VeQllPDy5Cbpr3x2DrsmuSGWQHIsEGR3XHPDSQ+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 594/913] staging:iio:adc:ad7280a: Fix handing of device address bit reversing.
Date:   Tue,  5 Apr 2022 09:27:36 +0200
Message-Id: <20220405070357.647708324@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit f281e4ddbbc0b60f061bc18a2834e9363ba85f9f ]

The bit reversal was wrong for bits 1 and 3 of the 5 bits.
Result is driver failure to probe if you have more than 2 daisy-chained
devices.  Discovered via QEMU based device emulation.

Fixes tag is for when this moved from a macro to a function, but it
was broken before that.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Fixes: 065a7c0b1fec ("Staging: iio: adc: ad7280a.c: Fixed Macro argument reuse")
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Link: https://lore.kernel.org/r/20220206190328.333093-2-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7280a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
index fef0055b8990..20183b2ea127 100644
--- a/drivers/staging/iio/adc/ad7280a.c
+++ b/drivers/staging/iio/adc/ad7280a.c
@@ -107,9 +107,9 @@
 static unsigned int ad7280a_devaddr(unsigned int addr)
 {
 	return ((addr & 0x1) << 4) |
-	       ((addr & 0x2) << 3) |
+	       ((addr & 0x2) << 2) |
 	       (addr & 0x4) |
-	       ((addr & 0x8) >> 3) |
+	       ((addr & 0x8) >> 2) |
 	       ((addr & 0x10) >> 4);
 }
 
-- 
2.34.1



