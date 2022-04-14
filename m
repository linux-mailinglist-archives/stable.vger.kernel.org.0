Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A15011C4
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240947AbiDNOEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346616AbiDNN5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:57:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2FFB1883;
        Thu, 14 Apr 2022 06:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6B99B82894;
        Thu, 14 Apr 2022 13:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A20AC385A5;
        Thu, 14 Apr 2022 13:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944059;
        bh=1YSXq97S+Q4jYIJd4a7+sV73lAvthooMeqFEbp6tLdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9riB27A1KNLBbiXygAAQFKdlVGmBJrlIlZ/JtiI3aAsvGUmjZI0RUsQZvxis9+OL
         1JA0WeAQLe4qMlEpfLN6wD3yya9cZt+IPPU3Lk3K5Kac+JXzvJvyr3u5pznSbiAaRN
         /2mAOrD+Y23zCOw2KMwn1vCeU16RfZNJrll6ZdWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 378/475] bpf: Make dst_port field in struct bpf_sock 16-bit wide
Date:   Thu, 14 Apr 2022 15:12:43 +0200
Message-Id: <20220414110905.652113437@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 4421a582718ab81608d8486734c18083b822390d ]

Menglong Dong reports that the documentation for the dst_port field in
struct bpf_sock is inaccurate and confusing. From the BPF program PoV, the
field is a zero-padded 16-bit integer in network byte order. The value
appears to the BPF user as if laid out in memory as so:

  offsetof(struct bpf_sock, dst_port) + 0  <port MSB>
                                      + 8  <port LSB>
                                      +16  0x00
                                      +24  0x00

32-, 16-, and 8-bit wide loads from the field are all allowed, but only if
the offset into the field is 0.

32-bit wide loads from dst_port are especially confusing. The loaded value,
after converting to host byte order with bpf_ntohl(dst_port), contains the
port number in the upper 16-bits.

Remove the confusion by splitting the field into two 16-bit fields. For
backward compatibility, allow 32-bit wide loads from offsetof(struct
bpf_sock, dst_port).

While at it, allow loads 8-bit loads at offset [0] and [1] from dst_port.

Reported-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20220130115518.213259-2-jakub@cloudflare.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h |  3 ++-
 net/core/filter.c        | 10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0bfad86ec960..cb0631098f91 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3068,7 +3068,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__be16 dst_port;	/* network byte order */
+	__u16 :16;		/* zero padding */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
diff --git a/net/core/filter.c b/net/core/filter.c
index d39518f691b4..54c5e3c379f6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6708,6 +6708,7 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 			      struct bpf_insn_access_aux *info)
 {
 	const int size_default = sizeof(__u32);
+	int field_size;
 
 	if (off < 0 || off >= sizeof(struct bpf_sock))
 		return false;
@@ -6719,7 +6720,6 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case offsetof(struct bpf_sock, family):
 	case offsetof(struct bpf_sock, type):
 	case offsetof(struct bpf_sock, protocol):
-	case offsetof(struct bpf_sock, dst_port):
 	case offsetof(struct bpf_sock, src_port):
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
 	case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
@@ -6727,6 +6727,14 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
 		bpf_ctx_record_field_size(info, size_default);
 		return bpf_ctx_narrow_access_ok(off, size, size_default);
+	case bpf_ctx_range(struct bpf_sock, dst_port):
+		field_size = size == size_default ?
+			size_default : sizeof_field(struct bpf_sock, dst_port);
+		bpf_ctx_record_field_size(info, field_size);
+		return bpf_ctx_narrow_access_ok(off, size, field_size);
+	case offsetofend(struct bpf_sock, dst_port) ...
+	     offsetof(struct bpf_sock, dst_ip4) - 1:
+		return false;
 	}
 
 	return size == size_default;
-- 
2.35.1



