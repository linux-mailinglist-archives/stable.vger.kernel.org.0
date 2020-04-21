Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6E11B2DE1
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgDUROB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:14:01 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52143 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgDURN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:13:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B06DE1941D1B;
        Tue, 21 Apr 2020 13:08:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B2WTjT
        lfHGRbC6tpsKRFdij99yzQzXz+TpMNeCkup3o=; b=nsXI+qOn2AGFFyx6w3SjL4
        juZYl9tq0ZuegIe1EQByMmnGG9m5q1+owX5LAoftLVLZRBHYPJOOudPhW1sJcB5P
        GPCjYH+8Km+w0ZKtrwilh1Om8oXeclt7QUg3h0VISUdhjlfoMH4CBkNEr5gy9DPJ
        j/ORNLO70ChTrO3D2ZFRGPzL/b4gSVePCR7C9mrPiz2sNuWH1QgTUj2MsZC5dpLu
        cVbod0FNKE4Hy1yVr/gVZNMT2jFynw7xeop+6lUaE3AWYZlOb3amUN34OhjjRrm+
        nslNq5HOi2IuNX1tzOAdA17UKGJzsXNSScBOYd02Sho+6Kb1Bjyh0f8NgNhFBpjw
        ==
X-ME-Sender: <xms:kiifXmTT1j2s33qxDtcfmfSBsAY1z9Ext8bJor3BObAWBR8FQ21HtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kiifXvM3dSMU2FvuX1gpCk-i_RT2tSsYUuwBIbIAz9RkQubueWSdeQ>
    <xmx:kiifXgEBBFVn-OiXSlMcmYih2AZ2Hvm-ao7vGKh0xeQ38bdQ3JeItA>
    <xmx:kiifXrAC1XvDssLyDqO8iUMZ4dG2SAbHVXiiyiZ0cGFhUAUf9N2qqg>
    <xmx:kyifXjJu6g20ZrRrFtkbcWHWIv-oe-7Hzk7TQUJ3wuPgVT9oBI6_7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6AE5C328006E;
        Tue, 21 Apr 2020 13:08:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xsk: Add missing check on user supplied headroom size" failed to apply to 4.19-stable tree
To:     magnus.karlsson@intel.com, daniel@iogearbox.net,
        minhquangbui99@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:08:33 +0200
Message-ID: <158748891372198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 99e3a236dd43d06c65af0a2ef9cb44306aef6e02 Mon Sep 17 00:00:00 2001
From: Magnus Karlsson <magnus.karlsson@intel.com>
Date: Tue, 14 Apr 2020 09:35:15 +0200
Subject: [PATCH] xsk: Add missing check on user supplied headroom size

Add a check that the headroom cannot be larger than the available
space in the chunk. In the current code, a malicious user can set the
headroom to a value larger than the chunk size minus the fixed XDP
headroom. That way packets with a length larger than the supported
size in the umem could get accepted and result in an out-of-bounds
write.

Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
Reported-by: Bui Quang Minh <minhquangbui99@gmail.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=207225
Link: https://lore.kernel.org/bpf/1586849715-23490-1-git-send-email-magnus.karlsson@intel.com

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index fa7bb5e060d0..ed7a6060f73c 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -343,7 +343,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
 	unsigned int chunks, chunks_per_page;
 	u64 addr = mr->addr, size = mr->len;
-	int size_chk, err;
+	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
 		/* Strictly speaking we could support this, if:
@@ -382,8 +382,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 			return -EINVAL;
 	}
 
-	size_chk = chunk_size - headroom - XDP_PACKET_HEADROOM;
-	if (size_chk < 0)
+	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
 		return -EINVAL;
 
 	umem->address = (unsigned long)addr;

