Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512CF2F7BA2
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbhAOMbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732712AbhAOMbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCC5D22473;
        Fri, 15 Jan 2021 12:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713881;
        bh=uMdNXkUexgJkUkxCn8w7XcmVpbwfHk3wbYFwk5yKHz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaZ1kYt/Ga0g9tQ8p/nML3FIuf1bpb0qsZTGkf9FC02muEDqRCwdpZyQ61+Gvq704
         uIAUK2I0Lv9GeGijO027z4zen2iSjxpeTUBjtvaLJBCEtKdFIDrQ1u6i2RZrf0wrCp
         amDlVsT0GINtzl/+ry5CNoUZLdUY5eAyS8fgshZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 03/28] net: vlan: avoid leaks on register_vlan_dev() failures
Date:   Fri, 15 Jan 2021 13:27:40 +0100
Message-Id: <20210115121956.910353121@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 55b7ab1178cbf41f979ff83236d3321ad35ed2ad ]

VLAN checks for NETREG_UNINITIALIZED to distinguish between
registration failure and unregistration in progress.

Since commit cb626bf566eb ("net-sysfs: Fix reference count leak")
registration failure may, however, result in NETREG_UNREGISTERED
as well as NETREG_UNINITIALIZED.

This fix is similer to cebb69754f37 ("rtnetlink: Fix
memory(net_device) leak when ->newlink fails")

Fixes: cb626bf566eb ("net-sysfs: Fix reference count leak")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -272,7 +272,8 @@ static int register_vlan_device(struct n
 	return 0;
 
 out_free_newdev:
-	if (new_dev->reg_state == NETREG_UNINITIALIZED)
+	if (new_dev->reg_state == NETREG_UNINITIALIZED ||
+	    new_dev->reg_state == NETREG_UNREGISTERED)
 		free_netdev(new_dev);
 	return err;
 }


