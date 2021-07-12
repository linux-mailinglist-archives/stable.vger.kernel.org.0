Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713193C49DD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhGLGrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237773AbhGLGqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F46E61106;
        Mon, 12 Jul 2021 06:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072130;
        bh=nxzkG0nXIdlQ78uoHkF5kUMRYfP3HKFYI5JuLxHK7DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAIB5P2Gn0LumLc/P5Grw8xfXpXRm6rND7YFodtwvgK1w/FX5MMni0B/QUSsPhlFf
         Sf9jV7LdAOIq1XFT/e3NoT+vV1X+xLMNVWIWzzAtWAu+0qw3Dur2xkK5WQIYta2LqG
         QYQ61Vnz99CrqvwEax3nSiDylKO65Ag/cDTLCSp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Hai <wanghai38@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/593] samples/bpf: Fix Segmentation fault for xdp_redirect command
Date:   Mon, 12 Jul 2021 08:08:46 +0200
Message-Id: <20210712060926.864683033@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 85102ba58b4125ebad941d7555c3c248b23efd16 ]

A Segmentation fault error is caused when the following command
is executed.

$ sudo ./samples/bpf/xdp_redirect lo
Segmentation fault

This command is missing a device <IFNAME|IFINDEX> as an argument, resulting
in out-of-bounds access from argv.

If the number of devices for the xdp_redirect parameter is not 2,
we should report an error and exit.

Fixes: 24251c264798 ("samples/bpf: add option for native and skb mode for redirect apps")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210616042324.314832-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_redirect_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 9ca2bf457cda..1ddac4bcf447 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -131,7 +131,7 @@ int main(int argc, char **argv)
 	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
 		xdp_flags |= XDP_FLAGS_DRV_MODE;
 
-	if (optind == argc) {
+	if (optind + 2 != argc) {
 		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
 		return 1;
 	}
-- 
2.30.2



