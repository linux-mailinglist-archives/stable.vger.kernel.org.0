Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6671030CE1
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 12:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfEaKxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 06:53:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfEaKxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 06:53:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1F33B3087945;
        Fri, 31 May 2019 10:53:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-173.rdu2.redhat.com [10.10.120.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F8757C577;
        Fri, 31 May 2019 10:53:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] Smack: Restore the smackfsdef mount option and add missing
 prefixes
From:   David Howells <dhowells@redhat.com>
To:     viro@zeniv.linux.org.uk
Cc:     stable@vger.kernel.org, Jose Bollo <jose.bollo@iot.bzh>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Casey Schaufler <casey@schaufler-ca.com>, jmorris@namei.org,
        dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 31 May 2019 11:53:33 +0100
Message-ID: <155930001303.17253.2447519598157285098.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 31 May 2019 10:53:43 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

The 5.1 mount system rework changed the smackfsdef mount option
to smackfsdefault. This fixes the regression by making smackfsdef
treated the same way as smackfsdefault.

Also fix the smack_param_specs[] to have "smack" prefixes on all the names.
This isn't visible to a user unless they either:

 (a) Try to mount a filesystem that's converted to the internal mount API
     and that implements the ->parse_monolithic() context operation - and
     only then if they call security_fs_context_parse_param() rather than
     security_sb_eat_lsm_opts().

     There are no examples of this upstream yet, but nfs will probably want
     to do this for nfs2 or nfs3.

 (b) Use fsconfig() to configure the filesystem - in which case
     security_fs_context_parse_param() will be called.

This issue is that smack_sb_eat_lsm_opts() checks for the "smack" prefix on
the options, but smack_fs_context_parse_param() does not.

Fixes: c3300aaf95fb ("smack: get rid of match_token()")
Fixes: 2febd254adc4 ("smack: Implement filesystem context security hooks")
Cc: stable@vger.kernel.org
Reported-by: Jose Bollo <jose.bollo@iot.bzh>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Casey Schaufler <casey@schaufler-ca.com>
---

 security/smack/smack_lsm.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0de725f88bed..d99450b4f511 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -68,6 +68,7 @@ static struct {
 	int len;
 	int opt;
 } smk_mount_opts[] = {
+	{"smackfsdef", sizeof("smackfsdef") - 1, Opt_fsdefault},
 	A(fsdefault), A(fsfloor), A(fshat), A(fsroot), A(fstransmute)
 };
 #undef A
@@ -682,11 +683,12 @@ static int smack_fs_context_dup(struct fs_context *fc,
 }
 
 static const struct fs_parameter_spec smack_param_specs[] = {
-	fsparam_string("fsdefault",	Opt_fsdefault),
-	fsparam_string("fsfloor",	Opt_fsfloor),
-	fsparam_string("fshat",		Opt_fshat),
-	fsparam_string("fsroot",	Opt_fsroot),
-	fsparam_string("fstransmute",	Opt_fstransmute),
+	fsparam_string("smackfsdef",		Opt_fsdefault),
+	fsparam_string("smackfsdefault",	Opt_fsdefault),
+	fsparam_string("smackfsfloor",		Opt_fsfloor),
+	fsparam_string("smackfshat",		Opt_fshat),
+	fsparam_string("smackfsroot",		Opt_fsroot),
+	fsparam_string("smackfstransmute",	Opt_fstransmute),
 	{}
 };
 

