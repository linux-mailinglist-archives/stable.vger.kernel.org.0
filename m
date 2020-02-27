Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827E1171B6D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbgB0OCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733078AbgB0OCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F3C20801;
        Thu, 27 Feb 2020 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812136;
        bh=W4/xiG4eiTXSVrIJ6XH12CjYjNUG6YQO84OF6694ykI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwiJHYlRi0NRFgKlGun5xX4Fgw3a09Uvm//3Qd4egMwPuMkgvtPtUGxQGCm/26x0K
         AYYLE5obbBoceShBXthiY89C75jDYTjeqI/9efqBSBpMqLW+FnHQ/PeryqF6GcPMGY
         kbgcyLu3tKo3p7j/tEYIxWVGS2iquwflz3PXFI80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Subject: [PATCH 4.14 234/237] netfilter: xt_hashlimit: limit the max size of hashtable
Date:   Thu, 27 Feb 2020 14:37:28 +0100
Message-Id: <20200227132313.292102759@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 8d0015a7ab76b8b1e89a3e5f5710a6e5103f2dd5 upstream.

The user-specified hashtable size is unbound, this could
easily lead to an OOM or a hung task as we hold the global
mutex while allocating and initializing the new hashtable.

Add a max value to cap both cfg->size and cfg->max, as
suggested by Florian.

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_hashlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -845,6 +845,8 @@ hashlimit_mt(const struct sk_buff *skb,
 	return hashlimit_mt_common(skb, par, hinfo, &info->cfg, 3);
 }
 
+#define HASHLIMIT_MAX_SIZE 1048576
+
 static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 				     struct xt_hashlimit_htable **hinfo,
 				     struct hashlimit_cfg3 *cfg,
@@ -855,6 +857,14 @@ static int hashlimit_mt_check_common(con
 
 	if (cfg->gc_interval == 0 || cfg->expire == 0)
 		return -EINVAL;
+	if (cfg->size > HASHLIMIT_MAX_SIZE) {
+		cfg->size = HASHLIMIT_MAX_SIZE;
+		pr_info_ratelimited("size too large, truncated to %u\n", cfg->size);
+	}
+	if (cfg->max > HASHLIMIT_MAX_SIZE) {
+		cfg->max = HASHLIMIT_MAX_SIZE;
+		pr_info_ratelimited("max too large, truncated to %u\n", cfg->max);
+	}
 	if (par->family == NFPROTO_IPV4) {
 		if (cfg->srcmask > 32 || cfg->dstmask > 32)
 			return -EINVAL;


