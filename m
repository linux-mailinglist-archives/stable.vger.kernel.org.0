Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB16358DA
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiKWKDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbiKWKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:01:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBF011E722
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:54:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42C02B81EF8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD166C433C1;
        Wed, 23 Nov 2022 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197240;
        bh=QzTG6WIwpKkNcDDUpnzaED3rciHT9jggQIAVbDasb3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ruz2Yl42v6NmeK7Gb5GKGj3IN+tK4PSpapeoH4/7jFHK49GnigSE3/1FbrBfqwjmZ
         lSKlhCwbz8pfLJwu3qKHlgUby809mEq2IL4P06fK1EAq+G71PX5pd9lIhLs1SlumWZ
         Dd60RLG5I4QUjmQ0iqsrzvN0cxYBjBqs7wJpIOFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yi Yang <yiyang13@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.0 207/314] rethook: fix a potential memleak in rethook_alloc()
Date:   Wed, 23 Nov 2022 09:50:52 +0100
Message-Id: <20221123084634.919907731@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Yang <yiyang13@huawei.com>

commit 0a1ebe35cb3b7aa1f4b26b37e2a0b9ae68dc4ffb upstream.

In rethook_alloc(), the variable rh is not freed or passed out
if handler is NULL, which could lead to a memleak, fix it.

Link: https://lore.kernel.org/all/20221110104438.88099-1-yiyang13@huawei.com/
[Masami: Add "rethook:" tag to the title.]

Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Acke-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/rethook.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -83,8 +83,10 @@ struct rethook *rethook_alloc(void *data
 {
 	struct rethook *rh = kzalloc(sizeof(struct rethook), GFP_KERNEL);
 
-	if (!rh || !handler)
+	if (!rh || !handler) {
+		kfree(rh);
 		return NULL;
+	}
 
 	rh->data = data;
 	rh->handler = handler;


