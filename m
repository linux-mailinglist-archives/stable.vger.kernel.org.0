Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFF84F39F6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378916AbiDELjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354178AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EA3527EF;
        Tue,  5 Apr 2022 02:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A186167E;
        Tue,  5 Apr 2022 09:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C16C385A2;
        Tue,  5 Apr 2022 09:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152682;
        bh=957SGL9KQznzdENY4XdnryY6MFqclkMVRwcwl8CH+qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPzGdoFltwH3TGxMYYISUNdT1MGvpNTAdn5rkS0aPav1NbM/Q7sFjO7YB0trJpvrm
         /wbPwzwcsDab8zU1/AMB+7wTvQujVUpvlb+q+KhBgRCuk4lV0QCuUueuZTRs5dPBdq
         1EDH6ttxuhVAfZ4bTE9/v2iTsyqo+5ErMHQduQqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Zeal Robot <zealci@zte.com.cn>, Lv Ruyi <lv.ruyi@zte.com.cn>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 863/913] proc: bootconfig: Add null pointer check
Date:   Tue,  5 Apr 2022 09:32:05 +0200
Message-Id: <20220405070405.693718564@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

commit bed5b60bf67ccd8957b8c0558fead30c4a3f5d3f upstream.

kzalloc is a memory allocation function which can return NULL when some
internal memory errors happen. It is safer to add null pointer check.

Link: https://lkml.kernel.org/r/20220329104004.2376879-1-lv.ruyi@zte.com.cn

Cc: stable@vger.kernel.org
Fixes: c1a3c36017d4 ("proc: bootconfig: Add /proc/bootconfig to show boot config list")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/bootconfig.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/bootconfig.c
+++ b/fs/proc/bootconfig.c
@@ -32,6 +32,8 @@ static int __init copy_xbc_key_value_lis
 	int ret = 0;
 
 	key = kzalloc(XBC_KEYLEN_MAX, GFP_KERNEL);
+	if (!key)
+		return -ENOMEM;
 
 	xbc_for_each_key_value(leaf, val) {
 		ret = xbc_node_compose_key(leaf, key, XBC_KEYLEN_MAX);


