Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305BC50F44B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbiDZIf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345550AbiDZIen (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FE778FF9;
        Tue, 26 Apr 2022 01:27:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3550B81CF2;
        Tue, 26 Apr 2022 08:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACD4C385A0;
        Tue, 26 Apr 2022 08:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961660;
        bh=hwfjXND5lWJxfc1ZH9AR78hx36ahGd29wxnqRyHV4U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqceYgVQnkgZEoLBUtERubo5cIy73xQqR4dDmDTfxvGjtu+jTM5nh3McqN0xPRJNA
         ve97CoiBB8eebUEW4xkwIVV/AH6wlcHJ863Uz9YIzLPcqZrXu96BITL67TJPuVcl9V
         3w21ATowG2JXF9/38uAFSbxfoMuo2eGY9coNUU/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.19 42/53] ext4: force overhead calculation if the s_overhead_cluster makes no sense
Date:   Tue, 26 Apr 2022 10:21:22 +0200
Message-Id: <20220426081736.880345111@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

commit 85d825dbf4899a69407338bae462a59aa9a37326 upstream.

If the file system does not use bigalloc, calculating the overhead is
cheap, so force the recalculation of the overhead so we don't have to
trust the precalculated overhead in the superblock.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4423,9 +4423,18 @@ no_journal:
 	 * Get the # of file system overhead blocks from the
 	 * superblock if present.
 	 */
-	if (es->s_overhead_clusters)
-		sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
-	else {
+	sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
+	/* ignore the precalculated value if it is ridiculous */
+	if (sbi->s_overhead > ext4_blocks_count(es))
+		sbi->s_overhead = 0;
+	/*
+	 * If the bigalloc feature is not enabled recalculating the
+	 * overhead doesn't take long, so we might as well just redo
+	 * it to make sure we are using the correct value.
+	 */
+	if (!ext4_has_feature_bigalloc(sb))
+		sbi->s_overhead = 0;
+	if (sbi->s_overhead == 0) {
 		err = ext4_calculate_overhead(sb);
 		if (err)
 			goto failed_mount_wq;


