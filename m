Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF2C65BC0B
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237149AbjACISf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237170AbjACISO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:18:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265BBDFDE
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3215611F0
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CB5C433D2;
        Tue,  3 Jan 2023 08:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733862;
        bh=A9/b80xT1iHjOny/pzsDuVwkd0urpwxguN1fTH2A5Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m78eCPENZy8Wk3oRISOSRWSD5DLadRlBEwZGCayRDcZYceLtBn2KWzdSwdZNZP0bi
         d03l7zOsAiVNbZVv3E63ay5UaCsztu5w3/HK72ToVbrhf2HfnJOz5krqg+UeRNH/7C
         so6rJtQHf+Ra1lklrOJPzgeF4P65cSjl96Id0EwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 60/63] Revert "proc: dont allow async path resolution of /proc/self components"
Date:   Tue,  3 Jan 2023 09:14:30 +0100
Message-Id: <20230103081312.226781789@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 9e8d9e829c2142cf1d7756e9ed2e0b4c7569d84c ]

This reverts commit 8d4c3e76e3be11a64df95ddee52e99092d42fc19.

No longer needed, as the io-wq worker threads have the right identity.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/self.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -16,13 +16,6 @@ static const char *proc_self_get_link(st
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name;
 
-	/*
-	 * Not currently supported. Once we can inherit all of struct pid,
-	 * we can allow this.
-	 */
-	if (current->flags & PF_KTHREAD)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	if (!tgid)
 		return ERR_PTR(-ENOENT);
 	/* max length of unsigned int in decimal + NULL term */


