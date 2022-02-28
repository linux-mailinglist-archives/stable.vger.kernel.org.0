Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC3B4C7354
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbiB1Ree (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238660AbiB1Rdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:33:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C33292851;
        Mon, 28 Feb 2022 09:30:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD36B815B8;
        Mon, 28 Feb 2022 17:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B24AC340E7;
        Mon, 28 Feb 2022 17:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069426;
        bh=ACLnAZQIR5psZ8uhJCL76WGjXIdm6NzshqJBZPCBeCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUA5lYkLWFOE6AtZc7OXFmSDOig08O9wBLKP/0O0tQyZ8jBws5/A9/Pwc//yPts72
         cpzw+hssUqv9vVv0w5lhtrCUrujbnueoHSog1mzVaR0gwCxoU3YbbX2EqwGBiWEFKf
         SdG5M6jqYM6VFWmRwCNW7CtnQB3fxGOZrTspKir4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Maurer <fmaurer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.4 16/53] bpf: Do not try bpf_msg_push_data with len 0
Date:   Mon, 28 Feb 2022 18:24:14 +0100
Message-Id: <20220228172249.525088925@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Maurer <fmaurer@redhat.com>

commit 4a11678f683814df82fca9018d964771e02d7e6d upstream.

If bpf_msg_push_data() is called with len 0 (as it happens during
selftests/bpf/test_sockmap), we do not need to do anything and can
return early.

Calling bpf_msg_push_data() with len 0 previously lead to a wrong ENOMEM
error: we later called get_order(copy + len); if len was 0, copy + len
was also often 0 and get_order() returned some undefined value (at the
moment 52). alloc_pages() caught that and failed, but then bpf_msg_push_data()
returned ENOMEM. This was wrong because we are most probably not out of
memory and actually do not need any additional memory.

Fixes: 6fff607e2f14b ("bpf: sk_msg program helper bpf_msg_push_data")
Signed-off-by: Felix Maurer <fmaurer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/df69012695c7094ccb1943ca02b4920db3537466.1644421921.git.fmaurer@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2516,6 +2516,9 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_m
 	if (unlikely(flags))
 		return -EINVAL;
 
+	if (unlikely(len == 0))
+		return 0;
+
 	/* First find the starting scatterlist element */
 	i = msg->sg.start;
 	do {


