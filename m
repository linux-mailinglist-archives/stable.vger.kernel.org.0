Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD38E3DD96B
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhHBOAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234435AbhHBN6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D857B60EBB;
        Mon,  2 Aug 2021 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912509;
        bh=VWn1pRYRch8VQtd9CdKf2P13Rx3yuBIScbJ1pJ6oaHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJm00q2eiSGTfXjOzeGSQWFG8xZK1gWWzuK30Qm0VBokaZSodshpGu+KcqAUr+pLO
         dCaMac4NvCnXE8agIblON6uuEWf/vO21FUyr+UY6sRU+p9JKixleBbYbcoOzlm4LSa
         rT+go6KJj/3JDDz5+sR7v1N6LoWPoTpSOpWWxvYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyr Aric <aric.cyr@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Dale Zhao <dale.zhao@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 025/104] drm/amd/display: ensure dentist display clock update finished in DCN20
Date:   Mon,  2 Aug 2021 15:44:22 +0200
Message-Id: <20210802134344.850997612@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dale Zhao <dale.zhao@amd.com>

commit b53e041d8e4308f7324999398aec092dbcb130f5 upstream.

[Why]
We don't check DENTIST_DISPCLK_CHG_DONE to ensure dentist
display clockis updated to target value. In some scenarios with large
display clock margin, it will deliver unfinished display clock and cause
issues like display black screen.

[How]
Checking DENTIST_DISPCLK_CHG_DONE to ensure display clock
has been update to target value before driver do other clock related
actions.

Reviewed-by: Cyr Aric <aric.cyr@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Dale Zhao <dale.zhao@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
@@ -135,7 +135,7 @@ void dcn20_update_clocks_update_dentist(
 
 	REG_UPDATE(DENTIST_DISPCLK_CNTL,
 			DENTIST_DISPCLK_WDIVIDER, dispclk_wdivider);
-//	REG_WAIT(DENTIST_DISPCLK_CNTL, DENTIST_DISPCLK_CHG_DONE, 1, 5, 100);
+	REG_WAIT(DENTIST_DISPCLK_CNTL, DENTIST_DISPCLK_CHG_DONE, 1, 50, 1000);
 	REG_UPDATE(DENTIST_DISPCLK_CNTL,
 			DENTIST_DPPCLK_WDIVIDER, dppclk_wdivider);
 	REG_WAIT(DENTIST_DISPCLK_CNTL, DENTIST_DPPCLK_CHG_DONE, 1, 5, 100);


