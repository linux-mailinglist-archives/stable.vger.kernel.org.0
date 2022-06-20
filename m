Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FCA5519DA
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244712AbiFTNFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244038AbiFTNEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9287E186E4;
        Mon, 20 Jun 2022 05:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51755B811BE;
        Mon, 20 Jun 2022 12:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9990C3411B;
        Mon, 20 Jun 2022 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729978;
        bh=R1/XwB4xM2LGN1vbIhBm7hfqiiYghXeGUIAqoxloBZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTkUtg/5UnIxt8Rq6kXOwzsIlRB9bh5+zCmU3EkicGYf3ltBKMUC0a3pvEyhwEvl6
         KW53B1WN1TNTd3uB2GSBjUhcRjF8ynjkZxOYfaNN624Qh6IJklHHSmIfajySSxfmlB
         MqIcREOBMPKJZ9QCUSRMCkyaFZu3eNDUWIQ6mcfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.18 136/141] bpf: Use safer kvmalloc_array() where possible
Date:   Mon, 20 Jun 2022 14:51:14 +0200
Message-Id: <20220620124733.580621777@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit fd58f7df2415ef747782e01f94880fefad1247cf upstream.

The kvmalloc_array() function is safer because it has a check for
integer overflows.  These sizes come from the user and I was not
able to see any bounds checking so an integer overflow seems like a
realistic concern.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/Yo9VRVMeHbALyjUH@kili
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2433,7 +2433,7 @@ int bpf_kprobe_multi_link_attach(const u
 		return -EINVAL;
 
 	size = cnt * sizeof(*addrs);
-	addrs = kvmalloc(size, GFP_KERNEL);
+	addrs = kvmalloc_array(cnt, sizeof(*addrs), GFP_KERNEL);
 	if (!addrs)
 		return -ENOMEM;
 
@@ -2450,7 +2450,7 @@ int bpf_kprobe_multi_link_attach(const u
 
 	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
 	if (ucookies) {
-		cookies = kvmalloc(size, GFP_KERNEL);
+		cookies = kvmalloc_array(cnt, sizeof(*addrs), GFP_KERNEL);
 		if (!cookies) {
 			err = -ENOMEM;
 			goto error;


