Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5D06DEDF0
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjDLIib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjDLIiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56C17A9F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD07462FB7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C9DC433D2;
        Wed, 12 Apr 2023 08:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288527;
        bh=4kaf7GLPDlglGCv04Df4RlzZ0dJngCbekqMf67l9O98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKML+NPfWk9fY3dfa9Z8pV4r2TH1664apSHze5hFJL9zLWwUe35/EomYNURcAm3nc
         T6f016vDiv/VYNja7DRmpyEoM+5d5iJJ7EgF7hqbx/yOOF5Qqou4XeesuUZAi7DiH5
         9Z5hqZmI7e6tMju3NjT3RZ7Q0v7ZxhK+J/wqTUFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/93] NFSD: pass range end to vfs_fsync_range() instead of count
Date:   Wed, 12 Apr 2023 10:33:13 +0200
Message-Id: <20230412082823.554775130@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 79a1d88a36f77374c77fd41a4386d8c2736b8704 ]

_nfsd_copy_file_range() calls vfs_fsync_range() with an offset and
count (bytes written), but the former wants the start and end bytes
of the range to sync. Fix it up.

Fixes: eac0b17a77fb ("NFSD add vfs_fsync after async copy is done")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Tested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c91da7bce17ea..3eb500adcda2e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1514,6 +1514,7 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
 	int status;
+	loff_t end;
 
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
@@ -1533,8 +1534,8 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (!copy->cp_synchronous && copy->cp_res.wr_bytes_written > 0) {
 		since = READ_ONCE(dst->f_wb_err);
-		status = vfs_fsync_range(dst, copy->cp_dst_pos,
-					 copy->cp_res.wr_bytes_written, 0);
+		end = copy->cp_dst_pos + copy->cp_res.wr_bytes_written - 1;
+		status = vfs_fsync_range(dst, copy->cp_dst_pos, end, 0);
 		if (!status)
 			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
-- 
2.39.2



