Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E456A0A3D
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbjBWNNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbjBWNNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB215708E
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:13:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0A4F61706
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD288C433EF;
        Thu, 23 Feb 2023 13:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157972;
        bh=/oHX/FS3261RrazsFaq9IF48263e4WS1cQHL6mlQeuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/pPuw5NI9mKHWOrmovvPORhOfRDFkry+gkfZ8e6KHzb/OP3ZR/3QJwA3/9NT3mv3
         3c12kl7ksEgw6UJ5oQwi9n8e3kYFNHHSizkf8Q49lxUKMJMYxv5exNIu7sRGUr7BIG
         De5Jp3+8LD6CPzJWcamxdtJa8wUNTLL/nvhEHb9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.15 33/36] scripts/pahole-flags.sh: Use pahole-version.sh
Date:   Thu, 23 Feb 2023 14:07:09 +0100
Message-Id: <20230223130430.571823567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 2d6c9810eb8915c4ddede707b8e167a1d919e1ca upstream.

Use pahole-version.sh to get pahole's version code to reduce the amount
of duplication across the tree.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-4-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/pahole-flags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -7,7 +7,7 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; t
 	exit 0
 fi
 
-pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+pahole_ver=$($(dirname $0)/pahole-version.sh ${PAHOLE})
 
 if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
 	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars


