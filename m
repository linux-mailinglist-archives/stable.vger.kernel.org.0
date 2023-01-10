Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A1A664AAC
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbjAJSeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239472AbjAJSdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:33:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A503585C89
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:29:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63CD0B81904
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0949C433D2;
        Tue, 10 Jan 2023 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375377;
        bh=BtWuyQgJY+UbUc6UgCrqT0l99SP0imJdfuo9ZmZ66M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2Dqm2iDGo0R3QOxTvc0YJ9wIiCTs1BV4Q9OYwAg8oMfgyBxGRSPGNpRuP9L7KUFA
         JBBNSgTaFsdyuHxWt0tENcPT9d45DjG6iALKhUD2bdxPsMwURvoKVAajvKSt0QgPGF
         p12yJDHpNX9GCWPCMtYIJ2XuEVZSYVvSjk1g8Lg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 137/290] drm/i915/dsi: fix VBT send packet port selection for dual link DSI
Date:   Tue, 10 Jan 2023 19:03:49 +0100
Message-Id: <20230110180036.579191428@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Mikko Kovanen <mikko.kovanen@aavamobile.com>

commit f9cdf4130671d767071607d0a7568c9bd36a68d0 upstream.

intel_dsi->ports contains bitmask of enabled ports and correspondingly
logic for selecting port for VBT packet sending must use port specific
bitmask when deciding appropriate port.

Fixes: 08c59dde71b7 ("drm/i915/dsi: fix VBT send packet port selection for ICL+")
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Kovanen <mikko.kovanen@aavamobile.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/DBBPR09MB466592B16885D99ABBF2393A91119@DBBPR09MB4665.eurprd09.prod.outlook.com
(cherry picked from commit 8d58bb7991c45f6b60710cc04c9498c6ea96db90)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -133,9 +133,9 @@ static enum port intel_dsi_seq_port_to_p
 		return ffs(intel_dsi->ports) - 1;
 
 	if (seq_port) {
-		if (intel_dsi->ports & PORT_B)
+		if (intel_dsi->ports & BIT(PORT_B))
 			return PORT_B;
-		else if (intel_dsi->ports & PORT_C)
+		else if (intel_dsi->ports & BIT(PORT_C))
 			return PORT_C;
 	}
 


