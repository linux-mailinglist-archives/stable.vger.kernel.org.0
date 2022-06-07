Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA5D5410D6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355474AbiFGT3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356904AbiFGT2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AFF1A29FE;
        Tue,  7 Jun 2022 11:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05EA861927;
        Tue,  7 Jun 2022 18:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FCEC34115;
        Tue,  7 Jun 2022 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625499;
        bh=4JWxKeMCzS1I9F8T8lOqSs2eeTmYuFxzWuEf3D1lwX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viJLPULvug5khyyEPvb0q63Q35yTa3aIcH04CYyYJA6om/r7Yb/YzVlMQifdmonQL
         8cgR41YZxOScvtyS129QKo8huGEcMGxb35iDqRVGtX3vzGvUK3m6v0k1oS668xhcVv
         S9bGMCEPOEUCbTYklTyKJ/nwyznMAxe2ssqv1b1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20Niew=C3=B6hner?= <linux@mniewoehner.de>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.17 033/772] platform/x86: intel-hid: fix _DSM function index handling
Date:   Tue,  7 Jun 2022 18:53:45 +0200
Message-Id: <20220607164949.999122441@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Michael Niewöhner <linux@mniewoehner.de>

commit 1620c80bba53af8c547bab34a1d3bc58319fe608 upstream.

intel_hid_dsm_fn_mask is a bit mask containing one bit for each function
index. Fix the function index check in intel_hid_evaluate_method
accordingly, which was missed in commit 97ab4516205e ("platform/x86:
intel-hid: fix _DSM function index handling").

Fixes: 97ab4516205e ("platform/x86: intel-hid: fix _DSM function index handling")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Niewöhner <linux@mniewoehner.de>
Link: https://lore.kernel.org/r/66f813f5bcc724a0f6dd5adefe6a9728dbe509e3.camel@mniewoehner.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/hid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -238,7 +238,7 @@ static bool intel_hid_evaluate_method(ac
 
 	method_name = (char *)intel_hid_dsm_fn_to_method[fn_index];
 
-	if (!(intel_hid_dsm_fn_mask & fn_index))
+	if (!(intel_hid_dsm_fn_mask & BIT(fn_index)))
 		goto skip_dsm_eval;
 
 	obj = acpi_evaluate_dsm_typed(handle, &intel_dsm_guid,


