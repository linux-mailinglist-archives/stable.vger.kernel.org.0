Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C6240E81D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353987AbhIPRh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344581AbhIPRfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CE186124B;
        Thu, 16 Sep 2021 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810933;
        bh=qEiAm24eqpsL2TxBMKk2BMy+kt0VnPszMUVXtFF6ej0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VR7vtP9OnZI2V93NozKNJmk/DoHGz941DeEcFaQ5F6d4iQb66eEy3z0h4VGyhrmeO
         mGn2uZtg8m3NGpcloubR9qA/FO/Wm2NwcuBA4glh3DH7LF6fiJ7DmZ6pdrbHTrLJX1
         dPZdqRgbnFsYbwlDe5Bab1seLLC5Kzizk/VQYBgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 321/432] selftests: nci: Fix the wrong condition
Date:   Thu, 16 Sep 2021 18:01:10 +0200
Message-Id: <20210916155821.715046682@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

[ Upstream commit 1d5b8d01db98abb8c176838fad73287366874582 ]

memcpy should be executed only in case nla_len's value is greater than 0.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 9687100f15ea..acd4125ff39f 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -110,7 +110,7 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 		na->nla_type = nla_type[cnt];
 		na->nla_len = nla_len[cnt] + NLA_HDRLEN;
 
-		if (nla_len > 0)
+		if (nla_len[cnt] > 0)
 			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
 
 		prv_len = NLA_ALIGN(nla_len[cnt]) + NLA_HDRLEN;
-- 
2.30.2



