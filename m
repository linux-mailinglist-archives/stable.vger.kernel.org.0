Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A854891BE
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbiAJHgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240769AbiAJHca (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87C2C029834;
        Sun,  9 Jan 2022 23:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AD6F611BC;
        Mon, 10 Jan 2022 07:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BA9C36AED;
        Mon, 10 Jan 2022 07:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799737;
        bh=ODd+ifXtdV+GQOH+5z2G3OxUzcUuORCnGgD5ZCmaYb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qo1s8H2dxVgEA/w6XgEsZo7zefL85YkSLtGMk5PsUWCRm0fuFYCEQHRWrudg9N7Qd
         KFTQPJVT2n7SJY5sOq4YpZzpL9OfshJ63gOB2UAU3/cNX/hxmz0Sx8H/HtTbJA0GSZ
         JGYf8gRvfMpov6jxW7ZOqFVEXsMdYAcpUpa1pJ7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangxingwu <xingwu.yang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/34] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon, 10 Jan 2022 08:23:27 +0100
Message-Id: <20220110071816.764736903@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangxingwu <xingwu.yang@gmail.com>

[ Upstream commit 6c25449e1a32c594d743df8e8258e8ef870b6a77 ]

$ cat /pro/net/udp

before:

  sl  local_address rem_address   st tx_queue rx_queue tr tm->when
26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000

after:

   sl  local_address rem_address   st tx_queue rx_queue tr tm->when
26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a0016f05c4f86..3cdf011a8dd8d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2943,7 +2943,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
 {
 	seq_setwidth(seq, 127);
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "  sl  local_address rem_address   st tx_queue "
+		seq_puts(seq, "   sl  local_address rem_address   st tx_queue "
 			   "rx_queue tr tm->when retrnsmt   uid  timeout "
 			   "inode ref pointer drops");
 	else {
-- 
2.34.1



