Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A06A6ECE7B
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjDXNc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjDXNck (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:32:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CF07681
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49FBF6236E
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59551C433EF;
        Mon, 24 Apr 2023 13:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343106;
        bh=D9Oza+T8TEviv2IjtcOS3/W6BGLVAA5KjeGkf207Pek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQdGeyS7a7BdSWXUdppnPRPGUIcLwK2ZDdlxMdcKVKb+YFAPaCwzerZTyp/vtYDYy
         sfC7Y5eJr4wTO4aPalo3VnmH3Ce6QZrt3JvTmRgeCb3aIsPp1CcNWjprcg6M2ntuCP
         0sJsoKDhLxAEAh6ZMhCO/DIjA4u7AW3Xn21ByrWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 080/110] drm/i915: Fix fast wake AUX sync len
Date:   Mon, 24 Apr 2023 15:17:42 +0200
Message-Id: <20230424131139.447551361@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit e1c71f8f918047ce822dc19b42ab1261ed259fd1 upstream.

Fast wake should use 8 SYNC pulses for the preamble
and 10-16 SYNC pulses for the precharge. Reduce our
fast wake SYNC count to match the maximum value.
We also use the maximum precharge length for normal
AUX transactions.

Cc: stable@vger.kernel.org
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230329172434.18744-1-ville.syrjala@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
(cherry picked from commit 605f7c73133341d4b762cbd9a22174cc22d4c38b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_aux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -166,7 +166,7 @@ static u32 skl_get_aux_send_ctl(struct i
 	      DP_AUX_CH_CTL_TIME_OUT_MAX |
 	      DP_AUX_CH_CTL_RECEIVE_ERROR |
 	      (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
-	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(32) |
+	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(24) |
 	      DP_AUX_CH_CTL_SYNC_PULSE_SKL(32);
 
 	if (intel_tc_port_in_tbt_alt_mode(dig_port))


