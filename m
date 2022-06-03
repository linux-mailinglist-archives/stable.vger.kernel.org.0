Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F234153D0A3
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346647AbiFCSIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348060AbiFCSGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:06:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD7D5DD3A;
        Fri,  3 Jun 2022 10:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44F066158E;
        Fri,  3 Jun 2022 17:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D1FC385A9;
        Fri,  3 Jun 2022 17:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279142;
        bh=jRo0E2UCuPCv1JfLpdMudZFaAv6Om2hSVnmaYr/kXRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qk5IaJhIWTzVXOVE2jLUKzcnSV4GQOLRO03A1ROtGXU9ukoPnQnn62c3zcZOe4jTz
         Io9jgAAw8MmoZxfAux5GRtPzbq/o+Y/YEx+rMG9TvfdLXcI0+Ooox1NGDk+2D4cfD2
         wFbE180SaaSQM7vCLAWe2lu16bVZKZsgLHzhY6bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.18 39/67] dm integrity: fix error code in dm_integrity_ctr()
Date:   Fri,  3 Jun 2022 19:43:40 +0200
Message-Id: <20220603173821.860340294@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
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
@@ -4494,8 +4494,6 @@ try_smaller_buffer:
 	}
 
 	if (should_write_sb) {
-		int r;
-
 		init_journal(ic, 0, ic->journal_sections, 0);
 		r = dm_integrity_failed(ic);
 		if (unlikely(r)) {


