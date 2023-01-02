Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE7E65B0D0
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjABL2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbjABL1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:27:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF415F43
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4C1DB80D13
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A52DC433EF;
        Mon,  2 Jan 2023 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658815;
        bh=N7YlV6o7/KdM+VBaOm62IjA4ZrxjSy/jjYeFF9rcRds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpFOkHhn/vBNg241R0e3Kv9PX7wLS+ghXpymwW+NNKVcyKBtmH9eIlwjqIrwb43WH
         7ztS1KKwWyoSHlMGPCLPuIA6hXbG9K6Tw0F70ZndfJEqzMrgPt2EWUaW6XCfOl+kne
         AULrJkLBrw638o1EphJifGHfSpyx2d2gz6mUeqE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 10/74] cifs: fix static checker warning
Date:   Mon,  2 Jan 2023 12:21:43 +0100
Message-Id: <20230102110552.477857252@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

[ Upstream commit a9e17d3d74d14e5fd10d54f0a07e0fce4e5f80dd ]

Remove unnecessary NULL check of oparam->cifs_sb when parsing symlink
error response as it's already set by all smb2_open_file() callers and
deferenced earlier.

This fixes below report:

  fs/cifs/smb2file.c:126 smb2_open_file()
  warn: variable dereferenced before check 'oparms->cifs_sb' (see line 112)

Link: https://lore.kernel.org/r/Y0kt42j2tdpYakRu@kili
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f60ffa662d14 ("cifs: don't leak -ENOMEM in smb2_open_file()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 4992b43616a7..ffbd9a99fc12 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -123,7 +123,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 
 		if (unlikely(!err_iov.iov_base || err_buftype == CIFS_NO_BUFFER))
 			rc = -ENOMEM;
-		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK && oparms->cifs_sb) {
+		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 &data->symlink_target);
 			if (!rc) {
-- 
2.35.1



