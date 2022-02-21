Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234A34BDC9C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348531AbiBUJ1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349717AbiBUJ0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:26:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FD51EAE0;
        Mon, 21 Feb 2022 01:10:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7895DCE0E86;
        Mon, 21 Feb 2022 09:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7DEC340E9;
        Mon, 21 Feb 2022 09:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434643;
        bh=X3t64FDN0xB/+PCoUxOpRXLTGFWqM9dN/ujkezX3ZVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5llhhUR/D9O78sv+msuC8JabKjpmMGATA/ZtCU04qKKeQElw9/T9a1f0/OR2rxXo
         X10eNjNe7tGBR1W5OKzQV4+C4yuukKEY7uRRqUd7BEdV4ErWqOtZPCee0rt3J430Iw
         1V1cmQDXXocrYoXMS+ubqLE7OOSSISQjqlaECGdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 078/196] selftests: netfilter: fix exit value for nft_concat_range
Date:   Mon, 21 Feb 2022 09:48:30 +0100
Message-Id: <20220221084933.548792789@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

commit 2e71ec1a725a794a16e3862791ed43fe5ba6a06b upstream.

When the nft_concat_range test failed, it exit 1 in the code
specifically.

But when part of, or all of the test passed, it will failed the
[ ${passed} -eq 0 ] check and thus exit with 1, which is the same
exit value with failure result. Fix it by exit 0 when passed is not 0.

Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with range concatenation")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/netfilter/nft_concat_range.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -1583,4 +1583,4 @@ for name in ${TESTS}; do
 	done
 done
 
-[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP}
+[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP} || exit 0


