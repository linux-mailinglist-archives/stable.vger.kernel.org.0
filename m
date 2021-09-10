Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C95F406B93
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhIJMcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233367AbhIJMck (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F507611C9;
        Fri, 10 Sep 2021 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277089;
        bh=WFWK/09lBNfAtxGfozjNZrWrz3JqIkV9UdcgteRxojk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6JsnrwIwo34186PKX2dsU04+9tvNEmu5Alp9QL/LcKqAmCxk8MbKc5O3+wkOX7C7
         JT6rFR9o+KOLgr7lCga8JBIBhJor6FPCz0IFS6P3yfVS27JrbEE/ZUPcekfiGjiteP
         WWD6OjsBvUUv+blmXpppENK7Qc/QmlW929tIYML0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.14 22/23] cxl/pci: Fix lockdown level
Date:   Fri, 10 Sep 2021 14:30:12 +0200
Message-Id: <20210910122916.709969307@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 9e56614c44b994b78fc9fcb2070bcbe3f5df0d7b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -568,7 +568,7 @@ static bool cxl_mem_raw_command_allowed(
 	if (!IS_ENABLED(CONFIG_CXL_MEM_RAW_COMMANDS))
 		return false;
 
-	if (security_locked_down(LOCKDOWN_NONE))
+	if (security_locked_down(LOCKDOWN_PCI_ACCESS))
 		return false;
 
 	if (cxl_raw_allow_all)


