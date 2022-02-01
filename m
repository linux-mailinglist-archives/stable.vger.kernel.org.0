Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502F54A637E
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241836AbiBASRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242030AbiBASRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:17:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72745C061714;
        Tue,  1 Feb 2022 10:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1038E61344;
        Tue,  1 Feb 2022 18:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1DDC340EC;
        Tue,  1 Feb 2022 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739460;
        bh=+Tt8/wcnT5N0irPuL1e8n9KIuuw8QetCk5fN9t7p/Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNM9LdSyCVc4LBMBR5/4OZfozu6E8lfpAZQsT3YXlGOz8SpCVupiou/N9BrBVR7tU
         NjTGU42hdTYzCvMOjgf35Ht/ZUJdcPkwwf/Kinrh/tgc3NXOf0lb7M55OAbFK1xB0t
         5JOiQmf29Mos0cITPRARrvgYWiJCWtmTH8jXYpbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH 4.4 22/25] Bluetooth: MGMT: Fix misplaced BT_HS check
Date:   Tue,  1 Feb 2022 19:16:46 +0100
Message-Id: <20220201180822.872365848@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Bertholon <guillaume.bertholon@ens.fr>

The upstream commit b560a208cda0 ("Bluetooth: MGMT: Fix not checking if
BT_HS is enabled") inserted a new check in the `set_hs` function.
However, its backported version in stable (commit 5abe9f99f512
("Bluetooth: MGMT: Fix not checking if BT_HS is enabled")),
added the check in `set_link_security` instead.

This patch restores the intent of the upstream commit by moving back the
BT_HS check to `set_hs`.

Fixes: 5abe9f99f512 ("Bluetooth: MGMT: Fix not checking if BT_HS is enabled")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2285,10 +2285,6 @@ static int set_link_security(struct sock
 
 	BT_DBG("request for %s", hdev->name);
 
-	if (!IS_ENABLED(CONFIG_BT_HS))
-		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
-				       MGMT_STATUS_NOT_SUPPORTED);
-
 	status = mgmt_bredr_support(hdev);
 	if (status)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_LINK_SECURITY,
@@ -2438,6 +2434,10 @@ static int set_hs(struct sock *sk, struc
 
 	BT_DBG("request for %s", hdev->name);
 
+	if (!IS_ENABLED(CONFIG_BT_HS))
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
+				       MGMT_STATUS_NOT_SUPPORTED);
+
 	status = mgmt_bredr_support(hdev);
 	if (status)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS, status);


