Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55934726BF
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbhLMJyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbhLMJv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:51:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9CCC08EAD2;
        Mon, 13 Dec 2021 01:44:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9520FB80E15;
        Mon, 13 Dec 2021 09:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5EEC00446;
        Mon, 13 Dec 2021 09:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388673;
        bh=iov5NoUFnieE7nnGUzIju4copu3+6BiwBAfvAoQiVzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9n0CQratsk+5z0y2SHrXH3IELiWNY/CN4294/VexaXxYrtSGdMLLu2gxIlS/uEYO
         r70lrXYJhBqQaogMLN2o9oGTLbplUK9KdBx0JhgHHlcJgW9mboxZuHpjxA2vo06LLp
         5dCQ4DvB+HYAPcpK6iErm4omO0WDECP10QI2AVlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 15/88] nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done
Date:   Mon, 13 Dec 2021 10:29:45 +0100
Message-Id: <20211213092933.740955981@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 4cd8371a234d051f9c9557fcbb1f8c523b1c0d10 upstream.

The done() netlink callback nfc_genl_dump_ses_done() should check if
received argument is non-NULL, because its allocation could fail earlier
in dumpit() (nfc_genl_dump_ses()).

Fixes: ac22ac466a65 ("NFC: Add a GET_SE netlink API")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211209081307.57337-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1400,8 +1400,10 @@ static int nfc_genl_dump_ses_done(struct
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 
-	nfc_device_iter_exit(iter);
-	kfree(iter);
+	if (iter) {
+		nfc_device_iter_exit(iter);
+		kfree(iter);
+	}
 
 	return 0;
 }


