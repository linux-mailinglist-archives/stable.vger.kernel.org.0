Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED24F2B9C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344442AbiDEKjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiDEJgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:36:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF79798F7F;
        Tue,  5 Apr 2022 02:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D7A961548;
        Tue,  5 Apr 2022 09:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F4FC385A3;
        Tue,  5 Apr 2022 09:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150662;
        bh=4JilkGpXUFStr7DuFbAb05Cf5KlVYYVNVPbAujUtgkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYhoSuchJ4TdsosCI44ZBMG/A9qrRbeGmcdbGziPsf0BaRcIi7UK8yKjzj3FlOz/p
         BfDAmzcHAzstl9rwrNoTURCvMB6N9EcghRGj/GO+qliKTcLX8mozMjAN+J0UbLgmuj
         eya8NTI0sBwqSbM618sCA18rjM5T6JEXsORYNwQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH 5.15 136/913] samples/landlock: Fix path_list memory leak
Date:   Tue,  5 Apr 2022 09:19:58 +0200
Message-Id: <20220405070343.906949918@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

commit 66b513b7c64a7290c1fbb88e657f7cece992e131 upstream.

Clang static analysis reports this error

sandboxer.c:134:8: warning: Potential leak of memory
  pointed to by 'path_list'
        ret = 0;
              ^
path_list is allocated in parse_path() but never freed.

Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20210428213852.2874324-1-trix@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/landlock/sandboxer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -134,6 +134,7 @@ static int populate_ruleset(
 	ret = 0;
 
 out_free_name:
+	free(path_list);
 	free(env_path_name);
 	return ret;
 }


