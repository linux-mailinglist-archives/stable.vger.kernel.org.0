Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A0F4BE99B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349957AbiBUJcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:32:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350010AbiBUJcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:32:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371F527FCB;
        Mon, 21 Feb 2022 01:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9AD59CE0E86;
        Mon, 21 Feb 2022 09:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDB5C340E9;
        Mon, 21 Feb 2022 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434809;
        bh=1RWRw81HnhA40n4kQ9w8rLZmB3UuvQzSg293F+N1jEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrE5DRSCAEHFhy6yi2xm7wP+/MboJhRvdYbwz/PaAXhCvdasiInFvmtYtjGYzXsG+
         rAcVlA175J3NS5nn97xVJV/sMmWEvn7h1pDTNQitWsDLkSP72E6sEfJ5nchHry69XL
         BBuvH1hYEtnwZDfv2J52XgW6EH0RxXtxkJfVIB+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 138/196] mtd: parsers: qcom: Fix missing free for pparts in cleanup
Date:   Mon, 21 Feb 2022 09:49:30 +0100
Message-Id: <20220221084935.533809199@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

commit 3dd8ba961b9356c4113b96541c752c73d98fef70 upstream.

Mtdpart doesn't free pparts when a cleanup function is declared.
Add missing free for pparts in cleanup function for smem to fix the
leak.

Fixes: 10f3b4d79958 ("mtd: parsers: qcom: Fix leaking of partition name")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220116032211.9728-2-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/parsers/qcomsmempart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -173,6 +173,8 @@ static void parse_qcomsmem_cleanup(const
 
 	for (i = 0; i < nr_parts; i++)
 		kfree(pparts[i].name);
+
+	kfree(pparts);
 }
 
 static const struct of_device_id qcomsmem_of_match_table[] = {


