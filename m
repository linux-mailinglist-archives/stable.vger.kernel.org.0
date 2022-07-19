Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3419F579ACF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbiGSMU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiGSMSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:18:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583CE491EA;
        Tue, 19 Jul 2022 05:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BE7E6163C;
        Tue, 19 Jul 2022 12:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C99C341C6;
        Tue, 19 Jul 2022 12:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232403;
        bh=0k7NVlTxXI8x9mbUNxoxezqIaOjOC0jRo8R2W4G+jCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWIMneR/LCZBIRzPjJJMjylEcjPLfYbePh2RvgkIilAeXzK36MlWbU73/EyOljBvx
         OF2+WazU46EcQkCSzG1pnTnr5cCT0qAB9ex8DYzIzN/IIRKFZDuxn0NIsNvzGy5PZR
         SIIIMCSJnpkPwSxYDDKTT5rdnRh2gtk8cbfwMBpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/112] sysctl: Fix data races in proc_douintvec_minmax().
Date:   Tue, 19 Jul 2022 13:53:38 +0200
Message-Id: <20220719114630.797438336@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 2d3b559df3ed39258737789aae2ae7973d205bc1 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_douintvec_minmax() to use READ_ONCE() and
WRITE_ONCE() internally to fix data-races on the sysctl side.  For now,
proc_douintvec_minmax() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

Fixes: 61d9b56a8920 ("sysctl: add unsigned int range support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1800907da60c..df6090ba1d0b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1025,7 +1025,7 @@ static int do_proc_douintvec_minmax_conv(unsigned long *lvalp,
 		    (param->max && *param->max < tmp))
 			return -ERANGE;
 
-		*valp = tmp;
+		WRITE_ONCE(*valp, tmp);
 	}
 
 	return 0;
-- 
2.35.1



