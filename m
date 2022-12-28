Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA79E658394
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiL1Qs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiL1QsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:48:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FD71D329
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:43:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCBFBB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3DBC433D2;
        Wed, 28 Dec 2022 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245830;
        bh=jhGHPPiCg8PuuPbx27YsQpFMkeaCpoT/eez0u9GB/Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEVBdLXd2A+c/damo+LlzdqOXrbDz0Mu64+grs2VwspFZRqbYbAvOOPBC5CnzzFpH
         CgN9Nfjtm8WMyUHbqgNL8Bzw6RzadHHkc6VLpaGkETLUsbOEdJhaf45UGJwGucXrva
         1H/7HkakhykXU27oIFUJ78aRVGZ15kIi+1qvA2ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0932/1146] cifs: dont leak -ENOMEM in smb2_open_file()
Date:   Wed, 28 Dec 2022 15:41:11 +0100
Message-Id: <20221228144355.604194751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit f60ffa662d1427cfd31fe9d895c3566ac50bfe52 ]

A NULL error response might be a valid case where smb2_reconnect()
failed to reconnect the session and tcon due to a disconnected server
prior to issuing the I/O operation, so don't leak -ENOMEM to userspace
on such occasions.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index ffbd9a99fc12..ba6cc50af390 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -122,8 +122,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 		struct smb2_hdr *hdr = err_iov.iov_base;
 
 		if (unlikely(!err_iov.iov_base || err_buftype == CIFS_NO_BUFFER))
-			rc = -ENOMEM;
-		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
+			goto out;
+		if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 &data->symlink_target);
 			if (!rc) {
-- 
2.35.1



