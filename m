Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF3D59E05E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355916AbiHWKs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355852AbiHWKo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:44:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E203574E0E;
        Tue, 23 Aug 2022 02:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91B2CB81C66;
        Tue, 23 Aug 2022 09:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B8BC433C1;
        Tue, 23 Aug 2022 09:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245843;
        bh=blwVWMpUy9hCuLKBJidBkAIAlZ68adKolCiqqm6WzoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp+Fdv3lgGJN5YQx3vPGqIhE201itmh1yzzn+K0ghJL1OvEAwjC5E0WKpOfjWjNTA
         LUZyaZ+dq4XHWusd+K6tRsxN6/oD+i6yNC2eQHboDdR0nOr4qbnI4kTcSlDvwIfjIc
         xE8OtPTkPsvSFeAN0cNcY9VwNFX3CqTdZRL+yNAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/287] scripts/faddr2line: Fix vmlinux detection on arm64
Date:   Tue, 23 Aug 2022 10:25:46 +0200
Message-Id: <20220823080106.731482839@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit b6a5068854cfe372da7dee3224dcf023ed5b00cb ]

Since commit dcea997beed6 ("faddr2line: Fix overlapping text section
failures, the sequel"), faddr2line is completely broken on arm64.

For some reason, on arm64, the vmlinux ELF object file type is ET_DYN
rather than ET_EXEC.  Check for both when determining whether the object
is vmlinux.

Modules and vmlinux.o have type ET_REL on all arches.

Fixes: dcea997beed6 ("faddr2line: Fix overlapping text section failures, the sequel")
Reported-by: John Garry <john.garry@huawei.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/dad1999737471b06d6188ce4cdb11329aa41682c.1658426357.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/faddr2line | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/faddr2line b/scripts/faddr2line
index 2571caac3156..70f8c3ecd555 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -112,7 +112,9 @@ __faddr2line() {
 	# section offsets.
 	local file_type=$(${READELF} --file-header $objfile |
 		${AWK} '$1 == "Type:" { print $2; exit }')
-	[[ $file_type = "EXEC" ]] && is_vmlinux=1
+	if [[ $file_type = "EXEC" ]] || [[ $file_type == "DYN" ]]; then
+		is_vmlinux=1
+	fi
 
 	# Go through each of the object's symbols which match the func name.
 	# In rare cases there might be duplicates, in which case we print all
-- 
2.35.1



