Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5BB548E82
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353797AbiFML0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353799AbiFMLZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:25:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA23F36B62;
        Mon, 13 Jun 2022 03:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51FD86120F;
        Mon, 13 Jun 2022 10:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5B6C34114;
        Mon, 13 Jun 2022 10:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116950;
        bh=OySBGy14kQnAeQhAIXtumlEjIlkuzyoHj/XmYzIZdBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLOLP7jY7XjpIrz36gdmcy6yDuUDXu6+Hgn6eSMIy1SCt2CB3Daa3jR62cfyU1Aop
         i0ecX9RxK9CT0ecf4/n3UFY7ovj0POv4sa1FrXg0Wcmm1zsyTueA2YqbeUzI0xiHv+
         NA7/2xDOr5gXuUNNymBHoI0xawnDv00CyZ7DQa/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.4 244/411] md: fix an incorrect NULL check in md_reload_sb
Date:   Mon, 13 Jun 2022 12:08:37 +0200
Message-Id: <20220613094936.093138325@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 64c54d9244a4efe9bc6e9c98e13c4bbb8bb39083 upstream.

The bug is here:
	if (!rdev || rdev->desc_nr != nr) {

The list iterator value 'rdev' will *always* be set and non-NULL
by rdev_for_each_rcu(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
found (In fact, it will be a bogus pointer to an invalid struct
object containing the HEAD). Otherwise it will bypass the check
and lead to invalid memory access passing the check.

To fix the bug, use a new variable 'iter' as the list iterator,
while using the original variable 'pdev' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 70bcecdb1534 ("md-cluster: Improve md_reload_sb to be less error prone")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9531,16 +9531,18 @@ static int read_rdev(struct mddev *mddev
 
 void md_reload_sb(struct mddev *mddev, int nr)
 {
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL, *iter;
 	int err;
 
 	/* Find the rdev */
-	rdev_for_each_rcu(rdev, mddev) {
-		if (rdev->desc_nr == nr)
+	rdev_for_each_rcu(iter, mddev) {
+		if (iter->desc_nr == nr) {
+			rdev = iter;
 			break;
+		}
 	}
 
-	if (!rdev || rdev->desc_nr != nr) {
+	if (!rdev) {
 		pr_warn("%s: %d Could not find rdev with nr %d\n", __func__, __LINE__, nr);
 		return;
 	}


