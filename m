Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0655013D0
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239609AbiDNNvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245659AbiDNNis (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:38:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961A7A6E19;
        Thu, 14 Apr 2022 06:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F556122A;
        Thu, 14 Apr 2022 13:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8BCC385A5;
        Thu, 14 Apr 2022 13:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943211;
        bh=XJyUTw9A5Nk2Y/lQinGxyQhyXTuvEwtV7vyfu8dWwwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgacuEK5cGCvIPg+jCW1rzWMciGgyXHRIznaw/+pwoSxfALGSkgPwBc5RN+tF6Vq1
         f3MiAJF1I2f9Kc0C+9ODtNbvbmh7Gn2GuBLD83LHDMO+yWMnOt1MHX42UYHIP7YHtq
         BUmB22U4b+41pdlV3ALf5F3j+QWn80755lRNNyvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 074/475] thermal: int340x: Increase bitmap size
Date:   Thu, 14 Apr 2022 15:07:39 +0200
Message-Id: <20220414110857.225482609@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 668f69a5f863b877bc3ae129efe9a80b6f055141 upstream.

The number of policies are 10, so can't be supported by the bitmap size
of u8.

Even though there are no platfoms with these many policies, but
for correctness increase to u32.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 16fc8eca1975 ("thermal/int340x_thermal: Add additional UUIDs")
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -49,7 +49,7 @@ struct int3400_thermal_priv {
 	struct art *arts;
 	int trt_count;
 	struct trt *trts;
-	u8 uuid_bitmap;
+	u32 uuid_bitmap;
 	int rel_misc_dev_res;
 	int current_uuid_index;
 };


