Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21459D3FA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbiHWII2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241684AbiHWIIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF466BD4D;
        Tue, 23 Aug 2022 01:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFE5AB81C24;
        Tue, 23 Aug 2022 08:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08466C433D6;
        Tue, 23 Aug 2022 08:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241895;
        bh=dNybW/HES1FgarV14AJnVL0x6T90D28LuAva8GLgRRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbFkyEPtt6EJWcfi5P0Ig4eTy1xP+gh+WK+WcjCEArSzhn30Jv4+dOmRKQhWzUEBn
         TYC14DSBg1rb+WKE+og6yypsEQQXdpt0txOSlphJstcEdGhI/1WLOVrEqqyVXoasrT
         6CzOUh0jrDBY16DizEHaXesq0h1Jqd/k4Y0DhwJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Park <Chris.Park@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 012/365] drm/amd/display: Check correct bounds for stream encoder instances for DCN303
Date:   Tue, 23 Aug 2022 09:58:33 +0200
Message-Id: <20220823080118.686423588@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 89b008222c2bf21e50219725caed31590edfd9d1 upstream.

[Why & How]
eng_id for DCN303 cannot be more than 1, since we have only two
instances of stream encoders.

Check the correct boundary condition for engine ID for DCN303 prevent
the potential out of bounds access.

Fixes: cd6d421e3d1a ("drm/amd/display: Initial DC support for Beige Goby")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@vger.kernel.org
Reviewed-by: Chris Park <Chris.Park@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
@@ -372,7 +372,7 @@ static struct stream_encoder *dcn303_str
 	int afmt_inst;
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGE) {
+	if (eng_id <= ENGINE_ID_DIGB) {
 		vpg_inst = eng_id;
 		afmt_inst = eng_id;
 	} else


