Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8414D50F6DB
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbiDZJBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345815AbiDZI5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:57:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D7538BF;
        Tue, 26 Apr 2022 01:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBD90B81CED;
        Tue, 26 Apr 2022 08:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF93C385A0;
        Tue, 26 Apr 2022 08:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962561;
        bh=u4sbI5XwVnMsxy9SXjtwcoKdZpij0eoP3VcDQagwUCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwZXenHQrKvWIhD4C/4kLCQMeDmsjSUGeAohHCmYNS8EOLXZ3mfqa7iffv62tQPzq
         nNzVPvGxre/6ihKxQBEKSrwVJuw1Vjx8ZzrUxeyqRVzIsqrmQ+X/cfHsImVwE9r7tB
         AtnlF8Oel9Qz5+IDVM62H+pb1lpzajeSH3HsQdKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 003/146] drm/amd/display: Only set PSR version when valid
Date:   Tue, 26 Apr 2022 10:19:58 +0200
Message-Id: <20220426081750.156293191@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 1210b17dd4ece454d68a9283f391e3b036aeb010 upstream.

[Why]
DMCUB will hang if we send a PSR unsupported set version command.

This can occur if we fall-through into the default case in the switch
statement for PSR version.

[How]
Add an unsupported check after the switch statement.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
@@ -138,6 +138,10 @@ static bool dmub_psr_set_version(struct
 		cmd.psr_set_version.psr_set_version_data.version = PSR_VERSION_UNSUPPORTED;
 		break;
 	}
+
+	if (cmd.psr_set_version.psr_set_version_data.version == PSR_VERSION_UNSUPPORTED)
+		return false;
+
 	cmd.psr_set_version.psr_set_version_data.cmd_version = DMUB_CMD_PSR_CONTROL_VERSION_1;
 	cmd.psr_set_version.psr_set_version_data.panel_inst = panel_inst;
 	cmd.psr_set_version.header.payload_bytes = sizeof(struct dmub_cmd_psr_set_version_data);


