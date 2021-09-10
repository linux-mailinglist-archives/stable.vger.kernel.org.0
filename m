Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A571240678A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 09:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhIJHOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 03:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231334AbhIJHOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 03:14:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0541F60F9C;
        Fri, 10 Sep 2021 07:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631257991;
        bh=M9qjLVJMAfDr7JMIUjViEt0yNYrwGCYy1Ddv0eVkRvg=;
        h=Subject:To:Cc:From:Date:From;
        b=P2iYC4RSJERq9TVcY734skVSdlfxIlNaTnOA/b8X4UGp4MBNubToayQN+NWkMSq3I
         TXmneoDAv2itWas0wT3+tV423WNKeKT6V0tl0SCxvpJBexhULwUBqT8Rd8qP/sCTrP
         9A38ksRaZjqn3IYzS4q28cdXu+hO+qKvqIEyEYfg=
Subject: FAILED: patch "[PATCH] cxl/pci: Fix lockdown level" failed to apply to 5.13-stable tree
To:     dan.j.williams@intel.com, Jonathan.Cameron@huawei.com,
        ben.widawsky@intel.com, omosnace@redhat.com, paul@paul-moore.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Sep 2021 09:13:08 +0200
Message-ID: <1631257988233180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9e56614c44b994b78fc9fcb2070bcbe3f5df0d7b Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Sep 2021 19:20:45 -0700
Subject: [PATCH] cxl/pci: Fix lockdown level

A proposed rework of security_locked_down() users identified that the
cxl_pci driver was passing the wrong lockdown_reason. Update
cxl_mem_raw_command_allowed() to fail raw command access when raw pci
access is also disabled.

Fixes: 13237183c735 ("cxl/mem: Add a "RAW" send command")
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 651e8d4ec974..37903259ee79 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -575,7 +575,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
 	if (!IS_ENABLED(CONFIG_CXL_MEM_RAW_COMMANDS))
 		return false;
 
-	if (security_locked_down(LOCKDOWN_NONE))
+	if (security_locked_down(LOCKDOWN_PCI_ACCESS))
 		return false;
 
 	if (cxl_raw_allow_all)

