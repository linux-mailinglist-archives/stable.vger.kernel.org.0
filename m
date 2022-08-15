Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5823E594985
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354868AbiHOXzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355972AbiHOXx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:53:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4906D15BBB7;
        Mon, 15 Aug 2022 13:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9768BB80EA8;
        Mon, 15 Aug 2022 20:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB55C433C1;
        Mon, 15 Aug 2022 20:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594680;
        bh=twaGXF0MvgZEXkpoKJrkeQCigkqeCs2jGuviee0Fe20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlBFdAEmb/KviagQE9qBjAub9kaY6CPDpQsQyY21Aw4/x7cS5VLOAyAc5Pf0mpLI+
         fiD15xv4ER77M65Nc3ynEfEnEkFWelJ0kFEJYM/2LjDMWvMh5caTcqg4VVuyM3nKhJ
         X4eio71mKfQOa3sYivzg/5XsLye0szzLS+Gv+Wfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0525/1157] libbpf: Fix str_has_sfx()s return value
Date:   Mon, 15 Aug 2022 19:58:01 +0200
Message-Id: <20220815180500.671777579@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 14229b8153a3ca51d97a22a18c68deeae64afce0 ]

The return from strcmp() is inverted so it wrongly returns true instead
of false and vice versa.

Fixes: a1c9d61b19cb ("libbpf: Improve library identification for uprobe binary path resolution")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Cc: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/YtZ+/dAA195d99ak@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf_internal.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index ef5d975078e5..230ac5699c3d 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -109,9 +109,9 @@ static inline bool str_has_sfx(const char *str, const char *sfx)
 	size_t str_len = strlen(str);
 	size_t sfx_len = strlen(sfx);
 
-	if (sfx_len <= str_len)
-		return strcmp(str + str_len - sfx_len, sfx);
-	return false;
+	if (sfx_len > str_len)
+		return false;
+	return strcmp(str + str_len - sfx_len, sfx) == 0;
 }
 
 /* Symbol versioning is different between static and shared library.
-- 
2.35.1



