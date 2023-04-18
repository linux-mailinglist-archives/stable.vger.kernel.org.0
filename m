Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67F26E630D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjDRMhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbjDRMhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:37:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32A3E63
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E255632B3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9175AC433D2;
        Tue, 18 Apr 2023 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821450;
        bh=1y4PA2klK5CJIppKYN0NfdsAoMVOfzFHA8PPCfP8ovY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k36PcwAGlPyI4CMnvlEngXVJGLiOHSBer4jC1Cz61xh29MHTdcn00I9ts4Yyo2XGL
         RNqzKoUWaDJsI/FOtOgNbvPQDNyydWEYqrHyrVEyIULD7cXYicnNsaO2c9D4hzzLg7
         sIM5nCWFxBoo9lSZiQo00Zh2KE2l8sn/JeIsTyoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 124/124] sysctl: Fix data-races in proc_dou8vec_minmax().
Date:   Tue, 18 Apr 2023 14:22:23 +0200
Message-Id: <20230418120314.256095418@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 7dee5d7747a69aa2be41f04c6a7ecfe3ac8cdf18 upstream.

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_dou8vec_minmax() to use READ_ONCE() and
WRITE_ONCE() internally to fix data-races on the sysctl side.  For now,
proc_dou8vec_minmax() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

Fixes: cb9444130662 ("sysctl: add proc_dou8vec_minmax()")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1109,13 +1109,13 @@ int proc_dou8vec_minmax(struct ctl_table
 
 	tmp.maxlen = sizeof(val);
 	tmp.data = &val;
-	val = *data;
+	val = READ_ONCE(*data);
 	res = do_proc_douintvec(&tmp, write, buffer, lenp, ppos,
 				do_proc_douintvec_minmax_conv, &param);
 	if (res)
 		return res;
 	if (write)
-		*data = val;
+		WRITE_ONCE(*data, val);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);


