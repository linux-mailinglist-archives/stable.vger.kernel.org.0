Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78ECD579BD4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbiGSMc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiGSMcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:32:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5D46F7CE;
        Tue, 19 Jul 2022 05:12:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A176B81B37;
        Tue, 19 Jul 2022 12:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F0FC341CE;
        Tue, 19 Jul 2022 12:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232713;
        bh=LImAdXCTNx1YClH8FEaycD4Q8yoRVyjvoe4rawmcKfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IH6yoco+wmYardx2AtuSluZYciXQR+4/DaQmZdUA5lBUfhivt0GsaRJ3/Ex3wrkTo
         IXyx9a4P7Xxj3OcCAP9B1hVtShNaX1pMvvU1uAA24PF+6i605u5oX7cNXFfHH9z1Pz
         OMh6RTvKrZR5B855qWvpcvBvX/q/WSVVuZS5OJME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ansgar=20L=C3=B6=C3=9Fer?= 
        <ansgar.loesser@tu-darmstadt.de>,
        Dave Chinner <dchinner@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 022/167] fs/remap: constrain dedupe of EOF blocks
Date:   Tue, 19 Jul 2022 13:52:34 +0200
Message-Id: <20220719114658.901074235@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 5750676b64a561f7ec920d7c6ba130fc9c7378f3 upstream.

If dedupe of an EOF block is not constrainted to match against only
other EOF blocks with the same EOF offset into the block, it can
match against any other block that has the same matching initial
bytes in it, even if the bytes beyond EOF in the source file do
not match.

Fix this by constraining the EOF block matching to only match
against other EOF blocks that have identical EOF offsets and data.
This allows "whole file dedupe" to continue to work without allowing
eof blocks to randomly match against partial full blocks with the
same data.

Reported-by: Ansgar Lößer <ansgar.loesser@tu-darmstadt.de>
Fixes: 1383a7ed6749 ("vfs: check file ranges before cloning files")
Link: https://lore.kernel.org/linux-fsdevel/a7c93559-4ba1-df2f-7a85-55a143696405@tu-darmstadt.de/
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/remap_range.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -71,7 +71,8 @@ static int generic_remap_checks(struct f
 	 * Otherwise, make sure the count is also block-aligned, having
 	 * already confirmed the starting offsets' block alignment.
 	 */
-	if (pos_in + count == size_in) {
+	if (pos_in + count == size_in &&
+	    (!(remap_flags & REMAP_FILE_DEDUP) || pos_out + count == size_out)) {
 		bcount = ALIGN(size_in, bs) - pos_in;
 	} else {
 		if (!IS_ALIGNED(count, bs))


