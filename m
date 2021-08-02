Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4E93DD8E5
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhHBNzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236113AbhHBNy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 197A3610FD;
        Mon,  2 Aug 2021 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912393;
        bh=VWn1pRYRch8VQtd9CdKf2P13Rx3yuBIScbJ1pJ6oaHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwCFNWEGUcotDnEe926TX+2sC6UJf7uNB1rXpYs8mmTl+rP/ul35QGiptmiFMXYEB
         m55gWWCUul4VsUwfhaOfEEXVcjV7zHpGVx88LTG03Xte7UjCoAM8XWSnJOEpCbV9Fu
         W+BBi3qrXsfSGlrXZCaraZvCTqGF2VzCcEKE01Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyr Aric <aric.cyr@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Dale Zhao <dale.zhao@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 22/67] drm/amd/display: ensure dentist display clock update finished in DCN20
Date:   Mon,  2 Aug 2021 15:44:45 +0200
Message-Id: <20210802134339.771646255@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
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


