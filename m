Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FD25AEA13
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiIFNkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbiIFNkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046897D1F8;
        Tue,  6 Sep 2022 06:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA97B61512;
        Tue,  6 Sep 2022 13:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0110AC433D7;
        Tue,  6 Sep 2022 13:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471332;
        bh=m98F5jESOXA9JdUJZQ2Lpwin7wHAIedi2OSmc3PJYls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uL3pWTsDOcoOnEgyXe+K9k/6PynqPhnEa/WsoI2Y6Hts2hep81qoO5k7QFQNkB2mW
         QSzel58c2GBkFr8+nHiBYgh/WckfKj34alRSCsrxxPEOEeZbc0f8gzTyDKy8xP/DMu
         mNTGEnUxUmCHlWfWE00hP7cJJDgzp136AmS0pUZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Diego Santa Cruz <Diego.SantaCruz@spinetix.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.10 73/80] drm/i915/glk: ECS Liva Q2 needs GLK HDMI port timing quirk
Date:   Tue,  6 Sep 2022 15:31:10 +0200
Message-Id: <20220906132820.183793648@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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

From: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>

commit 919bef7a106ade2bda73681bbc2f3678198f44fc upstream.

The quirk added in upstream commit 90c3e2198777 ("drm/i915/glk: Add
Quirk for GLK NUC HDMI port issues.") is also required on the ECS Liva
Q2.

Note: Would be nicer to figure out the extra delay required for the
retimer without quirks, however don't know how to check for that.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1326
Signed-off-by: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220616124137.3184371-1-jani.nikula@intel.com
(cherry picked from commit 08e9505fa8f9aa00072a47b6f234d89b6b27a89c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -156,6 +156,9 @@ static struct intel_quirk intel_quirks[]
 	/* ASRock ITX*/
 	{ 0x3185, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
+	/* ECS Liva Q2 */
+	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)


