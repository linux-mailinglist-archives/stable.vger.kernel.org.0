Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D6A499DA1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585837AbiAXWZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582521AbiAXWPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:15:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31D6C04966B;
        Mon, 24 Jan 2022 12:44:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90B2160916;
        Mon, 24 Jan 2022 20:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73175C340E5;
        Mon, 24 Jan 2022 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057069;
        bh=gwgPjWSWczhCM707M4A73QDHr9lUE93iY+fr2ZEHdIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3/y9PnrE9WaGwQ2ia4/CdhMifZVSZGuPX1xdq7jOcUoyI2/5uCay6YtPOnjpGy07
         KyLBiy/wG6dXMa8flYIgx4QPffskTVb/6lnC0Jt/0Ma3LW+o+6s6saY1XlQUDCu1+h
         WGAbjFi8b4bWIuxxJLkhgkd1FtGNOmyr6Z69tKm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yizhuo Zhai <yzhai003@ucr.edu>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 692/846] drm/amd/display: Fix the uninitialized variable in enable_stream_features()
Date:   Mon, 24 Jan 2022 19:43:29 +0100
Message-Id: <20220124184124.916573388@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -1696,6 +1696,8 @@ static void enable_stream_features(struc
 		union down_spread_ctrl old_downspread;
 		union down_spread_ctrl new_downspread;
 
+		memset(&old_downspread, 0, sizeof(old_downspread));
+
 		core_link_read_dpcd(link, DP_DOWNSPREAD_CTRL,
 				&old_downspread.raw, sizeof(old_downspread));
 


