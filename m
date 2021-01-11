Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23EB2F1537
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731926AbhAKNNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbhAKNNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBB9A2253A;
        Mon, 11 Jan 2021 13:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370772;
        bh=38g0OaW0S0xlW9lL1byQD9zjXHWS9D4jvgtVRmqoqac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKKF31Wiyqfs/ZIkBEr6rx2kIj749V6S6sSk0oiW3PMLZRJ34wrt4cB7JYaH3kwCr
         k78fCo6dpo935+ytcDVKPOIRDXOCOw2AZF35dt5Dmpi2DjqIcbCPlutLSwAVKvy4Zf
         Stg71KOcPJzj8fTAntZV3iXwqU1JkESSpVhXFwnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 89/92] netfilter: xt_RATEEST: reject non-null terminated string from userspace
Date:   Mon, 11 Jan 2021 14:02:33 +0100
Message-Id: <20210111130043.447563580@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 6cb56218ad9e580e519dcd23bfb3db08d8692e5a upstream.

syzbot reports:
detected buffer overflow in strlen
[..]
Call Trace:
 strlen include/linux/string.h:325 [inline]
 strlcpy include/linux/string.h:348 [inline]
 xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143

strlcpy assumes src is a c-string. Check info->name before its used.

Reported-by: syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com
Fixes: 5859034d7eb8793 ("[NETFILTER]: x_tables: add RATEEST target")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_RATEEST.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -115,6 +115,9 @@ static int xt_rateest_tg_checkentry(cons
 	} cfg;
 	int ret;
 
+	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
+		return -ENAMETOOLONG;
+
 	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
 
 	mutex_lock(&xn->hash_lock);


