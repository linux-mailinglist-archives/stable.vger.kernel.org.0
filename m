Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB48E489203
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241026AbiAJHhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34520 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240986AbiAJHeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7407EB81208;
        Mon, 10 Jan 2022 07:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77FAC36AF2;
        Mon, 10 Jan 2022 07:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800069;
        bh=Y0J8XBrSx5+EYNohAi7G2j5UtwGyHqbFfjrqlSDfVyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WitVbdO8MSa8tH2lMMpl6L48QdIvg63KHAHyc6n+lOsegcOZgvzmJpWx3xkhBUUqu
         Zzp1xjOQSgIw4n4s9eOIKnqP0VTlLZDzTRUwyMQ5catBsuMYwNJF/k+v31OPrn76bw
         pwuqIncxJy8lf8bP+1xpwd1WY9/nGFPZyiqxrtpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tamir Duberstein <tamird@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 67/72] ipv6: raw: check passed optlen before reading
Date:   Mon, 10 Jan 2022 08:23:44 +0100
Message-Id: <20220110071823.836097125@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
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
index 60f1e4f5be5aa..c51d5ce3711c2 100644
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



