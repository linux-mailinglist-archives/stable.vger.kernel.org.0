Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF2C635800
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbiKWJtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238183AbiKWJsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:48:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22DA11A723
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:45:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38581B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822F5C433C1;
        Wed, 23 Nov 2022 09:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196757;
        bh=se60LEJkkfXjXNhrN11Bpzm4NVE0l47j0CDRLhFlDAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odqeuf6gRgsVj/a9RLZcp5aDyKKVmpRhjbaYhC/SEBdrJ7oQ/FcUaHu07RBN2VSux
         1oxBSgHa2sJ3Qy13DaO/pISMiqHViFZHCxl9KBrNq90/V+hwZvICBS4ysWCcwI6AEZ
         FkyeGoYnjM2ZjlAENhHvnFITtkDeCfeBb+dzbIIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yongcheng Yang <yoyang@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 116/314] nfsd: put the export reference in nfsd4_verify_deleg_dentry
Date:   Wed, 23 Nov 2022 09:49:21 +0100
Message-Id: <20221123084630.763931571@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 50256e4793a5e5ab77703c82a47344ad2e774a59 ]

nfsd_lookup_dentry returns an export reference in addition to the dentry
ref. Ensure that we put it too.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2138866
Fixes: 876c553cb410 ("NFSD: verify the opened dentry after setting a delegation")
Reported-by: Yongcheng Yang <yoyang@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 0bc36472f8b7..ddb2bf078fda 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5313,6 +5313,7 @@ nfsd4_verify_deleg_dentry(struct nfsd4_open *open, struct nfs4_file *fp,
 	if (err)
 		return -EAGAIN;
 
+	exp_put(exp);
 	dput(child);
 	if (child != file_dentry(fp->fi_deleg_file->nf_file))
 		return -EAGAIN;
-- 
2.35.1



