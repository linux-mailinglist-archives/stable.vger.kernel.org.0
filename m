Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7097D48918A
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbiAJHdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:33:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40088 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240501AbiAJHbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:31:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68B6160B29;
        Mon, 10 Jan 2022 07:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505AAC36AE9;
        Mon, 10 Jan 2022 07:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799864;
        bh=l7CVo2z3VIAukLP5OI+M20kymgqAuMyHZpmtDAElU0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITR7U1HdFl+gtQhKd8055obIh1qWM3q7wa9asiV/8yfBXZDKSPrTnWjyXue8Wchr2
         YooMILUMqCoD6sw1JsPYFwyGhVpeb7NM6FcXX7L/X/li5nyvcrJPGAjjz4xluc2ZYg
         T/WxgwDKQ5u0EhplIbxSV9OyDKQANgc3objob9XE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tamir Duberstein <tamird@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/43] ipv6: raw: check passed optlen before reading
Date:   Mon, 10 Jan 2022 08:23:38 +0100
Message-Id: <20220110071818.731814848@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tamir Duberstein <tamird@gmail.com>

[ Upstream commit fb7bc9204095090731430c8921f9e629740c110a ]

Add a check that the user-provided option is at least as long as the
number of bytes we intend to read. Before this patch we would blindly
read sizeof(int) bytes even in cases where the user passed
optlen<sizeof(int), which would potentially read garbage or fault.

Discovered by new tests in https://github.com/google/gvisor/pull/6957 .

The original get_user call predates history in the git repo.

Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20211229200947.2862255-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 00f133a55ef7c..38349054e361e 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1020,6 +1020,9 @@ static int do_rawv6_setsockopt(struct sock *sk, int level, int optname,
 	struct raw6_sock *rp = raw6_sk(sk);
 	int val;
 
+	if (optlen < sizeof(val))
+		return -EINVAL;
+
 	if (copy_from_sockptr(&val, optval, sizeof(val)))
 		return -EFAULT;
 
-- 
2.34.1



