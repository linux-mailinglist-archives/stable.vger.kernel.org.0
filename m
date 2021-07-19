Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD89D3CDD39
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhGSO4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238336AbhGSOzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0BF76113E;
        Mon, 19 Jul 2021 15:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708819;
        bh=VwLXwcOZHY5TSgEG2YLEFNK0dAXRNNatYD3OhKVHiWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzQZnO4Y3/tpbagBkOVO9F1n66TFv35OMwHJeUAv4fX7Xi8GGJdfCvjKjwisirq9q
         8iZQ34t99zKw0rQ5RVhU4pl3KF4Gp6MBCu2dpe6W2J2b6uHbDXbAcTxVKkuREcrzzf
         hWeggRS9rCPkAo5OxwcVpjVYIANTbWPCOA9eoE1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Hai <wanghai38@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/421] samples/bpf: Fix the error return code of xdp_redirects main()
Date:   Mon, 19 Jul 2021 16:49:12 +0200
Message-Id: <20210719144951.386481328@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 81a69e36cb78..0f96a26b6ec5 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -146,5 +146,5 @@ int main(int argc, char **argv)
 	poll_stats(2, ifindex_out);
 
 out:
-	return 0;
+	return ret;
 }
-- 
2.30.2



