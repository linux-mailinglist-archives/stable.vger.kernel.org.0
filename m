Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24E85EA15B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiIZKul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbiIZKss (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:48:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D8E57278;
        Mon, 26 Sep 2022 03:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B847FB80915;
        Mon, 26 Sep 2022 10:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA1AC433D6;
        Mon, 26 Sep 2022 10:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187976;
        bh=/TEysB9aXAw6YnUMtjKbjnb69VGEdNqHrGLDObPJF5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hS3e95NbOTHLUINvhaeGilYA9V6u+3Ng3xqdrx21+Ei8lqCtpvT0ZuvTmfPLL/TDi
         /2ZvLAaFTkr/cM7jJg82JjWC67lklXIgfvsdybHlPgh95/1afz/fYLfx88ioYeH6yS
         AhjD4A1BSZ56zbdtEtGFdNohyVZ5eoiOmUqGXmSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 106/120] xfs: add missing assert in xfs_fsmap_owner_from_rmap
Date:   Mon, 26 Sep 2022 12:12:19 +0200
Message-Id: <20220926100754.842710680@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 110f09cb705af8c53f2a457baf771d2935ed62d4 upstream.

The fsmap handler shouldn't fail silently if the rmap code ever feeds it
a special owner number that isn't known to the fsmap handler.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_fsmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -146,6 +146,7 @@ xfs_fsmap_owner_from_rmap(
 		dest->fmr_owner = XFS_FMR_OWN_FREE;
 		break;
 	default:
+		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 	return 0;


