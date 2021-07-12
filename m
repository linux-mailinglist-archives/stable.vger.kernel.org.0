Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5593F3C49E0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbhGLGrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237803AbhGLGqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65F4361132;
        Mon, 12 Jul 2021 06:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072132;
        bh=aM9fctSywC3UyqGJN5kgRWCCedaYt2w15nc4ZTb8lJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5xIomcuf4/dgrbNxf2sxrEUOQpn0wgAAAuaYdkgpth4EupL7RN1n5Vs3v/YlBmml
         /3p1Bv9jLFr8C29QZWPO8kp1d6qfwVB2dhANEdjwrGQ7XCVEpY/We2orGDoywrNv5T
         o3v5QrC0gy5tNe5OUI7ubt8uP/STacM2rXSh8JJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Hai <wanghai38@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 367/593] samples/bpf: Fix the error return code of xdp_redirects main()
Date:   Mon, 12 Jul 2021 08:08:47 +0200
Message-Id: <20210712060927.007235532@linuxfoundation.org>
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

[ Upstream commit 7c6090ee2a7b3315410cfc83a94c3eb057407b25 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

If bpf_map_update_elem() failed, main() should return a negative error.

Fixes: 832622e6bd18 ("xdp: sample program for new bpf_redirect helper")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210616042534.315097-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_redirect_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 1ddac4bcf447..3c92adc2a7bd 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -219,5 +219,5 @@ int main(int argc, char **argv)
 	poll_stats(2, ifindex_out);
 
 out:
-	return 0;
+	return ret;
 }
-- 
2.30.2



