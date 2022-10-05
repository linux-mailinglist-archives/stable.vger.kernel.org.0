Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03C95F53A7
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiJELiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJELha (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:37:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0827C5F7D2;
        Wed,  5 Oct 2022 04:35:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12039B81DBC;
        Wed,  5 Oct 2022 11:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D02C433D6;
        Wed,  5 Oct 2022 11:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969694;
        bh=6xJcFc9dGQ5BNpTfJqZ6QZWR7Ia24f+OL1DRDtn1inU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiVm6vuE2JUEaVuBx/W7McbEkrCSrmofiF484Q03gJUn+S+fXwEhTi1RuBL5EyF/b
         cWBbxAxVoNdu3pxCI9sn9bqL7MktQltC00PS6ghm+QgaaiQSC1/fFKGarFo9Pv5vfG
         kbEAdrJNmRsuoweEhl62wES5a6HFutptHDKYW9wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 47/51] xfs: fix uninitialized variable in xfs_attr3_leaf_inactive
Date:   Wed,  5 Oct 2022 13:32:35 +0200
Message-Id: <20221005113212.438169634@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 54027a49938bbee1af62fad191139b14d4ee5cd2 upstream.

Dan Carpenter pointed out that error is uninitialized.  While there
never should be an attr leaf block with zero entries, let's not leave
that logic bomb there.

Fixes: 0bb9d159bd01 ("xfs: streamline xfs_attr3_leaf_inactive")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_inactive.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -88,7 +88,7 @@ xfs_attr3_leaf_inactive(
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_attr_leaf_entry	*entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	int				error;
+	int				error = 0;
 	int				i;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);


