Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10010521B30
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244618AbiEJOJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344168AbiEJOHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2124D201317;
        Tue, 10 May 2022 06:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E64D6615E9;
        Tue, 10 May 2022 13:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018F4C385A6;
        Tue, 10 May 2022 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190110;
        bh=yoCwmthqTWLrTpChDssSy8r1GU2Q8VGPcgaoXwsiVu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bslENd1HuyKKtn/XNUOE40mKJmYQLNKDGJSsOcgeBR4RKTg0t7u0EXqJqDbIGfocn
         5PpJvlXO8ugN6HMbdndDg9hfWW9PqUgAtVTEKRCeLljeti2sfbjqD811GyyrbsUAso
         2jVna7+/AWMVPvBGZRrCfikTFehlv1vnDbAXq3J4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.17 091/140] selftests/net: so_txtime: fix parsing of start time stamp on 32 bit systems
Date:   Tue, 10 May 2022 15:08:01 +0200
Message-Id: <20220510130744.211645827@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 97926d5a847ca1758ad8702ce591e3b05a701e0d upstream.

This patch fixes the parsing of the cmd line supplied start time on 32
bit systems. A "long" on 32 bit systems is only 32 bit wide and cannot
hold a timestamp in nano second resolution.

Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20220502094638.1921702-2-mkl@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/so_txtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -475,7 +475,7 @@ static void parse_opts(int argc, char **
 			cfg_rx = true;
 			break;
 		case 't':
-			cfg_start_time_ns = strtol(optarg, NULL, 0);
+			cfg_start_time_ns = strtoll(optarg, NULL, 0);
 			break;
 		case 'm':
 			cfg_mark = strtol(optarg, NULL, 0);


