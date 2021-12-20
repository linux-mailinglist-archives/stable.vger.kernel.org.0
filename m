Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1720547AE9E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbhLTPBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37442 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238869AbhLTO7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67A3CB80EE3;
        Mon, 20 Dec 2021 14:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C205C36AFA;
        Mon, 20 Dec 2021 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012354;
        bh=T6HKtKwp2T0zxR3Mdh4vYx/vs9MvNSLfdkOMGZCxZtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JA1yyIz7TNEEqYX3geFNgmrTNpzPFhMrvGZ83CcO8fmHQks8afrJ9zIUFiRFtR/fx
         3fIRR702zZ67NPtLv90/1ADKWoyFPU3CxQhk3Wd/XHkVVH/u2bO64z2dtSgq8MsLN1
         MJHtjxJNHTh4sqoz65yzMoNvDrWip/1dYib/ek4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.15 170/177] bus: ti-sysc: Fix variable set but not used warning for reinit_modules
Date:   Mon, 20 Dec 2021 15:35:20 +0100
Message-Id: <20211220143045.794911052@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
@@ -2456,12 +2456,11 @@ static void sysc_reinit_modules(struct s
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
 


