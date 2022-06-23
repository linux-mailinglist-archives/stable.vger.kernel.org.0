Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B10C558232
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiFWRLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiFWRKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C320356380;
        Thu, 23 Jun 2022 09:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B63C261407;
        Thu, 23 Jun 2022 16:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8EBC3411B;
        Thu, 23 Jun 2022 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003437;
        bh=seg96an2EVSr8JlAr9r1UxI1Hc4dVBpC3LfTpnNt/6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLJPf7j/lsd06/KarRmVyXoosWZEC16iVWLRNyQLGuDF3y5DRSgL0U3N5mCAZwAfQ
         TIGtZa8MCVl7bSn8ZkQyAqpldx+XCvvo/UyGkElIb3YAS2/KeXaCQjSpejBUDrn/cU
         PZ4xV0FbsjHHh6xDXQVzmv+rWMvExIO2iiQ+bhQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 238/264] pNFS: Dont keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE
Date:   Thu, 23 Jun 2022 18:43:51 +0200
Message-Id: <20220623164350.810605101@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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
index f19cded49b29..317d22f84492 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1753,6 +1753,12 @@ pnfs_update_layout(struct inode *ino,
 			/* Fallthrough */
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



