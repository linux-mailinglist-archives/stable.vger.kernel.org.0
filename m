Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9FB499FB3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842049AbiAXXAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835949AbiAXWhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EF2C0E9BB8;
        Mon, 24 Jan 2022 13:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAC5861320;
        Mon, 24 Jan 2022 21:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAABC340E5;
        Mon, 24 Jan 2022 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058027;
        bh=5CefI8kLlzwKiG7jZGtST77aCSVR1qeHJlatpgTEvLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mguJWQtVLjqWfMZ0C3r+TLCcSe7RHMUbwljXjjQGcbcPUSrRjuah+hCa6rrpCeqBP
         pO59L/3p/sLQCPYH9WoWqN0dlOOZGteRFrcLrYaSh0Sy3i7pH75gYKHA+VvFOMIMTQ
         nnyepxo9RP3o2Umx9n6zDU/ccs0AEFKNEDF87NDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0124/1039] media: atomisp: do not use err var when checking port validity for ISP2400
Date:   Mon, 24 Jan 2022 19:31:53 +0100
Message-Id: <20220124184129.313744301@linuxfoundation.org>
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

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit 9f6b4fa2d2dfbff4b8a57eeb39b1128a6094ee20 ]

Currently, the `port >= N_CSI_PORTS || err` checks for ISP2400 are always
evaluated as true because the err variable is set to `-EINVAL` on
declaration but the variable is never used until the evaluation.

Looking at the diff of commit 3c0538fbad9f ("media: atomisp: get rid of
most checks for ISP2401 version"), the `port >= N_CSI_PORTS` check is
for ISP2400 and the err variable check is for ISP2401. Fix this issue
by adding ISP version test there accordingly.

Fixes: 3c0538fbad9f ("media: atomisp: get rid of most checks for ISP2401 version")
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css_mipi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css_mipi.c b/drivers/staging/media/atomisp/pci/sh_css_mipi.c
index 483d40a467c74..65fc93c5d56bc 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_mipi.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_mipi.c
@@ -430,7 +430,8 @@ allocate_mipi_frames(struct ia_css_pipe *pipe,
 
 	assert(port < N_CSI_PORTS);
 
-	if (port >= N_CSI_PORTS || err) {
+	if ((!IS_ISP2401 && port >= N_CSI_PORTS) ||
+	    (IS_ISP2401 && err)) {
 		ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE,
 				    "allocate_mipi_frames(%p) exit: error: port is not correct (port=%d).\n",
 				    pipe, port);
@@ -559,7 +560,8 @@ free_mipi_frames(struct ia_css_pipe *pipe)
 
 		assert(port < N_CSI_PORTS);
 
-		if (port >= N_CSI_PORTS || err) {
+		if ((!IS_ISP2401 && port >= N_CSI_PORTS) ||
+		    (IS_ISP2401 && err)) {
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE,
 					    "free_mipi_frames(%p, %d) exit: error: pipe port is not correct.\n",
 					    pipe, port);
@@ -670,7 +672,8 @@ send_mipi_frames(struct ia_css_pipe *pipe)
 
 	assert(port < N_CSI_PORTS);
 
-	if (port >= N_CSI_PORTS || err) {
+	if ((!IS_ISP2401 && port >= N_CSI_PORTS) ||
+	    (IS_ISP2401 && err)) {
 		IA_CSS_ERROR("send_mipi_frames(%p) exit: invalid port specified (port=%d).\n",
 			     pipe, port);
 		return err;
-- 
2.34.1



