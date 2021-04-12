Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DE935BE14
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238690AbhDLI4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238840AbhDLIy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7759161369;
        Mon, 12 Apr 2021 08:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217591;
        bh=QV23nfLcDyAHvWzHcAueEE3r3+Nf6a3TBnLb/GZZRiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSmznqV2RqJmfMjzy4lKqlvRK+y2y6x/1++9SGUlmkueZz+GmXfDDxfKD2XKOXkSj
         +v0ZQKAZLL9JQ/x/nHePQ1p2gumQAA2ZSYJZIMAga1iO7ibIXCf4Ma43Z7mKYB6QOM
         7jvU4Opuwhda6jBIL+VRexCIv9lCtPe8RUdfeYHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 072/188] thunderbolt: Fix off by one in tb_port_find_retimer()
Date:   Mon, 12 Apr 2021 10:39:46 +0200
Message-Id: <20210412084016.048474042@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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


