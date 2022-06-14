Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7040E54A48D
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352081AbiFNCH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351529AbiFNCHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:07:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA70834BA5;
        Mon, 13 Jun 2022 19:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E441B816A6;
        Tue, 14 Jun 2022 02:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F218CC385A2;
        Tue, 14 Jun 2022 02:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172355;
        bh=9jDDsgQyQTjlFBuKLov8y6UFAbc1Ox58tCBgC74fWGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZ2DTThrEKVugU8QwDUxEUqS89HIRN2ZhYR6d8X/WR1X4o/MW7byM1muiHJsOHcLH
         5mDhVF4Q+su6zniBYz//nqhFhE/qDdQ6Tq7kLqs9KtyGF9Lap5qCIQ3VWsVXO2K/8l
         WNSCNakfW48HAe3YIYewFd49onzIgGE2LYM0Rgo53O0MpR7i73Twm9NddJDq1YABYH
         M1F+JSUYL0YXBhdrksKje7j3mRbyAy19j3XbpBv2HJXatenTTbB3OqLn7x9KcA31ft
         WXxlcet9v9y028iZFqkWZZLlBN7JraTX+6VXPFIlvQmjF98ye+JP4ikWzYfuPvHXPK
         9glFRw66eN5oA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Arcari <darcari@redhat.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 43/47] platform/x86/intel: Fix pmt_crashlog array reference
Date:   Mon, 13 Jun 2022 22:04:36 -0400
Message-Id: <20220614020441.1098348-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Arcari <darcari@redhat.com>

[ Upstream commit 66cb3a2d7ad0d0e9af4d3430a4f2a32ffb9ac098 ]

The probe function pmt_crashlog_probe() may incorrectly reference
the 'priv->entry array' as it uses 'i' to reference the array instead
of 'priv->num_entries' as it should.  This is similar to the problem
that was addressed in pmt_telemetry_probe via commit 2cdfa0c20d58
("platform/x86/intel: Fix 'rmmod pmt_telemetry' panic").

Cc: "David E. Box" <david.e.box@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Gross <markgross@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: David Arcari <darcari@redhat.com>
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20220526203140.339120-1-darcari@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/crashlog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/crashlog.c b/drivers/platform/x86/intel/pmt/crashlog.c
index 34daf9df168b..ace1239bc0a0 100644
--- a/drivers/platform/x86/intel/pmt/crashlog.c
+++ b/drivers/platform/x86/intel/pmt/crashlog.c
@@ -282,7 +282,7 @@ static int pmt_crashlog_probe(struct auxiliary_device *auxdev,
 	auxiliary_set_drvdata(auxdev, priv);
 
 	for (i = 0; i < intel_vsec_dev->num_resources; i++) {
-		struct intel_pmt_entry *entry = &priv->entry[i].entry;
+		struct intel_pmt_entry *entry = &priv->entry[priv->num_entries].entry;
 
 		ret = intel_pmt_dev_create(entry, &pmt_crashlog_ns, intel_vsec_dev, i);
 		if (ret < 0)
-- 
2.35.1

