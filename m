Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE97711B637
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbfLKP7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:59:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731552AbfLKPOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7731D2467E;
        Wed, 11 Dec 2019 15:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077239;
        bh=Q5Dcr8A1aSAnDMxrhZ4ckRgixOVCPQ3v2ONjkEvR5QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whZOHmHJK8HUo4RaDj7juJ1XUBqUja2VG+jcPRXYYVPe5X18tNIOYYmbhMMTWoeLq
         wRCNjJbSMadtv3qtTt7jVDD8ZgJ46nDOGwG9h9Z19xeIFcMQ1sUWv0w2sWZqfObEi4
         T+fJaDJjRVKaOAXcElQiXvVItA07JDQQReBBApn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trond Myklebust <trondmy@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.3 069/105] nfsd: restore NFSv3 ACL support
Date:   Wed, 11 Dec 2019 16:05:58 +0100
Message-Id: <20191211150250.436375546@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 7c149057d044c52ed1e1d4ee50cf412c8d0f7295 upstream.

An error in e333f3bbefe3 left the nfsd_acl_program->pg_vers array empty,
which effectively turned off the server's support for NFSv3 ACLs.

Fixes: e333f3bbefe3 "nfsd: Allow containers to set supported nfs versions"
Cc: stable@vger.kernel.org
Cc: Trond Myklebust <trondmy@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfssvc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -94,12 +94,11 @@ static const struct svc_version *nfsd_ac
 
 #define NFSD_ACL_MINVERS            2
 #define NFSD_ACL_NRVERS		ARRAY_SIZE(nfsd_acl_version)
-static const struct svc_version *nfsd_acl_versions[NFSD_ACL_NRVERS];
 
 static struct svc_program	nfsd_acl_program = {
 	.pg_prog		= NFS_ACL_PROGRAM,
 	.pg_nvers		= NFSD_ACL_NRVERS,
-	.pg_vers		= nfsd_acl_versions,
+	.pg_vers		= nfsd_acl_version,
 	.pg_name		= "nfsacl",
 	.pg_class		= "nfsd",
 	.pg_stats		= &nfsd_acl_svcstats,


