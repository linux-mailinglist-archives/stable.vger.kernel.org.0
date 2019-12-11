Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C563C11AEE4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbfLKPJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:09:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbfLKPJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:09:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF92020663;
        Wed, 11 Dec 2019 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076945;
        bh=q3+oq0gWtFQMHwt+DBTLKJgXUEWmzfD4e1SdBz1EtXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XthJ9HhbJR9x0INTHu8Q5KSs7l/nnP2jnEPofPXupss0gBG2gl57dLgxTVnAbGo/f
         62XAP/g59fyOmR8rlaZx3B2sAQMibZYRfBLVI3DJF68PnxCeFxYyKTt/xF1ieH/eYo
         6udQFsQ0UdjrMLSrcEUzk2zapJXwy3+fljTQ0a6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trond Myklebust <trondmy@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.4 51/92] nfsd: restore NFSv3 ACL support
Date:   Wed, 11 Dec 2019 16:05:42 +0100
Message-Id: <20191211150243.409641576@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
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
@@ -95,12 +95,11 @@ static const struct svc_version *nfsd_ac
 
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


