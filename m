Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850E649A562
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370815AbiAYAGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387192AbiAXXeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:34:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2D7C07597F;
        Mon, 24 Jan 2022 13:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38C9DB8121C;
        Mon, 24 Jan 2022 21:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8C2C340E4;
        Mon, 24 Jan 2022 21:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060170;
        bh=nlpsVFFBLXH+IEIkEIU95YTgMgVg2K0Hj1A5Aq2u94E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DC3y3AaZ+AbIaeAHwep9VUnqMyojbvA7GbjpAx6kay5AvrdZMlGq4iWGq1wNCP+Dk
         wpivzixp1pZANCBiKUM/chkn3BZXRXY3vm2yzxgQqNTbi6pPgsXH1tRAY83j7Cb5u1
         2iejhdn89phDH/spQX24pZtxbQIBbwcylGT4Xzls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yizhuo Zhai <yzhai003@ucr.edu>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 0861/1039] drm/amd/display: Fix the uninitialized variable in enable_stream_features()
Date:   Mon, 24 Jan 2022 19:44:10 +0100
Message-Id: <20220124184154.238652206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yizhuo Zhai <yzhai003@ucr.edu>

commit 0726ed3065eeb910f9cea0c933bc021a848e00b3 upstream.

In function enable_stream_features(), the variable "old_downspread.raw"
could be uninitialized if core_link_read_dpcd() fails, however, it is
used in the later if statement, and further, core_link_write_dpcd()
may write random value, which is potentially unsafe.

Fixes: 6016cd9dba0f ("drm/amd/display: add helper for enabling mst stream features")
Cc: stable@vger.kernel.org
Signed-off-by: Yizhuo Zhai <yzhai003@ucr.edu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1844,6 +1844,8 @@ static void enable_stream_features(struc
 		union down_spread_ctrl old_downspread;
 		union down_spread_ctrl new_downspread;
 
+		memset(&old_downspread, 0, sizeof(old_downspread));
+
 		core_link_read_dpcd(link, DP_DOWNSPREAD_CTRL,
 				&old_downspread.raw, sizeof(old_downspread));
 


