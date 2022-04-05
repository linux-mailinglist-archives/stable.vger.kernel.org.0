Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640124F2B28
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbiDEJEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242801AbiDEItd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:49:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B061A75602;
        Tue,  5 Apr 2022 01:37:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB675B81C15;
        Tue,  5 Apr 2022 08:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30787C385A7;
        Tue,  5 Apr 2022 08:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147847;
        bh=4JilkGpXUFStr7DuFbAb05Cf5KlVYYVNVPbAujUtgkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKRUsMt+Ix78VulN/E/Kb9AWShbephKVVc+p5UnEjdeaB/l8FQTMteSIyKDZiSIyh
         xXJmj/b5Tsx8U7HORG8XA0YOnna1hJlQNmpAE60RKP4x6HJkQlyCyvg9xVdqS5p02a
         s8FZWqSal2SV87ux38BESKrBFzJyq7UJyDI/TXhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH 5.16 0142/1017] samples/landlock: Fix path_list memory leak
Date:   Tue,  5 Apr 2022 09:17:35 +0200
Message-Id: <20220405070358.418907818@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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


