Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048822FA958
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390643AbhARSxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390639AbhARLkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FBE522CA2;
        Mon, 18 Jan 2021 11:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970005;
        bh=ILAKg+fYe8vgfcnQcGXsYQ1twmiCWwl5d15XdomXPlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sy22orb+H6as0RFKHFHIy6jJC52CTq9nGDNcBeYoJ+3P7yOdIZWm1q/kJLnv232My
         DHEUkEUnKDxT3VpdMN1oEH+AYVAZboG/GF3S0/OHFG5KA6t1gLXpfsS7vyQH+OY3TX
         jYSZ25jJZ0aHYa33mZG6yxpPEUpwwqd3g8k6X+sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoel Caspersen <yoel@kviknet.dk>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 74/76] netfilter: conntrack: fix reading nf_conntrack_buckets
Date:   Mon, 18 Jan 2021 12:35:14 +0100
Message-Id: <20210118113344.507276562@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

commit f6351c3f1c27c80535d76cac2299aec44c36291e upstream.

The old way of changing the conntrack hashsize runtime was through changing
the module param via file /sys/module/nf_conntrack/parameters/hashsize. This
was extended to sysctl change in commit 3183ab8997a4 ("netfilter: conntrack:
allow increasing bucket size via sysctl too").

The commit introduced second "user" variable nf_conntrack_htable_size_user
which shadow actual variable nf_conntrack_htable_size. When hashsize is
changed via module param this "user" variable isn't updated. This results in
sysctl net/netfilter/nf_conntrack_buckets shows the wrong value when users
update via the old way.

This patch fix the issue by always updating "user" variable when reading the
proc file. This will take care of changes to the actual variable without
sysctl need to be aware.

Fixes: 3183ab8997a4 ("netfilter: conntrack: allow increasing bucket size via sysctl too")
Reported-by: Yoel Caspersen <yoel@kviknet.dk>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_standalone.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -521,6 +521,9 @@ nf_conntrack_hash_sysctl(struct ctl_tabl
 {
 	int ret;
 
+	/* module_param hashsize could have changed value */
+	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;


