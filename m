Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE50263570D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238039AbiKWJhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238060AbiKWJhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:37:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF9897AA3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18D6761A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A237C433D6;
        Wed, 23 Nov 2022 09:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196093;
        bh=K+ITz+lLt9tzxt9nW+T7r8cYp5zE7bu9BcyMuS6Sv1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jz2rDD+xCZQIJA0C52JnOo2e/ydLthUXuoBgd1iTiOf9DOBNRtW56PxIAIU7bRj1c
         S7ELYRsQQaSNGSjvb5j0r18uyb6AHdbbGY3qoTxafwLne/60vPnL08CgjUrnUd3PBm
         JIVO5uLflFC0liChYd0oQTuW1OWHoVQt+UB6Uwog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 117/181] drm/amd/display: Add HUBP surface flip interrupt handler
Date:   Wed, 23 Nov 2022 09:51:20 +0100
Message-Id: <20221123084607.423770761@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 7af87fc1ba136143314c870059b8f60180247cbd upstream.

On IGT, there is a test named amd_hotplug, and when the subtest basic is
executed on DCN31, we get the following error:

[drm] *ERROR* [CRTC:71:crtc-0] flip_done timed out
[drm] *ERROR* flip_done timed out
[drm] *ERROR* [CRTC:71:crtc-0] commit wait timed out
[drm] *ERROR* flip_done timed out
[drm] *ERROR* [CONNECTOR:88:DP-1] commit wait timed out
[drm] *ERROR* flip_done timed out
[drm] *ERROR* [PLANE:59:plane-3] commit wait timed out

After enable the page flip log with the below command:

 echo -n 'format "[PFLIP]" +p' > /sys/kernel/debug/dynamic_debug/control

It is possible to see that the flip was submitted, but DC never replied
back, which generates time-out issues. This is an indication that the
HUBP surface flip is missing. This commit fixes this issue by adding
hubp1_set_flip_int to DCN31.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
@@ -79,6 +79,7 @@ static struct hubp_funcs dcn31_hubp_func
 	.hubp_init = hubp3_init,
 	.set_unbounded_requesting = hubp31_set_unbounded_requesting,
 	.hubp_soft_reset = hubp31_soft_reset,
+	.hubp_set_flip_int = hubp1_set_flip_int,
 	.hubp_in_blank = hubp1_in_blank,
 };
 


