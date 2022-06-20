Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5AB551A35
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243444AbiFTM5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243468AbiFTM4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:56:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678781A068;
        Mon, 20 Jun 2022 05:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC99614EB;
        Mon, 20 Jun 2022 12:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04296C341C4;
        Mon, 20 Jun 2022 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729702;
        bh=9jDDsgQyQTjlFBuKLov8y6UFAbc1Ox58tCBgC74fWGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfzlQwcCe+JvNSSgZRNR/jCI1i3Gd2eBAxmZiH0wxGQAHR9G2T2Udjj8VrTp9YcTI
         YjJRS1m8NiLxm0ToPcdu5eXTCslvu04D3qu+iy5sVhvLap7ia+4/DTC73Kz7MldE60
         w4bnSevc7mx3QnVhNCAD+r0rUFZ6Wxd18ZNKkf4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        David Arcari <darcari@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 047/141] platform/x86/intel: Fix pmt_crashlog array reference
Date:   Mon, 20 Jun 2022 14:49:45 +0200
Message-Id: <20220620124730.925164063@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



