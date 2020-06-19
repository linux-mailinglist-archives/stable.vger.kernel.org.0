Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724D3201499
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394359AbgFSQNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391075AbgFSPEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:04:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E4522193E;
        Fri, 19 Jun 2020 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579055;
        bh=hvxXd98s1xuuB7y/wMyWIq6EcmcDp8SLLGhH+YGV4hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m47M3W2BgY25YGsgIqMJmLWB1WXiIaXsx+c8NiLTpoaMW2ym1SJBVVDmu+PctrCQ/
         ZvUoYsG2RNPhYi+zYqLtSlmhbmlQmHKOTdV0XodBWpKNHKLzmbApFjulKkt12zZxxm
         3rhHXwf01+YcndqF6Fo5FrAsc8fqjFfVX2e+IiXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.19 259/267] sunrpc: svcauth_gss_register_pseudoflavor must reject duplicate registrations.
Date:   Fri, 19 Jun 2020 16:34:04 +0200
Message-Id: <20200619141701.090982953@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit d47a5dc2888fd1b94adf1553068b8dad76cec96c upstream.

There is no valid case for supporting duplicate pseudoflavor
registrations.
Currently the silent acceptance of such registrations is hiding a bug.
The rpcsec_gss_krb5 module registers 2 flavours but does not unregister
them, so if you load, unload, reload the module, it will happily
continue to use the old registration which now has pointers to the
memory were the module was originally loaded.  This could lead to
unexpected results.

So disallow duplicate registrations.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206651
Cc: stable@vger.kernel.org (v2.6.12+)
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/svcauth_gss.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -796,9 +796,11 @@ svcauth_gss_register_pseudoflavor(u32 ps
 	new->h.flavour = &svcauthops_gss;
 	new->pseudoflavor = pseudoflavor;
 
-	stat = 0;
 	test = auth_domain_lookup(name, &new->h);
-	if (test != &new->h) { /* Duplicate registration */
+	if (test != &new->h) {
+		pr_warn("svc: duplicate registration of gss pseudo flavour %s.\n",
+			name);
+		stat = -EADDRINUSE;
 		auth_domain_put(test);
 		kfree(new->h.name);
 		goto out_free_dom;


