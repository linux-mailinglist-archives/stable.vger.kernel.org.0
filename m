Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DBC505302
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbiDRMzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240309AbiDRMyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:54:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410F013F36;
        Mon, 18 Apr 2022 05:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C947E611C9;
        Mon, 18 Apr 2022 12:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B961EC385A7;
        Mon, 18 Apr 2022 12:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285301;
        bh=f9YULfdDdfUm3+QZ9PxqPMzL3D8AJK7//f2Q9oOG6b8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jd4NfeYCyzbQhiFaXRpjnlTbUM5XFRkK8GMS7GONu6jAy8Q4SAEJ/8p8FhGkOdV3d
         m6Taz8upYtcEZr5eYEbqBXB6g3aew7Ng+dVv46b/McsXHbVs48AopWf76igeoi2YfS
         yXQ6jwlxK/U+lMWCrHD7lU6E4ezacAOXLu4gDb6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 164/189] drm/amdgpu: Enable gfxoff quirk on MacBook Pro
Date:   Mon, 18 Apr 2022 14:13:04 +0200
Message-Id: <20220418121207.074886389@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

From: Tomasz Moń <desowin@gmail.com>

commit 4593c1b6d159f1e5c35c07a7f125e79e5a864302 upstream.

Enabling gfxoff quirk results in perfectly usable graphical user
interface on MacBook Pro (15-inch, 2019) with Radeon Pro Vega 20 4 GB.

Without the quirk, X server is completely unusable as every few seconds
there is gpu reset due to ring gfx timeout.

Signed-off-by: Tomasz Moń <desowin@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1272,6 +1272,8 @@ static const struct amdgpu_gfxoff_quirk
 	{ 0x1002, 0x15dd, 0x103c, 0x83e7, 0xd3 },
 	/* GFXOFF is unstable on C6 parts with a VBIOS 113-RAVEN-114 */
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc6 },
+	/* Apple MacBook Pro (15-inch, 2019) Radeon Pro Vega 20 4 GB */
+	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	{ 0, 0, 0, 0, 0 },
 };
 


