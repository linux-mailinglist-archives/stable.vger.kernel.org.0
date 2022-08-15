Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563835946AB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345356AbiHOXAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245438AbiHOW6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE75E46DAA;
        Mon, 15 Aug 2022 12:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD76612A4;
        Mon, 15 Aug 2022 19:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699F3C433C1;
        Mon, 15 Aug 2022 19:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593424;
        bh=Mt7AGGcZfiDtZCpqwjCJ+SIH9BMtPjFp1JhQA7qDVTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqZvtZgDelkAtKmEH9wBRNm6W4CETkCeK06SIhKwARIlBuHPUHadGTn4xcICdoG41
         nVpU3YmPjdKQQRNQ/3m0LjBUq+X8O+mOk1WR9ZI0y+IK2E6OoAH/Jp+EuiiVcrAh6P
         mzaPJ/HMZA7SB5yY4QVM58brT9rDp5SP5n6gXIGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0944/1095] scripts/faddr2line: Fix vmlinux detection on arm64
Date:   Mon, 15 Aug 2022 20:05:43 +0200
Message-Id: <20220815180508.218799444@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 94ed98dd899f..57099687e5e1 100755
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



