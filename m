Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6FE4C7568
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbiB1Ryy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiB1Rwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:52:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72028A8EEE;
        Mon, 28 Feb 2022 09:40:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 869E561541;
        Mon, 28 Feb 2022 17:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7D4C340E7;
        Mon, 28 Feb 2022 17:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070003;
        bh=FeXWa6P1qRtmPfj0mdtYpxdTQB265wDqpUFzlISXYoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3xVOMnuiSgBdINMAkK9xMUuiblBfZiRC9AnuLuPt4ARO9PvuTTIXNfh5TRPB3ikd
         ZMoZVNWWl3D4uVJRdG7rMt0HqxBw8on5e5Ybbb5WIK6zuGgFMmiR/oDBdi/S0llO61
         Jq4ZWEP0mK9IQ9SaZ/NyFErG61zuWHbzbJOg7GPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Maurer <fmaurer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.15 052/139] selftests: bpf: Check bpf_msg_push_data return value
Date:   Mon, 28 Feb 2022 18:23:46 +0100
Message-Id: <20220228172353.189917000@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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

commit 61d06f01f9710b327a53492e5add9f972eb909b3 upstream.

bpf_msg_push_data may return a non-zero value to indicate an error. The
return value should be checked to prevent undetected errors.

To indicate an error, the BPF programs now perform a different action
than their intended one to make the userspace test program notice the
error, i.e., the programs supposed to pass/redirect drop, the program
supposed to drop passes.

Fixes: 84fbfe026acaa ("bpf: test_sockmap add options to use msg_push_data")
Signed-off-by: Felix Maurer <fmaurer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/89f767bb44005d6b4dd1f42038c438f76b3ebfad.1644601294.git.fmaurer@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/test_sockmap_kern.h |   26 ++++++++++++------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -235,7 +235,7 @@ SEC("sk_msg1")
 int bpf_prog4(struct sk_msg_md *msg)
 {
 	int *bytes, zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
-	int *start, *end, *start_push, *end_push, *start_pop, *pop;
+	int *start, *end, *start_push, *end_push, *start_pop, *pop, err = 0;
 
 	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
 	if (bytes)
@@ -249,8 +249,11 @@ int bpf_prog4(struct sk_msg_md *msg)
 		bpf_msg_pull_data(msg, *start, *end, 0);
 	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
 	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+	if (start_push && end_push) {
+		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
+		if (err)
+			return SK_DROP;
+	}
 	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
 	pop = bpf_map_lookup_elem(&sock_bytes, &five);
 	if (start_pop && pop)
@@ -263,6 +266,7 @@ int bpf_prog6(struct sk_msg_md *msg)
 {
 	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, key = 0;
 	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop, *f;
+	int err = 0;
 	__u64 flags = 0;
 
 	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
@@ -279,8 +283,11 @@ int bpf_prog6(struct sk_msg_md *msg)
 
 	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
 	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+	if (start_push && end_push) {
+		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
+		if (err)
+			return SK_DROP;
+	}
 
 	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
 	pop = bpf_map_lookup_elem(&sock_bytes, &five);
@@ -338,7 +345,7 @@ SEC("sk_msg5")
 int bpf_prog10(struct sk_msg_md *msg)
 {
 	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop;
-	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
+	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, err = 0;
 
 	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
 	if (bytes)
@@ -352,8 +359,11 @@ int bpf_prog10(struct sk_msg_md *msg)
 		bpf_msg_pull_data(msg, *start, *end, 0);
 	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
 	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+	if (start_push && end_push) {
+		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
+		if (err)
+			return SK_PASS;
+	}
 	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
 	pop = bpf_map_lookup_elem(&sock_bytes, &five);
 	if (start_pop && pop)


