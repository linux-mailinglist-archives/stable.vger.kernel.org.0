Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456F04F255F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiDEHtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiDEHq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:46:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E0A99ED0;
        Tue,  5 Apr 2022 00:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D457B81B75;
        Tue,  5 Apr 2022 07:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E086CC340EE;
        Tue,  5 Apr 2022 07:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144518;
        bh=EuNKLs0j/ektBoCOSqte+2f5ggiogIwjGgtIIGQzbsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMDrjrzNjwgF6kRRs7v24Qh3kBNt/Y4JcHjodASpt9+t2R2rAPuavHY+vMN2WpG2g
         aEfxGIes3tbb6zC/HZpRhbRNqrPMhiak+v4ZUVjQAVSC61Iekxtm0yH8qn/iqU+tLH
         e40ulPYVocLbqjeWsvWazccY8s5JZW4ougoGFIdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.17 0056/1126] NFS: NFSv2/v3 clients should never be setting NFS_CAP_XATTR
Date:   Tue,  5 Apr 2022 09:13:23 +0200
Message-Id: <20220405070409.211585519@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit b622ffe1d9ecbac71f0cddb52ff0831efdf8fb83 upstream.

Ensure that we always initialise the 'xattr_support' field in struct
nfs_fsinfo, so that nfs_server_set_fsinfo() doesn't declare our NFSv2/v3
client to be capable of supporting the NFSv4.2 xattr protocol by setting
the NFS_CAP_XATTR capability.

This configuration can cause nfs_do_access() to set access mode bits
that are unsupported by the NFSv3 ACCESS call, which may confuse
spec-compliant servers.

Reported-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: b78ef845c35d ("NFSv4.2: query the server for extended attribute support")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs3xdr.c |    1 +
 fs/nfs/proc.c    |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -2228,6 +2228,7 @@ static int decode_fsinfo3resok(struct xd
 	/* ignore properties */
 	result->lease_time = 0;
 	result->change_attr_type = NFS4_CHANGE_TYPE_IS_UNDEFINED;
+	result->xattr_support = 0;
 	return 0;
 }
 
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -92,6 +92,7 @@ nfs_proc_get_root(struct nfs_server *ser
 	info->maxfilesize = 0x7FFFFFFF;
 	info->lease_time = 0;
 	info->change_attr_type = NFS4_CHANGE_TYPE_IS_UNDEFINED;
+	info->xattr_support = 0;
 	return 0;
 }
 


