Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA0F53CE6B
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344857AbiFCRmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344756AbiFCRlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE6B53A51;
        Fri,  3 Jun 2022 10:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A975361B00;
        Fri,  3 Jun 2022 17:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9955BC385A9;
        Fri,  3 Jun 2022 17:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278074;
        bh=nEEt0MjSOfaKM23Di3zdTZzjV4Q96cjTsIQFdDcNp/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5gKrqq7HPbZxESwJQPR2fsnAHre+aQgy3g4fG24Ufyk0uf6J3Dz/8xShx2hQZc5+
         2lG6/9mShwFMbcubmTnwg0NS+hWwNlnlpiOI738FNJ5/7BsWLaXMTbOKU48hnfzIjr
         z0Zd20snTy2Ted0gMWLkrjBtyTJCW9Jht4SYonwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.14 16/23] dm integrity: fix error code in dm_integrity_ctr()
Date:   Fri,  3 Jun 2022 19:39:43 +0200
Message-Id: <20220603173814.856716104@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173814.362515009@linuxfoundation.org>
References: <20220603173814.362515009@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d3f2a14b8906df913cb04a706367b012db94a6e8 upstream.

The "r" variable shadows an earlier "r" that has function scope.  It
means that we accidentally return success instead of an error code.
Smatch has a warning for this:

	drivers/md/dm-integrity.c:4503 dm_integrity_ctr()
	warn: missing error code 'r'

Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3156,8 +3156,6 @@ static int dm_integrity_ctr(struct dm_ta
 	}
 
 	if (should_write_sb) {
-		int r;
-
 		init_journal(ic, 0, ic->journal_sections, 0);
 		r = dm_integrity_failed(ic);
 		if (unlikely(r)) {


