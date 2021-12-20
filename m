Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC6947AE63
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhLTPBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbhLTO6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D796C06137E;
        Mon, 20 Dec 2021 06:50:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1DCD611A8;
        Mon, 20 Dec 2021 14:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C301FC36AE7;
        Mon, 20 Dec 2021 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011839;
        bh=epq09kJPYGqIBJJuEFlkzwSz9EkV+wtt0jEK7RK5+ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0b1ZBHX2FPWRVUdbKKNeQ/PuszU2EiSqmMYDHCb4wsCYWY9K5c4Wp7V4xp4wovb2q
         onSajZ+i1HX9GMAFbRJu68KDRHDb1CUv2qkumBmosb4pryqmMZKHoDwD/khsRO7HBO
         XBVRFNPGpbEnJS1249KJGHMacgHm2rFhsJSEX8GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.10 93/99] bus: ti-sysc: Fix variable set but not used warning for reinit_modules
Date:   Mon, 20 Dec 2021 15:35:06 +0100
Message-Id: <20211220143032.529547069@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 1b1da99b845337362a3dafe0f7b49927ab4ae041 upstream.

Fix drivers/bus/ti-sysc.c:2494:13: error: variable 'error' set but not
used introduced by commit 9d881361206e ("bus: ti-sysc: Add quirk handling
for reinit on context lost").

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/ti-sysc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2443,12 +2443,11 @@ static void sysc_reinit_modules(struct s
 	struct sysc_module *module;
 	struct list_head *pos;
 	struct sysc *ddata;
-	int error = 0;
 
 	list_for_each(pos, &sysc_soc->restored_modules) {
 		module = list_entry(pos, struct sysc_module, node);
 		ddata = module->ddata;
-		error = sysc_reinit_module(ddata, ddata->enabled);
+		sysc_reinit_module(ddata, ddata->enabled);
 	}
 }
 


