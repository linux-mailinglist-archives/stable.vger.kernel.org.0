Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226BD2010B9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393939AbgFSPc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393935AbgFSPcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:32:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7195A20786;
        Fri, 19 Jun 2020 15:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580774;
        bh=Fn4AYlScuXenMTHycSwMZpCUV9EpZ+LnQQ2sQstNaZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0qpPwBEjus5Z3ZSRTj1YgVxoqp+4z3lakkTwx9z6O9hUawXhMFrOa9uDOPCISIaJ
         K42om7qyIC+XoYz/giHOiRFXvkTlE0wWNyyIECWSWi5aAdfBohTudTlJD/Q2Pr0ACI
         cE8qdAa7ZZtFC/XPy3hordPFaeOrUuoxrEK/vEqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.7 347/376] sunrpc: clean up properly in gss_mech_unregister()
Date:   Fri, 19 Jun 2020 16:34:25 +0200
Message-Id: <20200619141726.753322804@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit 24c5efe41c29ee3e55bcf5a1c9f61ca8709622e8 upstream.

gss_mech_register() calls svcauth_gss_register_pseudoflavor() for each
flavour, but gss_mech_unregister() does not call auth_domain_put().
This is unbalanced and makes it impossible to reload the module.

Change svcauth_gss_register_pseudoflavor() to return the registered
auth_domain, and save it for later release.

Cc: stable@vger.kernel.org (v2.6.12+)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206651
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sunrpc/gss_api.h        |    1 +
 include/linux/sunrpc/svcauth_gss.h    |    3 ++-
 net/sunrpc/auth_gss/gss_mech_switch.c |   12 +++++++++---
 net/sunrpc/auth_gss/svcauth_gss.c     |   12 ++++++------
 4 files changed, 18 insertions(+), 10 deletions(-)

--- a/include/linux/sunrpc/gss_api.h
+++ b/include/linux/sunrpc/gss_api.h
@@ -84,6 +84,7 @@ struct pf_desc {
 	u32	service;
 	char	*name;
 	char	*auth_domain_name;
+	struct auth_domain *domain;
 	bool	datatouch;
 };
 
--- a/include/linux/sunrpc/svcauth_gss.h
+++ b/include/linux/sunrpc/svcauth_gss.h
@@ -20,7 +20,8 @@ int gss_svc_init(void);
 void gss_svc_shutdown(void);
 int gss_svc_init_net(struct net *net);
 void gss_svc_shutdown_net(struct net *net);
-int svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name);
+struct auth_domain *svcauth_gss_register_pseudoflavor(u32 pseudoflavor,
+						      char *name);
 u32 svcauth_gss_flavor(struct auth_domain *dom);
 
 #endif /* _LINUX_SUNRPC_SVCAUTH_GSS_H */
--- a/net/sunrpc/auth_gss/gss_mech_switch.c
+++ b/net/sunrpc/auth_gss/gss_mech_switch.c
@@ -37,6 +37,8 @@ gss_mech_free(struct gss_api_mech *gm)
 
 	for (i = 0; i < gm->gm_pf_num; i++) {
 		pf = &gm->gm_pfs[i];
+		if (pf->domain)
+			auth_domain_put(pf->domain);
 		kfree(pf->auth_domain_name);
 		pf->auth_domain_name = NULL;
 	}
@@ -59,6 +61,7 @@ make_auth_domain_name(char *name)
 static int
 gss_mech_svc_setup(struct gss_api_mech *gm)
 {
+	struct auth_domain *dom;
 	struct pf_desc *pf;
 	int i, status;
 
@@ -68,10 +71,13 @@ gss_mech_svc_setup(struct gss_api_mech *
 		status = -ENOMEM;
 		if (pf->auth_domain_name == NULL)
 			goto out;
-		status = svcauth_gss_register_pseudoflavor(pf->pseudoflavor,
-							pf->auth_domain_name);
-		if (status)
+		dom = svcauth_gss_register_pseudoflavor(
+			pf->pseudoflavor, pf->auth_domain_name);
+		if (IS_ERR(dom)) {
+			status = PTR_ERR(dom);
 			goto out;
+		}
+		pf->domain = dom;
 	}
 	return 0;
 out:
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -809,7 +809,7 @@ u32 svcauth_gss_flavor(struct auth_domai
 
 EXPORT_SYMBOL_GPL(svcauth_gss_flavor);
 
-int
+struct auth_domain *
 svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name)
 {
 	struct gss_domain	*new;
@@ -832,17 +832,17 @@ svcauth_gss_register_pseudoflavor(u32 ps
 			name);
 		stat = -EADDRINUSE;
 		auth_domain_put(test);
-		kfree(new->h.name);
-		goto out_free_dom;
+		goto out_free_name;
 	}
-	return 0;
+	return test;
 
+out_free_name:
+	kfree(new->h.name);
 out_free_dom:
 	kfree(new);
 out:
-	return stat;
+	return ERR_PTR(stat);
 }
-
 EXPORT_SYMBOL_GPL(svcauth_gss_register_pseudoflavor);
 
 static inline int


