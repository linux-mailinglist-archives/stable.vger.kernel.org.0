Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D5B35BFCB
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239131AbhDLJG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239992AbhDLJE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8C9161353;
        Mon, 12 Apr 2021 09:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218122;
        bh=QV23nfLcDyAHvWzHcAueEE3r3+Nf6a3TBnLb/GZZRiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjPuVrxEEU0LNvUGbySeqVD/0pN42tcW+o+xhiRyO+WAK2F7m0eQKeLtl66S+XgqD
         XQW0R9lM1dIsZLVBaqTMjkg6nrstLsoaFORwYuZORmOIPc9eODv6LvDHgoJUbETMCJ
         crld6pTWq/lWlfQnPd59+52OXLJZMIHg1ndF9yEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.11 079/210] thunderbolt: Fix off by one in tb_port_find_retimer()
Date:   Mon, 12 Apr 2021 10:39:44 +0200
Message-Id: <20210412084018.645871004@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 08fe7ae1857080f5075df5ac7fef2ecd4e289117 upstream.

This array uses 1-based indexing so it corrupts memory one element
beyond of the array.  Fix it by making the array one element larger.

Fixes: dacb12877d92 ("thunderbolt: Add support for on-board retimers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/retimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -406,7 +406,7 @@ static struct tb_retimer *tb_port_find_r
  */
 int tb_retimer_scan(struct tb_port *port)
 {
-	u32 status[TB_MAX_RETIMER_INDEX] = {};
+	u32 status[TB_MAX_RETIMER_INDEX + 1] = {};
 	int ret, i, last_idx = 0;
 
 	if (!port->cap_usb4)


