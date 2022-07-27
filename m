Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E27582DA8
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241253AbiG0RBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241480AbiG0Q7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:59:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E255469F31;
        Wed, 27 Jul 2022 09:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6183FB821CB;
        Wed, 27 Jul 2022 16:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF687C433D6;
        Wed, 27 Jul 2022 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939862;
        bh=x6twVJUTKOoXyXY/6nUmkDDzHd1kvJiKG2CYgWRP7kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qT1lL6vQMzQDpaELapVTY4wTKc4rFJ2OgLQMxGlvK8VItS9I8TgUYsl4zv3ogWJBB
         s1qCQRhpm+m6UAOVfjUif77ZgH1rSkdYIRcbIuyZHfOxInt9yo/oI42YjIZuCT0fXe
         S14X3nIb7AvTcghNblZNsWEKTMzgR7GLapJifHMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 024/201] xfs: terminate perag iteration reliably on agcount
Date:   Wed, 27 Jul 2022 18:08:48 +0200
Message-Id: <20220727161027.897328210@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 8ed004eb9d07a5d6114db3e97a166707c186262d ]

The for_each_perag_from() iteration macro relies on sb_agcount to
process every perag currently within EOFS from a given starting
point. It's perfectly valid to have perag structures beyond
sb_agcount, however, such as if a growfs is in progress. If a perag
loop happens to race with growfs in this manner, it will actually
attempt to process the post-EOFS perag where ->pag_agno ==
sb_agcount. This is reproduced by xfs/104 and manifests as the
following assert failure in superblock write verifier context:

 XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22

Update the corresponding macro to only process perags that are
within the current sb_agcount.

Fixes: 58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -142,7 +142,7 @@ xfs_perag_next(
 		(pag) = xfs_perag_next((pag), &(agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
-	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \


