Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880DA6AF595
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCGT1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbjCGT1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:27:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4952B9AA0F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DA13B8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9786C433EF;
        Tue,  7 Mar 2023 19:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216382;
        bh=McDwMUlzDgGesmHYgCnHPHouaZL1/O/pKuhANHxhEIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziclLU4mIi4gU9Javl/LpYERQ7iZWqAdGwJR+i3Fg2VuXzS2MTiePdoPU1Kvio0wz
         u9uONpiyS9vSihCId4ul0nz8VerRgmWb0uekpze+nYWANv1o782nXX4Ba2nzxKgGCu
         XD2VquqrOFL2t8F1mBxLfbAI85pY8yfCDoT/twdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mavroudis Chatzilaridis <mavchatz@protonmail.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 564/567] drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv
Date:   Tue,  7 Mar 2023 18:05:00 +0100
Message-Id: <20230307165930.391590833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mavroudis Chatzilaridis <mavchatz@protonmail.com>

commit 5e438bf7f9a1705ebcae5fa89cdbfbc6932a7871 upstream.

This laptop uses inverted backlight PWM. Thus, without this quirk,
backlight brightness decreases as the brightness value increases and
vice versa.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8013
Cc: stable@vger.kernel.org
Signed-off-by: Mavroudis Chatzilaridis <mavchatz@protonmail.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230201184947.8835-1-mavchatz@protonmail.com
(cherry picked from commit 83e7d6fd330d413cb2064e680ffea91b0512a520)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -193,6 +193,8 @@ static struct intel_quirk intel_quirks[]
 	/* ECS Liva Q2 */
 	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	/* HP Notebook - 14-r206nv */
+	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)


