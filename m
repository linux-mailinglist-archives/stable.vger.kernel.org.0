Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC33561C77
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbiF3N7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiF3N7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BE942A16;
        Thu, 30 Jun 2022 06:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6276761FDB;
        Thu, 30 Jun 2022 13:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A5DC34115;
        Thu, 30 Jun 2022 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597116;
        bh=yDKIfKcX24yBIYaS0ER4IhweXDKsRCSF3+Lp+lb3ado=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGaVUJ7qck4P2vNxXHfYszRsXzQ331PS5rq+CJtqLfXonWEsyLICMRDr0GQ6BLu3g
         jvD4hpXfIcimU8/leZtP6jfxBlOcezoukIEhyjeK+CPmn8UeqDCYhTiVYmGBJ8mcVr
         sdlsOEB3UfDRvyIlG8jsGPyUQAnkjq+7YBRZjca4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathvika Vasireddy <sathvika@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 33/49] powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address
Date:   Thu, 30 Jun 2022 15:46:46 +0200
Message-Id: <20220630133234.862929190@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Donnellan <ajd@linux.ibm.com>

commit 7bc08056a6dabc3a1442216daf527edf61ac24b6 upstream.

Add a special case to block_rtas_call() to allow the ibm,platform-dump RTAS
call through the RTAS filter if the buffer address is 0.

According to PAPR, ibm,platform-dump is called with a null buffer address
to notify the platform firmware that processing of a particular dump is
finished.

Without this, on a pseries machine with CONFIG_PPC_RTAS_FILTER enabled, an
application such as rtas_errd that is attempting to retrieve a dump will
encounter an error at the end of the retrieval process.

Fixes: bd59380c5ba4 ("powerpc/rtas: Restrict RTAS requests from userspace")
Cc: stable@vger.kernel.org
Reported-by: Sathvika Vasireddy <sathvika@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220614134952.156010-1-ajd@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/rtas.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1105,7 +1105,7 @@ static struct rtas_filter rtas_filters[]
 	{ "get-time-of-day", -1, -1, -1, -1, -1 },
 	{ "ibm,get-vpd", -1, 0, -1, 1, 2 },
 	{ "ibm,lpar-perftools", -1, 2, 3, -1, -1 },
-	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },
+	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },		/* Special cased */
 	{ "ibm,read-slot-reset-state", -1, -1, -1, -1, -1 },
 	{ "ibm,scan-log-dump", -1, 0, 1, -1, -1 },
 	{ "ibm,set-dynamic-indicator", -1, 2, -1, -1, -1 },
@@ -1152,6 +1152,15 @@ static bool block_rtas_call(int token, i
 				size = 1;
 
 			end = base + size - 1;
+
+			/*
+			 * Special case for ibm,platform-dump - NULL buffer
+			 * address is used to indicate end of dump processing
+			 */
+			if (!strcmp(f->name, "ibm,platform-dump") &&
+			    base == 0)
+				return false;
+
 			if (!in_rmo_buf(base, end))
 				goto err;
 		}


