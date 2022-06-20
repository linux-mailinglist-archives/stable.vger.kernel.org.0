Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B504551DF2
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiFTOAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353108AbiFTN5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:57:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCABE37BDF;
        Mon, 20 Jun 2022 06:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C28E8B811C5;
        Mon, 20 Jun 2022 13:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B261C3411B;
        Mon, 20 Jun 2022 13:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731399;
        bh=zi8LIw71MVWWrxvUhj1qeeF/h2lGRvnWqr2n/6EpY8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR2El3RSNQO6YWNtxouOgOlEDVnERLYhOdmIDV2vh7/u6VzAJfMIhLS86jIqLWKMZ
         w6rRrBg3x9VUzlv9Yyy5rsEIuQYqUzdWVYtwJH5yUbfd9ilaP8BwRvtEUTUzNriOp4
         nSqUZ1Wh83qQYZ8jIR7AmiQlqN9O4LBTiSIpfvMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/240] pNFS: Dont keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE
Date:   Mon, 20 Jun 2022 14:51:46 +0200
Message-Id: <20220620124744.922460382@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit fe44fb23d6ccde4c914c44ef74ab8d9d9ba02bea ]

If the server tells us that a pNFS layout is not available for a
specific file, then we should not keep pounding it with further
layoutget requests.

Fixes: 183d9e7b112a ("pnfs: rework LAYOUTGET retry handling")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 2fe48982fbb4..3b19fa74b062 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2111,6 +2111,12 @@ pnfs_update_layout(struct inode *ino,
 		case -ERECALLCONFLICT:
 		case -EAGAIN:
 			break;
+		case -ENODATA:
+			/* The server returned NFS4ERR_LAYOUTUNAVAILABLE */
+			pnfs_layout_set_fail_bit(
+				lo, pnfs_iomode_to_fail_bit(iomode));
+			lseg = NULL;
+			goto out_put_layout_hdr;
 		default:
 			if (!nfs_error_is_fatal(PTR_ERR(lseg))) {
 				pnfs_layout_clear_fail_bit(lo, pnfs_iomode_to_fail_bit(iomode));
-- 
2.35.1



