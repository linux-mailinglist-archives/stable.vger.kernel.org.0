Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0862F66C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfE3DKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbfE3DKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:10 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73DDB24485;
        Thu, 30 May 2019 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185810;
        bh=pkrYt45KKdk5c84Ve5J+EfLCCGC9mP22vg+IvgPQH2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfJerBaVmR8mXu5ZpfIJblEIlGBWknyrBpveIq9oi3Oa6KFZRGaxk/1fUJdeJMG41
         g2qtL++iDDboLhrHcC4JDPTH7rgsvr5cwZv8ocnGYix87L/b78RVpd1sxf4os0QC1r
         dSAYj2U1sCAZQBq2upHsOmZqq9YHAsKO0MoIiig8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH 5.1 043/405] netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression
Date:   Wed, 29 May 2019 20:00:41 -0700
Message-Id: <20190530030542.968623617@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

commit f8e608982022fad035160870f5b06086d3cba54d upstream.

Commit 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter
on flush") introduced a user-space regression when flushing connection
track entries. Before this commit, the nfgen_family field was not used
by the kernel and all entries were removed. Since this commit,
nfgen_family is used to filter out entries that should not be removed.
One example a broken tool is conntrack. conntrack always sets
nfgen_family to AF_INET, so after 59c08c69c278 only IPv4 entries were
removed with the -F parameter.

Pablo Neira Ayuso suggested using nfgenmsg->version to resolve the
regression, and this commit implements his suggestion. nfgenmsg->version
is so far set to zero, so it is well-suited to be used as a flag for
selecting old or new flush behavior. If version is 0, nfgen_family is
ignored and all entries are used. If user-space sets the version to one
(or any other value than 0), then the new behavior is used. As version
only can have two valid values, I chose not to add a new
NFNETLINK_VERSION-constant.

Fixes: 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter on flush")
Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1254,7 +1254,7 @@ static int ctnetlink_del_conntrack(struc
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
+	u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
 	struct nf_conntrack_zone zone;
 	int err;
 


